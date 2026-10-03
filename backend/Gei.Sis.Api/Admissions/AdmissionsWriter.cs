using System.Data;
using System.Globalization;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text.Json;
using Microsoft.Data.SqlClient;
using Microsoft.Identity.Web;

namespace Gei.Sis.Api.Admissions;

public sealed class AdmissionsWriter(AdmissionsRepository repository)
{
    private static (Guid tenant, Guid actor) Actor(ClaimsPrincipal principal)
    {
        if (!Guid.TryParse(principal.GetTenantId(), out var tenant) ||
            !Guid.TryParse(principal.GetObjectId(), out var actor))
            throw new AdmissionsException(403, "staff_identity_missing", "تعذر التحقق من هوية الموظف.");
        return (tenant, actor);
    }
    private async Task RequireWriteSchema(SqlConnection connection, CancellationToken ct, SqlTransaction tx)
    {
        if (!repository.WritesEnabled)
            throw new AdmissionsException(503, "admissions_writes_disabled", "الكتابة متوقفة حتى اكتمال تجهيز القبول وإيقاف النظام القديم.");
        if (!await AdmissionsRepository.HasSupportSchemaAsync(connection, ct, tx) ||
            !await AdmissionsRepository.HasStudentVersionAsync(connection, ct, tx))
            throw new AdmissionsException(503, "admissions_setup_required", "لم تُطبق جداول دعم القبول وإصدار سجل الطالب بعد.");
    }
    private static async Task<(int yearId, int semesterId, string prefix)> ActiveContext(SqlConnection connection, SqlTransaction tx, CancellationToken ct)
    {
        await using var command = AdmissionsRepository.Command(connection, """
            SELECT TOP (2) a.AdmissionYear,a.AdmissionsSemester,y.ActualYear,s.YearId AS SemesterYearId,s.Hide
            FROM dbo.ActiveSemesters a WITH (UPDLOCK,HOLDLOCK)
            LEFT JOIN dbo.Years y ON y.YearId=a.AdmissionYear
            LEFT JOIN dbo.Semesters s ON s.SemesterId=a.AdmissionsSemester
            ORDER BY a.Id
            """, tx);
        await using var reader = await command.ExecuteReaderAsync(ct);
        if (!await reader.ReadAsync(ct)) throw new AdmissionsException(503, "admissions_configuration_missing", "إعدادات القبول غير موجودة.");
        int? yearId = reader.IsDBNull(0) ? null : reader.GetInt32(0);
        int? semesterId = reader.IsDBNull(1) ? null : reader.GetInt32(1);
        var prefix = reader.IsDBNull(2) ? null : reader.GetString(2);
        int? semesterYear = reader.IsDBNull(3) ? null : reader.GetInt32(3);
        var hidden = !reader.IsDBNull(4) && reader.GetBoolean(4);
        if (await reader.ReadAsync(ct)) throw new AdmissionsException(503, "admissions_configuration_ambiguous", "يوجد أكثر من إعداد قبول نشط.");
        if (yearId is null || semesterId is null || prefix is null || prefix.Length != 4 || !prefix.All(char.IsAsciiDigit) || semesterYear != yearId || hidden)
            throw new AdmissionsException(503, "admissions_configuration_invalid", "اضبط سنة وفصل القبول في ActiveSemesters بشكل متوافق قبل إضافة طالب.");
        return (yearId.Value, semesterId.Value, prefix);
    }
    private static async Task ValidateForSave(SqlConnection connection, SqlTransaction tx, StudentInput form, bool create, CancellationToken ct)
    {
        var errors = AdmissionsValidation.Validate(form, create);
        if (errors.Count != 0) throw new AdmissionsException(400, "validation_failed", "راجع الحقول المطلوبة أو غير الصحيحة.", errors);
        if (form.Nationality is null) throw new AdmissionsException(400, "nationality_required", "اختر الجنسية.");
        await using var nationality = AdmissionsRepository.Command(connection, "SELECT ArNationalityName FROM dbo.Nationalities WHERE NationalityId=@id AND Hide=0", tx);
        AdmissionsRepository.Add(nationality, "@id", SqlDbType.Int, form.Nationality);
        var label = (string?)await nationality.ExecuteScalarAsync(ct);
        if (label is null) throw new AdmissionsException(400, "invalid_nationality", "الجنسية المحددة غير متاحة.");
        // The legacy data uses NationalityId=1 for 'مصري'. Verify the label as well
        // so a future lookup change cannot silently invert ID requirements.
        var isEgyptian = form.Nationality == 1 && label.Trim() == "مصري";
        if (form.Nationality == 1 && !isEgyptian)
            throw new AdmissionsException(503, "egyptian_nationality_changed", "تغير ترميز الجنسية المصرية؛ راجع الإعدادات.");
        if (isEgyptian && !AdmissionsValidation.ValidEgyptianId(AdmissionsRepository.Clean(form.NationalId), form.DateOfBirth))
            throw new AdmissionsException(400, "invalid_national_id", "الرقم القومي المصري يجب أن يتكون من ١٤ رقماً ويطابق تاريخ الميلاد.");
        if (!isEgyptian && string.IsNullOrWhiteSpace(form.PassportId))
            throw new AdmissionsException(400, "passport_required", "رقم جواز السفر مطلوب للطالب غير المصري.");
        foreach (var lookup in new (string table, string key, int? value)[]
        {
            ("dbo.Locations", "LocationId", form.PlaceOfBirth), ("dbo.Departments", "DepartmentId", 1),
            ("dbo.Certificates", "CertificateId", form.Certificate.CertificateId),
            ("dbo.Locations", "LocationId", form.Certificate.CountryLocationId),
            ("dbo.Years", "YearId", form.Certificate.YearId),
            ("dbo.Locations", "LocationId", form.Contact.AddressLocationId),
            ("dbo.Activities", "ActivityId", form.Activity.ActivityId),
            ("dbo.Hoppies", "HoppyId", form.HobbyId),
            ("dbo.InstituteStatments", "InstituteStatmentId", form.InstituteStatementId)
        })
        {
            await using var check = AdmissionsRepository.Command(connection, $"SELECT COUNT_BIG(1) FROM {lookup.table} WHERE {lookup.key}=@id", tx);
            AdmissionsRepository.Add(check, "@id", SqlDbType.Int, lookup.value);
            if (Convert.ToInt64(await check.ExecuteScalarAsync(ct)) != 1)
                throw new AdmissionsException(400, "invalid_lookup", $"قيمة مرجعية غير معروفة: {lookup.table}.");
        }
        foreach (var lookup in new (string table, string key, int? value)[]
        {
            ("dbo.Locations", "LocationId", form.NationalIdReleaseZone),
            ("dbo.Languages", "LanguageId", form.FirstForeignLanguage),
            ("dbo.Languages", "LanguageId", form.SecondForeignLanguage),
            ("dbo.ArmyStatus", "ArmyId", form.ArmyStatusId),
            ("dbo.AcceptanceTypes", "AcceptanceId", form.AcceptanceTypeId),
            ("dbo.Students_Enrollment_Status", "Id", form.EnrollmentStatusId)
        })
        {
            if (lookup.value is null) continue;
            await using var check = AdmissionsRepository.Command(connection, $"SELECT COUNT_BIG(1) FROM {lookup.table} WHERE {lookup.key}=@id", tx);
            AdmissionsRepository.Add(check, "@id", SqlDbType.Int, lookup.value);
            if (Convert.ToInt64(await check.ExecuteScalarAsync(ct)) != 1)
                throw new AdmissionsException(400, "invalid_lookup", $"قيمة مرجعية غير معروفة: {lookup.table}.");
        }
    }
    private static async Task CheckDuplicates(SqlConnection connection, SqlTransaction tx, StudentInput form, int? excludeId, CancellationToken ct)
    {
        // Lock the legacy table through the transaction. The final unique code index
        // remains a separate reviewed migration; this lock also serializes legacy writes.
        await using var command = AdmissionsRepository.Command(connection, """
            SELECT COUNT_BIG(1) FROM dbo.Students WITH (TABLOCKX,HOLDLOCK)
            WHERE (@exclude IS NULL OR StudentId<>@exclude)
              AND ((@national IS NOT NULL AND NationalId=@national)
                   OR (@passport IS NOT NULL AND PassportId=@passport))
            """, tx);
        AdmissionsRepository.Add(command, "@exclude", SqlDbType.Int, excludeId);
        AdmissionsRepository.Add(command, "@national", SqlDbType.VarChar, AdmissionsRepository.Clean(form.NationalId), 14);
        AdmissionsRepository.Add(command, "@passport", SqlDbType.VarChar, AdmissionsRepository.Clean(form.PassportId), 100);
        if (Convert.ToInt64(await command.ExecuteScalarAsync(ct)) > 0)
            throw new AdmissionsException(409, "duplicate_identity", "يوجد طالب مسجل بنفس الرقم القومي أو جواز السفر.");
    }

    public async Task<SaveResult> CreateAsync(StudentInput form, Guid requestKey, ClaimsPrincipal actorPrincipal, CancellationToken ct)
    {
        if (requestKey == Guid.Empty) throw new AdmissionsException(400, "idempotency_key_required", "أعد المحاولة بمفتاح طلب صحيح.");
        var actor = Actor(actorPrincipal);
        await using var connection = await repository.OpenAsync(ct);
        await using var transaction = (SqlTransaction)await connection.BeginTransactionAsync(IsolationLevel.Serializable, ct);
        try
        {
            await RequireWriteSchema(connection, ct, transaction);
            if (!await AdmissionsRepository.HasCodeUniqueIndexAsync(connection, ct, transaction))
                throw new AdmissionsException(503, "student_code_index_required", "فهرس تفرّد كود الطالب لم يُطبّق بعد؛ إضافة الطلاب غير متاحة.");
            var context = await ActiveContext(connection, transaction, ct);
            if (form.AdmissionYearId != context.yearId || form.AdmissionsSemesterId != context.semesterId)
                throw new AdmissionsException(409, "admission_context_changed", "تغيرت إعدادات سنة أو فصل القبول. أعد تحميل النموذج.");
            await ValidateForSave(connection, transaction, form, true, ct);
            var hash = SHA256.HashData(JsonSerializer.SerializeToUtf8Bytes(form));
            await using var prior = AdmissionsRepository.Command(connection, "SELECT RequestHash,StudentId FROM sis.AdmissionsCreateRequest WITH (UPDLOCK,HOLDLOCK) WHERE TenantId=@tid AND ActorObjectId=@oid AND RequestKey=@key", transaction);
            AdmissionsRepository.Add(prior, "@tid", SqlDbType.UniqueIdentifier, actor.tenant);
            AdmissionsRepository.Add(prior, "@oid", SqlDbType.UniqueIdentifier, actor.actor);
            AdmissionsRepository.Add(prior, "@key", SqlDbType.UniqueIdentifier, requestKey);
            await using (var reader = await prior.ExecuteReaderAsync(ct))
            {
                if (await reader.ReadAsync(ct))
                {
                    if (!hash.SequenceEqual((byte[])reader[0])) throw new AdmissionsException(409, "idempotency_mismatch", "مفتاح الطلب مستخدم لبيانات مختلفة.");
                    int? priorId = reader.IsDBNull(1) ? null : reader.GetInt32(1);
                    await reader.DisposeAsync();
                    if (priorId is not null)
                    {
                        var existing = await AdmissionsRepository.GetByIdAsync(connection, priorId.Value, ct, transaction);
                        await transaction.CommitAsync(ct);
                        return new(priorId.Value, existing?.StudentCode ?? "", existing?.Version ?? "");
                    }
                    throw new AdmissionsException(409, "create_in_progress", "هذا الطلب قيد التنفيذ.");
                }
            }
            await CheckDuplicates(connection, transaction, form, null, ct);
            await using (var reservation = AdmissionsRepository.Command(connection, "INSERT sis.AdmissionsCreateRequest(TenantId,ActorObjectId,RequestKey,RequestHash,CreatedAtUtc) VALUES(@tid,@oid,@key,@hash,SYSUTCDATETIME())", transaction))
            {
                AdmissionsRepository.Add(reservation, "@tid", SqlDbType.UniqueIdentifier, actor.tenant);
                AdmissionsRepository.Add(reservation, "@oid", SqlDbType.UniqueIdentifier, actor.actor);
                AdmissionsRepository.Add(reservation, "@key", SqlDbType.UniqueIdentifier, requestKey);
                AdmissionsRepository.Add(reservation, "@hash", SqlDbType.Binary, hash, 32);
                await reservation.ExecuteNonQueryAsync(ct);
            }
            await using var allocate = AdmissionsRepository.Command(connection, "UPDATE sis.StudentCodeCounter WITH (UPDLOCK,HOLDLOCK) SET LastAllocated=LastAllocated+1 OUTPUT inserted.LastAllocated WHERE YearPrefix=@prefix AND LastAllocated<9999", transaction);
            AdmissionsRepository.Add(allocate, "@prefix", SqlDbType.VarChar, context.prefix, 4);
            var sequence = await allocate.ExecuteScalarAsync(ct);
            if (sequence is null) throw new AdmissionsException(503, "counter_not_initialized", "عداد كود سنة القبول غير مهيأ أو وصل إلى الحد الأعلى.");
            var code = context.prefix + Convert.ToInt32(sequence).ToString("D4", CultureInfo.InvariantCulture);
            var studentValues = MainValues(form, context.yearId, context.semesterId, code);
            var id = await InsertAsync(connection, transaction, "dbo.Students", studentValues, ct, "StudentId");
            await SaveChildren(connection, transaction, id, form, code, true, ct);
            await Audit(connection, transaction, id, "Create", actor, null, ct);
            await using (var finish = AdmissionsRepository.Command(connection, "UPDATE sis.AdmissionsCreateRequest SET StudentId=@id,CompletedAtUtc=SYSUTCDATETIME() WHERE TenantId=@tid AND ActorObjectId=@oid AND RequestKey=@key", transaction))
            {
                AdmissionsRepository.Add(finish, "@id", SqlDbType.Int, id);
                AdmissionsRepository.Add(finish, "@tid", SqlDbType.UniqueIdentifier, actor.tenant);
                AdmissionsRepository.Add(finish, "@oid", SqlDbType.UniqueIdentifier, actor.actor);
                AdmissionsRepository.Add(finish, "@key", SqlDbType.UniqueIdentifier, requestKey);
                await finish.ExecuteNonQueryAsync(ct);
            }
            var saved = await AdmissionsRepository.GetByIdAsync(connection, id, ct, transaction);
            await transaction.CommitAsync(ct);
            return new(id, code, saved?.Version ?? "");
        }
        catch { await transaction.RollbackAsync(CancellationToken.None); throw; }
    }

    public async Task<SaveResult> UpdateAsync(int id, StudentInput form, string? version, ClaimsPrincipal actorPrincipal, CancellationToken ct)
    {
        var actor = Actor(actorPrincipal);
        await using var connection = await repository.OpenAsync(ct);
        await using var transaction = (SqlTransaction)await connection.BeginTransactionAsync(IsolationLevel.Serializable, ct);
        try
        {
            await RequireWriteSchema(connection, ct, transaction);
            var current = await AdmissionsRepository.GetByIdAsync(connection, id, ct, transaction)
                ?? throw new AdmissionsException(404, "student_missing", "الطالب غير موجود.");
            if (current.Archived) throw new AdmissionsException(409, "student_archived", "استعد الطالب من الأرشيف قبل التعديل.");
            if (current.Version != version) throw new AdmissionsException(412, "stale_student", "تغيرت بيانات الطالب منذ فتحها. أعد تحميلها.");
            if (current.Metadata.Keys.Any(k => k.EndsWith("HasMultipleRows", StringComparison.Ordinal)))
                throw new AdmissionsException(409, "multiple_child_rows", "توجد بيانات فرعية متعددة؛ يلزم مراجعتها قبل التعديل.");
            if (form.AdmissionYearId != current.Student.AdmissionYearId || form.AdmissionsSemesterId != current.Student.AdmissionsSemesterId)
                throw new AdmissionsException(400, "academic_context_readonly", "لا يمكن تغيير سنة أو فصل إدراج الطالب من شاشة القبول.");
            await ValidateForSave(connection, transaction, form, false, ct);
            await CheckDuplicates(connection, transaction, form, id, ct);
            var values = MainValues(form, current.Student.AdmissionYearId!.Value, current.Student.AdmissionsSemesterId!.Value, current.StudentCode);
            values["DepartmentId"] = (SqlDbType.Int, current.Student.DepartmentId);
            values.Remove("StudentCode"); values.Remove("YearId"); values.Remove("SemesterId"); values.Remove("StudentDateInserted"); values.Remove("IsTerms"); values.Remove("Image");
            values["StudentDateUpdated"] = (SqlDbType.Date, DateTime.UtcNow.Date);
            await UpdateAsync(connection, transaction, "dbo.Students", "StudentId", id, values, ct, version);
            await SaveChildren(connection, transaction, id, form, current.StudentCode, false, ct);
            await Audit(connection, transaction, id, "Update", actor, null, ct);
            var saved = await AdmissionsRepository.GetByIdAsync(connection, id, ct, transaction);
            await transaction.CommitAsync(ct);
            return new(id, current.StudentCode, saved?.Version ?? "");
        }
        catch { await transaction.RollbackAsync(CancellationToken.None); throw; }
    }

    public async Task ArchiveAsync(int id, ArchiveCommand request, bool restore, ClaimsPrincipal actorPrincipal, CancellationToken ct)
    {
        var actor = Actor(actorPrincipal);
        if (!restore && string.IsNullOrWhiteSpace(request.Reason))
            throw new AdmissionsException(400, "archive_reason_required", "سبب الأرشفة مطلوب.");
        if ((request.Reason?.Length ?? 0) > 1000)
            throw new AdmissionsException(400, "archive_reason_too_long", "سبب الأرشفة طويل جداً.");
        await using var connection = await repository.OpenAsync(ct);
        await using var transaction = (SqlTransaction)await connection.BeginTransactionAsync(IsolationLevel.Serializable, ct);
        try
        {
            await RequireWriteSchema(connection, ct, transaction);
            await using (var lockStudent = AdmissionsRepository.Command(connection, "SELECT 1 FROM dbo.Students WITH (UPDLOCK,HOLDLOCK) WHERE StudentId=@id", transaction))
            {
                AdmissionsRepository.Add(lockStudent, "@id", SqlDbType.Int, id);
                if (await lockStudent.ExecuteScalarAsync(ct) is null) throw new AdmissionsException(404, "student_missing", "الطالب غير موجود.");
            }
            var current = await AdmissionsRepository.GetByIdAsync(connection, id, ct, transaction)
                ?? throw new AdmissionsException(404, "student_missing", "الطالب غير موجود.");
            if (current.Version != request.Version) throw new AdmissionsException(412, "stale_student", "تغير سجل الطالب. أعد تحميله.");
            if (current.Archived != restore) throw new AdmissionsException(409, "archive_state_changed", "حالة الأرشفة تغيرت. أعد تحميل السجل.");
            var reason = restore ? "استعادة الطالب من الأرشيف" : request.Reason!.Trim();
            await using var save = AdmissionsRepository.Command(connection, """
                UPDATE sis.StudentLifecycle WITH (UPDLOCK,HOLDLOCK)
                SET IsArchived=@archived,ChangedAtUtc=SYSUTCDATETIME(),ChangedByTenantId=@tid,ChangedByObjectId=@oid,Reason=@reason
                WHERE StudentId=@id;
                IF @@ROWCOUNT=0
                    INSERT sis.StudentLifecycle(StudentId,IsArchived,ChangedAtUtc,ChangedByTenantId,ChangedByObjectId,Reason)
                    VALUES(@id,@archived,SYSUTCDATETIME(),@tid,@oid,@reason);
                """, transaction);
            AdmissionsRepository.Add(save, "@id", SqlDbType.Int, id);
            AdmissionsRepository.Add(save, "@archived", SqlDbType.Bit, !restore);
            AdmissionsRepository.Add(save, "@tid", SqlDbType.UniqueIdentifier, actor.tenant);
            AdmissionsRepository.Add(save, "@oid", SqlDbType.UniqueIdentifier, actor.actor);
            AdmissionsRepository.Add(save, "@reason", SqlDbType.NVarChar, reason, 1000);
            await save.ExecuteNonQueryAsync(ct);
            await Audit(connection, transaction, id, restore ? "Restore" : "Archive", actor, reason, ct);
            await transaction.CommitAsync(ct);
        }
        catch { await transaction.RollbackAsync(CancellationToken.None); throw; }
    }

    private static Dictionary<string, (SqlDbType type, object? value)> MainValues(StudentInput form, int yearId, int semesterId, string code) => new()
    {
        ["StudentCode"] = (SqlDbType.NVarChar, code),
        ["FirstName"] = (SqlDbType.VarChar, form.EnglishName.First.Trim()), ["MiddleName"] = (SqlDbType.VarChar, form.EnglishName.Middle.Trim()), ["LastName"] = (SqlDbType.VarChar, form.EnglishName.Last.Trim()),
        ["ArFirstName"] = (SqlDbType.NVarChar, form.ArabicName.First.Trim()), ["ArMiddleName"] = (SqlDbType.NVarChar, form.ArabicName.Middle.Trim()), ["ArLastName"] = (SqlDbType.NVarChar, form.ArabicName.Last.Trim()),
        // FullName is computed by dbo.Students from the Arabic name columns.
        ["Gender"] = (SqlDbType.Bit, form.Gender), ["Religion"] = (SqlDbType.TinyInt, form.Religion),
        ["DateOfBirth"] = (SqlDbType.DateTime, form.DateOfBirth), ["PlaceOfBirth"] = (SqlDbType.Int, form.PlaceOfBirth),
        ["Nationality"] = (SqlDbType.Int, form.Nationality), ["NationalId"] = (SqlDbType.VarChar, AdmissionsRepository.Clean(form.NationalId)),
        ["NationalIdReleaseDate"] = (SqlDbType.DateTime, form.NationalIdReleaseDate), ["NationalIdReleaseZone"] = (SqlDbType.Int, form.NationalIdReleaseZone),
        ["PassportId"] = (SqlDbType.VarChar, AdmissionsRepository.Clean(form.PassportId)), ["PassportReleaseDate"] = (SqlDbType.DateTime, form.PassportReleaseDate),
        ["PassportExpirationDate"] = (SqlDbType.DateTime, form.PassportExpirationDate),
        ["FatherName"] = (SqlDbType.VarChar, form.FatherName.Trim()), ["ArFatherName"] = (SqlDbType.NVarChar, form.ArFatherName.Trim()),
        ["FatherJob"] = (SqlDbType.VarChar, form.FatherJob.Trim()), ["ArFatherJob"] = (SqlDbType.NVarChar, AdmissionsRepository.Clean(form.ArFatherJob)),
        ["MotherName"] = (SqlDbType.VarChar, AdmissionsRepository.Clean(form.MotherName)), ["ArMotherName"] = (SqlDbType.NVarChar, AdmissionsRepository.Clean(form.ArMotherName)),
        ["MotherJob"] = (SqlDbType.VarChar, AdmissionsRepository.Clean(form.MotherJob)), ["ArMotherJob"] = (SqlDbType.NVarChar, AdmissionsRepository.Clean(form.ArMotherJob)),
        ["FirstForeignLanguage"] = (SqlDbType.Int, form.FirstForeignLanguage), ["SecondForeignLanguage"] = (SqlDbType.Int, form.SecondForeignLanguage),
        ["DepartmentId"] = (SqlDbType.Int, 1), ["YearId"] = (SqlDbType.Int, yearId), ["SemesterId"] = (SqlDbType.Int, semesterId),
        ["Image"] = (SqlDbType.VarChar, null), ["StudentDateInserted"] = (SqlDbType.Date, DateTime.UtcNow.Date)
    };

    private static async Task<int> InsertAsync(SqlConnection connection, SqlTransaction tx, string table,
        Dictionary<string, (SqlDbType type, object? value)> values, CancellationToken ct, string? identity = null)
    {
        var columns = values.Keys.ToArray();
        var sql = $"INSERT {table} ({string.Join(',', columns.Select(c => $"[{c}]"))}) VALUES ({string.Join(',', columns.Select((_, i) => $"@p{i}"))});";
        sql += identity is null ? "" : "SELECT CONVERT(int,SCOPE_IDENTITY());";
        await using var command = AdmissionsRepository.Command(connection, sql, tx);
        for (var i = 0; i < columns.Length; i++) AdmissionsRepository.Add(command, $"@p{i}", values[columns[i]].type, values[columns[i]].value);
        return identity is null ? await command.ExecuteNonQueryAsync(ct) : Convert.ToInt32(await command.ExecuteScalarAsync(ct));
    }
    private static async Task UpdateAsync(SqlConnection connection, SqlTransaction tx, string table, string key, int id,
        Dictionary<string, (SqlDbType type, object? value)> values, CancellationToken ct, string? version = null)
    {
        var columns = values.Keys.ToArray();
        var sql = $"UPDATE {table} SET {string.Join(',', columns.Select((c, i) => $"[{c}]=@p{i}"))} WHERE [{key}]=@id";
        if (version is not null) sql += " AND SisVersion=@version";
        await using var command = AdmissionsRepository.Command(connection, sql, tx);
        AdmissionsRepository.Add(command, "@id", SqlDbType.Int, id);
        if (version is not null) AdmissionsRepository.Add(command, "@version", SqlDbType.Timestamp, ParseVersion(version), 8);
        for (var i = 0; i < columns.Length; i++) AdmissionsRepository.Add(command, $"@p{i}", values[columns[i]].type, values[columns[i]].value);
        if (await command.ExecuteNonQueryAsync(ct) != 1)
            throw new AdmissionsException(412, "stale_or_ambiguous_record", "تغير السجل أو توجد بيانات مكررة؛ أعد تحميله.");
    }
    private static byte[] ParseVersion(string text)
    {
        try { var bytes = Convert.FromBase64String(text); if (bytes.Length == 8) return bytes; }
        catch (FormatException) { }
        throw new AdmissionsException(400, "invalid_version", "إصدار السجل غير صحيح.");
    }

    private static async Task SaveChildren(SqlConnection connection, SqlTransaction tx, int id, StudentInput form, string code, bool create, CancellationToken ct)
    {
        var childRows = new (string table, Dictionary<string, (SqlDbType type, object? value)> values)[]
        {
            ("dbo.StudentsActivity", new() { ["ActivityId"]=(SqlDbType.Int,form.Activity.ActivityId), ["ActivityPlace"]=(SqlDbType.NVarChar,form.Activity.Place), ["ActivityChampionship"]=(SqlDbType.NVarChar,form.Activity.Championship), ["ActivityChampionshipDate"]=(SqlDbType.DateTime,form.Activity.ChampionshipDate) }),
            ("dbo.StudentsArmyStatus", new() { ["ArmyId"]=(SqlDbType.Int,create ? 1 : form.ArmyStatusId ?? 1), ["ExemptedNumber"]=(SqlDbType.NVarChar,form.ArmyExemptedNumber), ["ThirdNumber"]=(SqlDbType.NVarChar,form.ArmyThirdNumber), ["ExemptedDate"]=(SqlDbType.DateTime,form.ArmyExemptedDate), ["OperativeDecision"]=(SqlDbType.NVarChar,form.ArmyOperativeDecision) }),
            ("dbo.StudentsCertificate", new() { ["CertificateId"]=(SqlDbType.Int,form.Certificate.CertificateId), ["CertificateCountry"]=(SqlDbType.Int,form.Certificate.CountryLocationId), ["CertificateYear"]=(SqlDbType.VarChar,form.Certificate.YearId?.ToString(CultureInfo.InvariantCulture)), ["CertificateSeatNo"]=(SqlDbType.NVarChar,form.Certificate.SeatNumber), ["CertificateTotalResult"]=(SqlDbType.Decimal,form.Certificate.TotalResult), ["CertificateResultPercentage"]=(SqlDbType.Decimal,form.Certificate.ResultPercentage), ["SchoolId"]=(SqlDbType.NVarChar,form.Certificate.SchoolName), ["educationalPlace"]=(SqlDbType.NVarChar,form.Certificate.EducationalPlace) }),
            ("dbo.StudentsContacts", new() { ["StudentPhone"]=(SqlDbType.NVarChar,form.Contact.Phone), ["StudentMobile"]=(SqlDbType.NVarChar,form.Contact.Mobile), ["StudentMobile2"]=(SqlDbType.NVarChar,form.Contact.Mobile2), ["StudentEmail"]=(SqlDbType.VarChar,form.Contact.Email), ["StudentFacebook"]=(SqlDbType.VarChar,form.Contact.Facebook), ["StudentTwitter"]=(SqlDbType.VarChar,form.Contact.Twitter), ["FatherMobile"]=(SqlDbType.NVarChar,form.Contact.FatherMobile), ["FatherEmail"]=(SqlDbType.NVarChar,form.Contact.FatherEmail), ["MotherMobile"]=(SqlDbType.NVarChar,form.Contact.MotherMobile), ["StudentAddress"]=(SqlDbType.VarChar,form.Contact.Address), ["ArStudentAddress"]=(SqlDbType.NVarChar,form.Contact.ArabicAddress), ["StudentAddressLocation"]=(SqlDbType.Int,form.Contact.AddressLocationId) }),
            ("dbo.StudentsHoppy", new() { ["HoppyId"]=(SqlDbType.Int,form.HobbyId), ["HoppyPlace"]=(SqlDbType.NVarChar,form.HobbyPlace) }),
            ("dbo.StudentsAcceptance", new() { ["AcceptanceId"]=(SqlDbType.Int,create ? 1 : form.AcceptanceTypeId ?? 1), ["EnrollmentId"]=(SqlDbType.Int,create ? 1 : form.EnrollmentStatusId ?? 1), ["AcceptanceDate"]=(SqlDbType.DateTime,form.AcceptanceDate), ["AcceptanceNumber"]=(SqlDbType.Int,form.AcceptanceNumber), ["TransferDate"]=(SqlDbType.DateTime,form.TransferDate), ["TransferFrom"]=(SqlDbType.NVarChar,form.TransferFrom) }),
            ("dbo.Studentsknowledge", new() { ["InstituteStatmentId"]=(SqlDbType.Int,form.InstituteStatementId) })
        };
        foreach (var row in childRows)
        {
            var values = row.values;
            if (create)
            {
                values["StudentId"] = (SqlDbType.Int, id);
                await InsertAsync(connection, tx, row.table, values, ct);
            }
            else
            {
                await using var count = AdmissionsRepository.Command(connection, $"SELECT COUNT_BIG(1) FROM {row.table} WITH (UPDLOCK,HOLDLOCK) WHERE StudentId=@id", tx);
                AdmissionsRepository.Add(count, "@id", SqlDbType.Int, id);
                var existingRows = Convert.ToInt64(await count.ExecuteScalarAsync(ct));
                if (existingRows > 1) throw new AdmissionsException(409, "multiple_child_rows", "توجد بيانات فرعية متعددة؛ يلزم مراجعتها قبل التعديل.");
                if (existingRows == 0) { values["StudentId"] = (SqlDbType.Int, id); await InsertAsync(connection, tx, row.table, values, ct); }
                else await UpdateAsync(connection, tx, row.table, "StudentId", id, values, ct);
            }
        }
    }
    private static async Task Audit(SqlConnection connection, SqlTransaction tx, int id, string action,
        (Guid tenant, Guid actor) actor, string? reason, CancellationToken ct)
    {
        await using var command = AdmissionsRepository.Command(connection, """
            INSERT sis.AdmissionsAudit(StudentId,ActionName,OccurredAtUtc,ActorTenantId,ActorObjectId,CorrelationId,Reason)
            VALUES(@id,@action,SYSUTCDATETIME(),@tid,@oid,@correlation,@reason)
            """, tx);
        AdmissionsRepository.Add(command, "@id", SqlDbType.Int, id);
        AdmissionsRepository.Add(command, "@action", SqlDbType.VarChar, action, 20);
        AdmissionsRepository.Add(command, "@tid", SqlDbType.UniqueIdentifier, actor.tenant);
        AdmissionsRepository.Add(command, "@oid", SqlDbType.UniqueIdentifier, actor.actor);
        AdmissionsRepository.Add(command, "@correlation", SqlDbType.UniqueIdentifier, Guid.NewGuid());
        AdmissionsRepository.Add(command, "@reason", SqlDbType.NVarChar, reason, 1000);
        await command.ExecuteNonQueryAsync(ct);
    }
}
