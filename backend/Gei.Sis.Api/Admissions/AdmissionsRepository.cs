using System.Data;
using Microsoft.Data.SqlClient;

namespace Gei.Sis.Api.Admissions;

public sealed class AdmissionsRepository(IConfiguration configuration)
{
    internal bool WritesEnabled => configuration.GetValue<bool>("Admissions:WritesEnabled");
    private readonly string connectionString = configuration.GetConnectionString("TeiDB")
        ?? throw new InvalidOperationException("ConnectionStrings:TeiDB is required for admissions.");

    internal async Task<SqlConnection> OpenAsync(CancellationToken cancellationToken)
    {
        var connection = new SqlConnection(connectionString);
        try { await connection.OpenAsync(cancellationToken); return connection; }
        catch { await connection.DisposeAsync(); throw; }
    }

    internal static SqlCommand Command(SqlConnection connection, string sql, SqlTransaction? transaction = null)
    {
        var command = connection.CreateCommand();
        command.CommandText = sql;
        command.CommandTimeout = 30;
        command.Transaction = transaction;
        return command;
    }
    internal static void Add(SqlCommand command, string name, SqlDbType type, object? value, int size = 0)
    {
        var parameter = size == 0 ? command.Parameters.Add(name, type) : command.Parameters.Add(name, type, size);
        parameter.Value = value ?? DBNull.Value;
    }
    internal static async Task<bool> HasSupportSchemaAsync(SqlConnection connection, CancellationToken ct, SqlTransaction? tx = null)
    {
        await using var command = Command(connection, "SELECT CASE WHEN OBJECT_ID(N'sis.StudentLifecycle',N'U') IS NOT NULL AND OBJECT_ID(N'sis.AdmissionsAudit',N'U') IS NOT NULL AND OBJECT_ID(N'sis.StudentCodeCounter',N'U') IS NOT NULL AND OBJECT_ID(N'sis.AdmissionsCreateRequest',N'U') IS NOT NULL THEN 1 ELSE 0 END", tx);
        return Convert.ToInt32(await command.ExecuteScalarAsync(ct)) == 1;
    }
    internal static async Task<bool> HasCodeUniqueIndexAsync(SqlConnection connection, CancellationToken ct, SqlTransaction? tx = null)
    {
        await using var command = Command(connection, "SELECT CASE WHEN EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID(N'dbo.Students') AND name=N'UX_SisStudents_StudentCode' AND is_unique=1) THEN 1 ELSE 0 END", tx);
        return Convert.ToInt32(await command.ExecuteScalarAsync(ct)) == 1;
    }

    public async Task<AdmissionsContext> GetContextAsync(CancellationToken ct)
    {
        await using var connection = await OpenAsync(ct);
        await using var command = Command(connection, """
            SELECT TOP (2) a.Id, a.AdmissionYear, y.YearName, y.ActualYear,
                a.AdmissionsSemester, s.ArSemesterName, s.YearId AS SemesterYearId, s.Hide AS SemesterHidden
            FROM dbo.ActiveSemesters a
            LEFT JOIN dbo.Years y ON y.YearId = a.AdmissionYear
            LEFT JOIN dbo.Semesters s ON s.SemesterId = a.AdmissionsSemester
            ORDER BY a.Id
            """);
        await using var reader = await command.ExecuteReaderAsync(ct);
        var rows = new List<(int? yearId, string? year, string? actual, int? semesterId, string? semester, int? semesterYear, bool hidden)>();
        while (await reader.ReadAsync(ct))
            rows.Add((NullableInt(reader, "AdmissionYear"), NullableString(reader, "YearName"), NullableString(reader, "ActualYear"),
                NullableInt(reader, "AdmissionsSemester"), NullableString(reader, "ArSemesterName"), NullableInt(reader, "SemesterYearId"),
                !reader.IsDBNull(reader.GetOrdinal("SemesterHidden")) && reader.GetBoolean(reader.GetOrdinal("SemesterHidden"))));
        await reader.DisposeAsync();
        var support = await HasSupportSchemaAsync(connection, ct) && await HasStudentVersionAsync(connection, ct);
        var cutover = support && await HasCodeUniqueIndexAsync(connection, ct);
        string? writeMessage = !support ? "ترحيل جداول القبول وحقل حماية التعديل لم يُطبّق بعد." :
            !WritesEnabled ? "الكتابة متوقفة حتى إتمام نقل العمل من النظام القديم." : null;
        if (rows.Count != 1) return new(null, null, null, null, null, 1, false, "يجب أن يوجد إعداد قبول نشط واحد فقط.", support, support && WritesEnabled, writeMessage);
        var row = rows[0];
        string? message = row.yearId is null || row.year is null || row.actual is null ? "لم يتم ضبط سنة القبول." :
            row.semesterId is null ? "لم يتم ضبط فصل القبول في إعدادات ActiveSemesters." :
            row.semester is null ? "فصل القبول المحدد غير موجود." :
            row.semesterYear != row.yearId ? "فصل القبول لا يتبع سنة القبول الحالية." :
            row.hidden ? "فصل القبول المحدد مخفي." :
            row.actual.Length != 4 || !row.actual.All(char.IsAsciiDigit) ? "قيمة ActualYear غير صالحة لتوليد كود الطالب." : null;
        if (message is null && !support) message = "جداول دعم القبول لم تُعتمد أو تُطبَّق بعد.";
        if (message is null && !cutover) message = "فهرس تفرّد كود الطالب لم يُطبّق بعد.";
        if (message is null && !WritesEnabled) message = "الكتابة متوقفة حتى اكتمال ترحيل قاعدة البيانات وإيقاف النظام القديم.";
        if (message is null && support && WritesEnabled)
        {
            await using var ready = Command(connection, """
                SELECT CASE WHEN EXISTS (SELECT 1 FROM sis.StudentCodeCounter WHERE YearPrefix=@prefix AND LastAllocated<9999)
                    AND EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID(N'dbo.Students') AND name=N'UX_SisStudents_StudentCode' AND is_unique=1)
                    THEN 1 ELSE 0 END
                """);
            Add(ready, "@prefix", SqlDbType.VarChar, row.actual, 4);
            if (Convert.ToInt32(await ready.ExecuteScalarAsync(ct)) != 1)
                message = "عداد كود سنة القبول أو فهرس تفرّد الكود غير جاهز؛ راجع خطوات بدء التشغيل.";
        }
        return new(row.yearId, row.year, row.actual, row.semesterId, row.semester, 1, message is null, message, support, support && WritesEnabled, writeMessage);
    }

    public async Task<IReadOnlyDictionary<string, IReadOnlyList<LookupItem>>> GetLookupsAsync(CancellationToken ct)
    {
        var sources = new (string key, string sql)[]
        {
            ("nationalities", "SELECT NationalityId AS Id, ArNationalityName AS Label, Hide AS Hidden FROM dbo.Nationalities ORDER BY ArNationalityName"),
            ("departments", "SELECT DepartmentId AS Id, ArDepartmentName AS Label, Hide AS Hidden FROM dbo.Departments ORDER BY ArDepartmentName"),
            ("years", "SELECT YearId AS Id, YearName AS Label, Hide AS Hidden FROM dbo.Years ORDER BY YearId DESC"),
            ("semesters", "SELECT SemesterId AS Id, ArSemesterName AS Label, Hide AS Hidden FROM dbo.Semesters ORDER BY YearId DESC, SemesterId DESC"),
            ("birthPlaces", "SELECT LocationId AS Id, dbo.GetArLocationName(LocationId) AS Label, Hide AS Hidden FROM dbo.Locations WHERE Type IN (1,2) ORDER BY Type, ParentId, LocationId"),
            ("locations", "SELECT LocationId AS Id, dbo.GetArLocationName(LocationId) AS Label, Hide AS Hidden FROM dbo.Locations ORDER BY Type, ParentId, LocationId"),
            ("countries", "SELECT LocationId AS Id, dbo.GetArLocationName(LocationId) AS Label, Hide AS Hidden FROM dbo.Locations WHERE Type = 1 ORDER BY LocationId"),
            ("languages", "SELECT LanguageId AS Id, ArLanguageName AS Label, Hide AS Hidden FROM dbo.Languages ORDER BY ArLanguageName"),
            ("certificates", "SELECT CertificateId AS Id, ArCertificateName AS Label, Hide AS Hidden FROM dbo.Certificates ORDER BY ArCertificateName"),
            ("activities", "SELECT ActivityId AS Id, ArActivityName AS Label, Hide AS Hidden FROM dbo.Activities ORDER BY ArActivityName"),
            ("hobbies", "SELECT HoppyId AS Id, ArHoppyName AS Label, Hide AS Hidden FROM dbo.Hoppies ORDER BY ArHoppyName"),
            ("instituteStatements", "SELECT InstituteStatmentId AS Id, InstituteStatment AS Label, CONVERT(bit,0) AS Hidden FROM dbo.InstituteStatments ORDER BY InstituteStatmentId"),
            ("armyStatuses", "SELECT ArmyId AS Id, ArArmyStatusName AS Label, Hide AS Hidden FROM dbo.ArmyStatus ORDER BY ArmyId"),
            ("acceptanceTypes", "SELECT AcceptanceId AS Id, ArAcceptanceName AS Label, Hide AS Hidden FROM dbo.AcceptanceTypes ORDER BY AcceptanceId"),
            ("enrollmentStatuses", "SELECT Id, Student_Enrollment_Status_Name AS Label, CONVERT(bit,0) AS Hidden FROM dbo.Students_Enrollment_Status ORDER BY Id")
        };
        var result = new Dictionary<string, IReadOnlyList<LookupItem>>();
        await using var connection = await OpenAsync(ct);
        foreach (var source in sources)
        {
            await using var command = Command(connection, source.sql);
            await using var reader = await command.ExecuteReaderAsync(ct);
            var values = new List<LookupItem>();
            while (await reader.ReadAsync(ct))
                values.Add(new(reader.GetInt32(0), reader.IsDBNull(1) ? $"#{reader.GetInt32(0)}" : reader.GetString(1), reader.GetBoolean(2)));
            result[source.key] = values;
        }
        return result;
    }

    public async Task<StudentSearchResult> SearchAsync(SearchStudentsRequest request, CancellationToken ct)
    {
        if (request.Page < 1 || request.PageSize is < 1 or > 100 ||
            new[] { request.Query, request.ArabicFirstName, request.ArabicMiddleName, request.ArabicLastName }.Any(v => (v?.Length ?? 0) > 100))
            throw new AdmissionsException(400, "invalid_search", "تحقق من معايير البحث ورقم الصفحة.");
        var sort = request.Sort switch
        {
            "oldest" => "s.StudentId ASC",
            "name" => "s.ArFirstName ASC, s.ArMiddleName ASC, s.ArLastName ASC, s.StudentId ASC",
            "code" => "s.StudentCode ASC, s.StudentId ASC",
            _ => "s.StudentId DESC"
        };
        await using var connection = await OpenAsync(ct);
        var support = await HasSupportSchemaAsync(connection, ct);
        if (request.Archived && !support) throw new AdmissionsException(503, "archive_unavailable", "عرض الأرشيف غير متاح حتى اعتماد جداول الدعم.");
        var lifecycle = support ? "LEFT JOIN sis.StudentLifecycle life ON life.StudentId=s.StudentId" : "";
        var archived = support ? "ISNULL(life.IsArchived,0)" : "CONVERT(bit,0)";
        var from = $"""
            FROM dbo.Students s
            LEFT JOIN dbo.Departments d ON d.DepartmentId=s.DepartmentId
            LEFT JOIN dbo.Years y ON y.YearId=s.YearId
            LEFT JOIN dbo.Semesters sem ON sem.SemesterId=s.SemesterId
            LEFT JOIN dbo.Nationalities nat ON nat.NationalityId=s.Nationality
            OUTER APPLY (SELECT TOP (1) a.AcceptanceId, a.EnrollmentId FROM dbo.StudentsAcceptance a WHERE a.StudentId=s.StudentId ORDER BY a.Id DESC) acc
            LEFT JOIN dbo.AcceptanceTypes at ON at.AcceptanceId=acc.AcceptanceId
            LEFT JOIN dbo.Students_Enrollment_Status es ON es.Id=acc.EnrollmentId
            {lifecycle}
            WHERE {archived}=@archived
              AND (@year IS NULL OR s.YearId=@year)
              AND (@semester IS NULL OR s.SemesterId=@semester)
              AND (@department IS NULL OR s.DepartmentId=@department)
              AND (@nationality IS NULL OR s.Nationality=@nationality)
              AND (@acceptance IS NULL OR acc.AcceptanceId=@acceptance)
              AND (@enrollment IS NULL OR acc.EnrollmentId=@enrollment)
              AND (@firstName IS NULL OR s.ArFirstName LIKE @firstName + N'%')
              AND (@middleName IS NULL OR s.ArMiddleName LIKE @middleName + N'%')
              AND (@lastName IS NULL OR s.ArLastName LIKE @lastName + N'%')
              AND (@national IS NULL OR s.NationalId=@national)
              AND (@passport IS NULL OR s.PassportId=@passport)
              AND (@query IS NULL OR s.StudentCode LIKE N'%' + @query + N'%'
                OR s.ArFirstName LIKE N'%' + @query + N'%'
                OR s.ArMiddleName LIKE N'%' + @query + N'%'
                OR s.ArLastName LIKE N'%' + @query + N'%'
                OR s.FullName LIKE N'%' + @query + N'%'
                OR s.FirstName LIKE '%' + @query + '%'
                OR s.MiddleName LIKE '%' + @query + '%'
                OR s.LastName LIKE '%' + @query + '%'
                OR (s.FirstName+' '+s.MiddleName+' '+s.LastName) LIKE '%' + @query + '%')
            """;
        await using var command = Command(connection, $"""
            SELECT COUNT_BIG(1) {from};
            WITH Results AS (
                SELECT s.StudentId,s.StudentCode,s.FullName AS ArabicName,
                    s.FirstName+' '+s.MiddleName+' '+s.LastName AS EnglishName,
                    d.ArDepartmentName AS Department,y.YearName AS [Year],sem.ArSemesterName AS Semester,nat.ArNationalityName AS Nationality,
                    at.ArAcceptanceName AS Acceptance,es.Student_Enrollment_Status_Name AS Enrollment,
                    {archived} AS Archived,ROW_NUMBER() OVER (ORDER BY {sort}) AS RowNumber
                {from}
            )
            SELECT StudentId,StudentCode,ArabicName,EnglishName,Department,[Year],Semester,Nationality,Acceptance,Enrollment,Archived
            FROM Results WHERE RowNumber BETWEEN @start AND @end ORDER BY RowNumber;
            """);
        AddSearchParameters(command, request);
        Add(command, "@start", SqlDbType.BigInt, ((long)request.Page - 1) * request.PageSize + 1);
        Add(command, "@end", SqlDbType.BigInt, (long)request.Page * request.PageSize);
        await using var reader = await command.ExecuteReaderAsync(ct);
        await reader.ReadAsync(ct);
        var count = checked((int)reader.GetInt64(0));
        await reader.NextResultAsync(ct);
        var items = new List<StudentListItem>();
        while (await reader.ReadAsync(ct))
            items.Add(new(reader.GetInt32(0), reader.GetString(1), reader.GetString(2), NullableString(reader, "EnglishName"),
                NullableString(reader, "Department"), NullableString(reader, "Year"), NullableString(reader, "Semester"), NullableString(reader, "Nationality"),
                NullableString(reader, "Acceptance"), NullableString(reader, "Enrollment"), reader.GetBoolean(10)));
        return new(items, count, request.Page, request.PageSize);
    }

    private static void AddSearchParameters(SqlCommand command, SearchStudentsRequest request)
    {
        Add(command, "@archived", SqlDbType.Bit, request.Archived);
        Add(command, "@year", SqlDbType.Int, request.YearId);
        Add(command, "@semester", SqlDbType.Int, request.SemesterId);
        Add(command, "@department", SqlDbType.Int, request.DepartmentId);
        Add(command, "@nationality", SqlDbType.Int, request.NationalityId);
        Add(command, "@acceptance", SqlDbType.Int, request.AcceptanceId);
        Add(command, "@enrollment", SqlDbType.Int, request.EnrollmentId);
        Add(command, "@firstName", SqlDbType.NVarChar, Clean(request.ArabicFirstName), 100);
        Add(command, "@middleName", SqlDbType.NVarChar, Clean(request.ArabicMiddleName), 100);
        Add(command, "@lastName", SqlDbType.NVarChar, Clean(request.ArabicLastName), 100);
        Add(command, "@national", SqlDbType.VarChar, Clean(request.NationalId), 14);
        Add(command, "@passport", SqlDbType.VarChar, Clean(request.PassportId), 100);
        Add(command, "@query", SqlDbType.NVarChar, Clean(request.Query), 100);
    }
    internal static string? Clean(string? value) => string.IsNullOrWhiteSpace(value) ? null : value.Trim();
    internal static int? NullableInt(SqlDataReader reader, string column) => reader.IsDBNull(reader.GetOrdinal(column)) ? null : reader.GetInt32(reader.GetOrdinal(column));
    internal static string? NullableString(SqlDataReader reader, string column) => reader.IsDBNull(reader.GetOrdinal(column)) ? null : reader.GetString(reader.GetOrdinal(column));

    public async Task<StudentDetail?> GetByIdAsync(int studentId, CancellationToken ct)
    {
        await using var connection = await OpenAsync(ct);
        return await GetByIdAsync(connection, studentId, ct);
    }

    internal static async Task<StudentDetail?> GetByIdAsync(SqlConnection connection, int studentId, CancellationToken ct, SqlTransaction? tx = null)
    {
        var support = await HasSupportSchemaAsync(connection, ct, tx);
        var archiveSelect = support ? "ISNULL(life.IsArchived,0) AS Archived," : "CONVERT(bit,0) AS Archived,";
        var archiveJoin = support ? "LEFT JOIN sis.StudentLifecycle life ON life.StudentId=s.StudentId" : "";
        var versionSelect = await HasStudentVersionAsync(connection, ct, tx) ? "s.SisVersion AS Version" : "CONVERT(varbinary(8),0) AS Version";
        await using var command = Command(connection, $"SELECT s.*, {archiveSelect} {versionSelect} FROM dbo.Students s {archiveJoin} WHERE s.StudentId=@id", tx);
        Add(command, "@id", SqlDbType.Int, studentId);
        await using var reader = await command.ExecuteReaderAsync(ct);
        if (!await reader.ReadAsync(ct)) return null;
        var form = new StudentInput
        {
            ArabicName = new(reader.GetString(reader.GetOrdinal("ArFirstName")), reader.GetString(reader.GetOrdinal("ArMiddleName")), reader.GetString(reader.GetOrdinal("ArLastName"))),
            EnglishName = new(reader.GetString(reader.GetOrdinal("FirstName")), reader.GetString(reader.GetOrdinal("MiddleName")), reader.GetString(reader.GetOrdinal("LastName"))),
            Gender = reader.GetBoolean(reader.GetOrdinal("Gender")), Religion = reader.GetByte(reader.GetOrdinal("Religion")),
            DateOfBirth = reader.GetDateTime(reader.GetOrdinal("DateOfBirth")), PlaceOfBirth = NullableInt(reader, "PlaceOfBirth"),
            Nationality = NullableInt(reader, "Nationality"), NationalId = NullableString(reader, "NationalId"),
            NationalIdReleaseDate = NullableDate(reader, "NationalIdReleaseDate"), NationalIdReleaseZone = NullableInt(reader, "NationalIdReleaseZone"),
            PassportId = NullableString(reader, "PassportId"), PassportReleaseDate = NullableDate(reader, "PassportReleaseDate"),
            PassportExpirationDate = NullableDate(reader, "PassportExpirationDate"), FatherName = reader.GetString(reader.GetOrdinal("FatherName")),
            ArFatherName = reader.GetString(reader.GetOrdinal("ArFatherName")), FatherJob = reader.GetString(reader.GetOrdinal("FatherJob")),
            ArFatherJob = NullableString(reader, "ArFatherJob"), MotherName = NullableString(reader, "MotherName"),
            ArMotherName = NullableString(reader, "ArMotherName"), MotherJob = NullableString(reader, "MotherJob"),
            ArMotherJob = NullableString(reader, "ArMotherJob"), FirstForeignLanguage = NullableInt(reader, "FirstForeignLanguage"),
            SecondForeignLanguage = NullableInt(reader, "SecondForeignLanguage"), DepartmentId = NullableInt(reader, "DepartmentId"),
            AdmissionYearId = NullableInt(reader, "YearId"), AdmissionsSemesterId = NullableInt(reader, "SemesterId"),
            Image = NullableString(reader, "Image")
        };
        var code = reader.GetString(reader.GetOrdinal("StudentCode"));
        var archived = reader.GetBoolean(reader.GetOrdinal("Archived"));
        var version = Convert.ToBase64String((byte[])reader["Version"]);
        await reader.DisposeAsync();
        var metadata = new Dictionary<string, object?>();
        foreach (var child in new[]
        {
            ("certificate", "dbo.StudentsCertificate"), ("contact", "dbo.StudentsContacts"),
            ("activity", "dbo.StudentsActivity"), ("hobby", "dbo.StudentsHoppy"),
            ("military", "dbo.StudentsArmyStatus"), ("acceptance", "dbo.StudentsAcceptance"),
            ("discovery", "dbo.Studentsknowledge")
        })
        {
            await using var childCommand = Command(connection, $"SELECT TOP (2) * FROM {child.Item2} WHERE StudentId=@id ORDER BY Id DESC", tx);
            // Contacts uses ContactId rather than Id.
            if (child.Item1 == "contact") childCommand.CommandText = "SELECT TOP (2) * FROM dbo.StudentsContacts WHERE StudentId=@id ORDER BY ContactId DESC";
            Add(childCommand, "@id", SqlDbType.Int, studentId);
            await using var childReader = await childCommand.ExecuteReaderAsync(ct);
            var rows = new List<Dictionary<string, object?>>();
            while (await childReader.ReadAsync(ct))
            {
                var row = new Dictionary<string, object?>();
                for (var i = 0; i < childReader.FieldCount; i++) row[childReader.GetName(i)] = childReader.IsDBNull(i) ? null : childReader.GetValue(i);
                rows.Add(row);
            }
            metadata[child.Item1] = rows.Count == 1 ? rows[0] : null;
            if (rows.Count > 1) metadata[$"{child.Item1}HasMultipleRows"] = true;
        }
        static Dictionary<string, object?>? Row(IReadOnlyDictionary<string, object?> data, string key) =>
            data.TryGetValue(key, out var value) ? value as Dictionary<string, object?> : null;
        static T? Value<T>(Dictionary<string, object?>? row, string key) where T : struct =>
            row is not null && row.TryGetValue(key, out var value) && value is not null ? (T)Convert.ChangeType(value, typeof(T)) : null;
        static string? Text(Dictionary<string, object?>? row, string key) =>
            row is not null && row.TryGetValue(key, out var value) ? Convert.ToString(value) : null;
        var certificate = Row(metadata, "certificate");
        form.Certificate = new CertificateInput {
            CertificateId = Value<int>(certificate, "CertificateId"), CountryLocationId = Value<int>(certificate, "CertificateCountry"),
            YearId = int.TryParse(Text(certificate, "CertificateYear"), out var certificateYear) ? certificateYear : null,
            SeatNumber = Text(certificate, "CertificateSeatNo"), TotalResult = Value<decimal>(certificate, "CertificateTotalResult"),
            ResultPercentage = Value<decimal>(certificate, "CertificateResultPercentage"), SchoolName = Text(certificate, "SchoolId"),
            EducationalPlace = Text(certificate, "educationalPlace")
        };
        var contact = Row(metadata, "contact");
        form.Contact = new ContactInput {
            Phone = Text(contact, "StudentPhone"), Mobile = Text(contact, "StudentMobile"), Mobile2 = Text(contact, "StudentMobile2"),
            Email = Text(contact, "StudentEmail"), Facebook = Text(contact, "StudentFacebook"), Twitter = Text(contact, "StudentTwitter"),
            FatherMobile = Text(contact, "FatherMobile"), FatherEmail = Text(contact, "FatherEmail"), MotherMobile = Text(contact, "MotherMobile"),
            Address = Text(contact, "StudentAddress"), ArabicAddress = Text(contact, "ArStudentAddress"),
            AddressLocationId = Value<int>(contact, "StudentAddressLocation")
        };
        var activity = Row(metadata, "activity");
        form.Activity = new ActivityInput {
            ActivityId = Value<int>(activity, "ActivityId"), Place = Text(activity, "ActivityPlace"),
            Championship = Text(activity, "ActivityChampionship"), ChampionshipDate = Value<DateTime>(activity, "ActivityChampionshipDate")
        };
        var hobby = Row(metadata, "hobby");
        form.HobbyId = Value<int>(hobby, "HoppyId"); form.HobbyPlace = Text(hobby, "HoppyPlace");
        var military = Row(metadata, "military");
        form.ArmyStatusId = Value<int>(military, "ArmyId");
        form.ArmyExemptedNumber = Text(military, "ExemptedNumber");
        form.ArmyThirdNumber = Text(military, "ThirdNumber");
        form.ArmyExemptedDate = Value<DateTime>(military, "ExemptedDate");
        form.ArmyOperativeDecision = Text(military, "OperativeDecision");
        var acceptance = Row(metadata, "acceptance");
        form.AcceptanceTypeId = Value<int>(acceptance, "AcceptanceId");
        form.EnrollmentStatusId = Value<int>(acceptance, "EnrollmentId");
        form.AcceptanceDate = Value<DateTime>(acceptance, "AcceptanceDate");
        form.AcceptanceNumber = Value<int>(acceptance, "AcceptanceNumber");
        form.TransferDate = Value<DateTime>(acceptance, "TransferDate");
        form.TransferFrom = Text(acceptance, "TransferFrom");
        form.InstituteStatementId = Value<int>(Row(metadata, "discovery"), "InstituteStatmentId");
        return new(studentId, code, archived, version, form, metadata);
    }

    internal static async Task<bool> HasStudentVersionAsync(SqlConnection connection, CancellationToken ct, SqlTransaction? tx = null)
    {
        await using var command = Command(connection, "SELECT CASE WHEN COL_LENGTH(N'dbo.Students',N'SisVersion') IS NULL THEN 0 ELSE 1 END", tx);
        return Convert.ToInt32(await command.ExecuteScalarAsync(ct)) == 1;
    }
    internal static DateTime? NullableDate(SqlDataReader reader, string column) => reader.IsDBNull(reader.GetOrdinal(column)) ? null : reader.GetDateTime(reader.GetOrdinal(column));
}
