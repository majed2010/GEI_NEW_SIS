using System.Data;
using System.Buffers.Binary;
using System.Security.Claims;
using Microsoft.Data.SqlClient;
using Microsoft.Identity.Web;

namespace Gei.Sis.Api.Admissions;

public sealed class AdmissionsPhotos(AdmissionsRepository repository, IWebHostEnvironment environment, IConfiguration configuration)
{
    private string PhotoRoot => Path.Combine(environment.ContentRootPath, "App_Data", "admissions-photos");

    public async Task<(byte[] data, string contentType)?> ReadAsync(int studentId, ClaimsPrincipal principal, CancellationToken ct)
    {
        var detail = await repository.GetByIdAsync(studentId, ct);
        if (detail is null)
            throw new AdmissionsException(404, "student_missing", "الطالب غير موجود.");
        if (detail.Archived && !principal.IsInRole("Admissions.Supervisor"))
            throw new AdmissionsException(403, "archived_student_forbidden", "ليس لديك صلاحية عرض الطالب المؤرشف.");
        var name = detail.Student.Image;
        if (string.IsNullOrWhiteSpace(name) || name != Path.GetFileName(name)) return null;
        var extension = Path.GetExtension(name).ToLowerInvariant();
        if (extension is not ".jpg" and not ".jpeg" and not ".png") return null;
        var ownPath = Path.Combine(PhotoRoot, name);
        var legacyRoot = configuration["Admissions:LegacyImageRoot"];
        var path = File.Exists(ownPath) ? ownPath :
            string.IsNullOrWhiteSpace(legacyRoot) ? null : Path.Combine(Path.GetFullPath(Path.Combine(environment.ContentRootPath, legacyRoot)), name);
        if (path is null || !File.Exists(path)) return null;
        return (await File.ReadAllBytesAsync(path, ct), extension == ".png" ? "image/png" : "image/jpeg");
    }

    public async Task<SaveResult> SaveAsync(int studentId, string? version, Stream input, string? contentType,
        long? contentLength, ClaimsPrincipal principal, CancellationToken ct)
    {
        if (string.IsNullOrWhiteSpace(version)) throw new AdmissionsException(400, "version_required", "أعد تحميل ملف الطالب قبل رفع الصورة.");
        if (contentLength is null or < 1 or > 2_097_152)
            throw new AdmissionsException(400, "photo_size_invalid", "يجب أن يكون حجم الصورة أقل من ٢ ميجابايت.");
        if (contentType is not "image/jpeg" and not "image/png")
            throw new AdmissionsException(400, "photo_type_invalid", "استخدم صورة JPEG أو PNG.");
        using var memory = new MemoryStream();
        await input.CopyToAsync(memory, ct);
        if (memory.Length != contentLength || memory.Length > 2_097_152)
            throw new AdmissionsException(400, "photo_size_invalid", "حجم الصورة غير صالح.");
        var bytes = memory.ToArray();
        var jpeg = bytes.Length > 3 && bytes[0] == 0xff && bytes[1] == 0xd8 && bytes[^2] == 0xff && bytes[^1] == 0xd9;
        var png = bytes.Length > 8 && bytes.AsSpan(0, 8).SequenceEqual(new byte[] { 137, 80, 78, 71, 13, 10, 26, 10 });
        if (contentType == "image/jpeg" && !jpeg || contentType == "image/png" && !png)
            throw new AdmissionsException(400, "photo_content_invalid", "ملف الصورة غير صالح.");
        if (!SupportedDimensions(bytes, png))
            throw new AdmissionsException(400, "photo_dimensions_invalid", "أبعاد الصورة غير صالحة أو تتجاوز ٤٠٩٦ × ٤٠٩٦ بكسل.");
        var tenant = principal.GetTenantId(); var actor = principal.GetObjectId();
        if (!Guid.TryParse(tenant, out var tenantId) || !Guid.TryParse(actor, out var actorId))
            throw new AdmissionsException(403, "staff_identity_missing", "تعذر التحقق من هوية الموظف.");
        if (!repository.WritesEnabled)
            throw new AdmissionsException(503, "admissions_writes_disabled", "الكتابة متوقفة حتى اكتمال تجهيز القبول وإيقاف النظام القديم.");
        await using var connection = await repository.OpenAsync(ct);
        await using var tx = (SqlTransaction)await connection.BeginTransactionAsync(IsolationLevel.Serializable, ct);
        string? path = null;
        try
        {
            if (!await AdmissionsRepository.HasSupportSchemaAsync(connection, ct, tx) ||
                !await AdmissionsRepository.HasStudentVersionAsync(connection, ct, tx))
                throw new AdmissionsException(503, "admissions_setup_required", "إعداد قاعدة بيانات القبول لم يكتمل.");
            var detail = await AdmissionsRepository.GetByIdAsync(connection, studentId, ct, tx)
                ?? throw new AdmissionsException(404, "student_missing", "الطالب غير موجود.");
            if (detail.Archived) throw new AdmissionsException(409, "student_archived", "استعد الطالب من الأرشيف قبل رفع الصورة.");
            if (detail.Version != version) throw new AdmissionsException(412, "stale_student", "تغير سجل الطالب. أعد تحميله.");
            Directory.CreateDirectory(PhotoRoot);
            var name = Guid.NewGuid().ToString("N") + (png ? ".png" : ".jpg");
            path = Path.Combine(PhotoRoot, name);
            await File.WriteAllBytesAsync(path, bytes, ct);
            await using (var update = AdmissionsRepository.Command(connection, "UPDATE dbo.Students SET Image=@image,StudentDateUpdated=CONVERT(date,SYSUTCDATETIME()) WHERE StudentId=@id AND SisVersion=@version", tx))
            {
                AdmissionsRepository.Add(update, "@image", SqlDbType.VarChar, name, 100);
                AdmissionsRepository.Add(update, "@id", SqlDbType.Int, studentId);
                AdmissionsRepository.Add(update, "@version", SqlDbType.Timestamp, Convert.FromBase64String(version), 8);
                if (await update.ExecuteNonQueryAsync(ct) != 1) throw new AdmissionsException(412, "stale_student", "تغير سجل الطالب. أعد تحميله.");
            }
            await using (var audit = AdmissionsRepository.Command(connection, "INSERT sis.AdmissionsAudit(StudentId,ActionName,OccurredAtUtc,ActorTenantId,ActorObjectId,CorrelationId,ChangedFieldNames) VALUES(@id,'Update',SYSUTCDATETIME(),@tid,@oid,@correlation,N'Image')", tx))
            {
                AdmissionsRepository.Add(audit, "@id", SqlDbType.Int, studentId);
                AdmissionsRepository.Add(audit, "@tid", SqlDbType.UniqueIdentifier, tenantId);
                AdmissionsRepository.Add(audit, "@oid", SqlDbType.UniqueIdentifier, actorId);
                AdmissionsRepository.Add(audit, "@correlation", SqlDbType.UniqueIdentifier, Guid.NewGuid());
                await audit.ExecuteNonQueryAsync(ct);
            }
            var saved = await AdmissionsRepository.GetByIdAsync(connection, studentId, ct, tx);
            await tx.CommitAsync(ct);
            return new(studentId, detail.StudentCode, saved?.Version ?? "");
        }
        catch
        {
            await tx.RollbackAsync(CancellationToken.None);
            if (path is not null && File.Exists(path)) File.Delete(path);
            throw;
        }
    }

    private static bool SupportedDimensions(byte[] bytes, bool png)
    {
        static bool Valid(int width, int height) => width is > 0 and <= 4096 && height is > 0 and <= 4096;
        if (png)
            return bytes.Length >= 24 && bytes.AsSpan(12, 4).SequenceEqual("IHDR"u8) &&
                Valid(BinaryPrimitives.ReadInt32BigEndian(bytes.AsSpan(16, 4)), BinaryPrimitives.ReadInt32BigEndian(bytes.AsSpan(20, 4)));
        for (var i = 2; i + 4 < bytes.Length;)
        {
            if (bytes[i++] != 0xff) return false;
            while (i < bytes.Length && bytes[i] == 0xff) i++;
            if (i >= bytes.Length) return false;
            var marker = bytes[i++];
            if (marker is 0xd8 or 0xd9 or 0x01 || marker is >= 0xd0 and <= 0xd7) continue;
            if (i + 2 > bytes.Length) return false;
            var length = BinaryPrimitives.ReadUInt16BigEndian(bytes.AsSpan(i, 2));
            if (length < 2 || i + length > bytes.Length) return false;
            if (marker is >= 0xc0 and <= 0xc3 or >= 0xc5 and <= 0xc7 or >= 0xc9 and <= 0xcb or >= 0xcd and <= 0xcf)
                return length >= 7 && Valid(BinaryPrimitives.ReadUInt16BigEndian(bytes.AsSpan(i + 5, 2)),
                    BinaryPrimitives.ReadUInt16BigEndian(bytes.AsSpan(i + 3, 2)));
            i += length;
        }
        return false;
    }
}
