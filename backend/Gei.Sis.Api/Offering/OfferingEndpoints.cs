using System.Data;
using System.Security.Claims;
using Microsoft.Data.SqlClient;
using Microsoft.Identity.Web;

namespace Gei.Sis.Api.Offering;

public sealed record OfferingInput(int CourseId, int DepartmentId, string? Version);
public sealed record SectionInput(int? ParentId, int SectionTypeId, int Capacity, string? Version);
public sealed record DeactivateInput(string Version);
public sealed record OfferingSearch(int? SemesterId, int? DepartmentId, string? Query, string? State, bool? MissingSections, int Page = 1);
public sealed record OfferingContext(int? SemesterId, string? SemesterName, bool SupportReady, bool WritesEnabled, string? Message);
public sealed record OfferingLookup(int Id, string Label, string? Code = null, bool Hidden = false);
public sealed record OfferingRow(int Id, int? CourseId, int? SemesterId, int? DepartmentId, string? CourseName,
    string? CourseCode, string? DepartmentName, bool Active, int SectionCount, int EnrollmentCount, string? Version,
    string? Warning);
public sealed record OfferingSearchResult(IReadOnlyList<OfferingRow> Rows, int Total, int Page);
public sealed record SectionRow(int Id, int? ParentId, int? TypeId, string? TypeName, string? Code, int? Capacity,
    bool Active, int EnrollmentCount, bool HasSchedule, string? Version);
public sealed record OfferingIssue(int SectionId, string? SectionCode, string? CourseName, string Kind);
public sealed record OfferingDetail(OfferingRow Offering, IReadOnlyList<SectionRow> Sections);
public sealed class OfferingException(int status, string code, string message) : Exception(message)
{
    public int Status { get; } = status;
    public string Code { get; } = code;
}

public static class OfferingEndpoints
{
    public static IEndpointRouteBuilder MapOffering(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/api/offering").RequireAuthorization("Staff");
        group.MapGet("/context", async (OfferingService service, CancellationToken ct) => await Run(() => service.Context(ct)));
        group.MapGet("/lookups", async (OfferingService service, CancellationToken ct) => await Run(() => service.Lookups(ct)));
        group.MapPost("/search", async (OfferingSearch request, OfferingService service, CancellationToken ct) => await Run(() => service.Search(request, ct)));
        group.MapGet("/review/{semesterId:int}", async (int semesterId, OfferingService service, CancellationToken ct) => await Run(() => service.Review(semesterId, ct)));
        group.MapGet("/{id:int}", async (int id, OfferingService service, CancellationToken ct) => await Run(() => service.Detail(id, ct)));
        group.MapPost("/", async (OfferingInput input, ClaimsPrincipal actor, OfferingService service, CancellationToken ct) =>
            await Run(() => service.SaveOffering(null, input, actor, ct))).RequireAuthorization("OfferingManager");
        group.MapPut("/{id:int}", async (int id, OfferingInput input, ClaimsPrincipal actor, OfferingService service, CancellationToken ct) =>
            await Run(() => service.SaveOffering(id, input, actor, ct))).RequireAuthorization("OfferingManager");
        group.MapPost("/{id:int}/deactivate", async (int id, DeactivateInput input, ClaimsPrincipal actor, OfferingService service, CancellationToken ct) =>
            await Run(() => service.DeactivateOffering(id, input.Version, actor, ct))).RequireAuthorization("OfferingAdministrator");
        group.MapPost("/{id:int}/sections", async (int id, SectionInput input, ClaimsPrincipal actor, OfferingService service, CancellationToken ct) =>
            await Run(() => service.SaveSection(id, null, input, actor, ct))).RequireAuthorization("OfferingManager");
        group.MapPut("/sections/{id:int}", async (int id, SectionInput input, ClaimsPrincipal actor, OfferingService service, CancellationToken ct) =>
            await Run(() => service.SaveSection(null, id, input, actor, ct))).RequireAuthorization("OfferingManager");
        group.MapPost("/sections/{id:int}/deactivate", async (int id, DeactivateInput input, ClaimsPrincipal actor, OfferingService service, CancellationToken ct) =>
            await Run(() => service.DeactivateSection(id, input.Version, actor, ct))).RequireAuthorization("OfferingAdministrator");
        return app;
    }
    private static async Task<IResult> Run<T>(Func<Task<T>> action)
    {
        try { return Results.Ok(await action()); }
        catch (OfferingException e) { return Results.Json(new { e.Code, message = e.Message }, statusCode: e.Status); }
        catch (SqlException e) when (e.Number is 2601 or 2627 or 547 or 1205)
        { return Results.Json(new { code = "offering_conflict", message = "تعارضت البيانات مع تعديل آخر. حدّث الصفحة وحاول مرة أخرى." }, statusCode: 409); }
    }
}

public sealed class OfferingService(IConfiguration configuration)
{
    private readonly string connectionString = configuration.GetConnectionString("TeiDB")
        ?? throw new InvalidOperationException("ConnectionStrings:TeiDB is required.");
    private bool WritesEnabled => configuration.GetValue<bool>("Offering:WritesEnabled");
    private async Task<SqlConnection> Open(CancellationToken ct)
    {
        var c = new SqlConnection(connectionString);
        try { await c.OpenAsync(ct); return c; } catch { await c.DisposeAsync(); throw; }
    }
    private static SqlCommand Cmd(SqlConnection c, string sql, SqlTransaction? tx = null)
    {
        var q = c.CreateCommand(); q.CommandText = sql; q.CommandTimeout = 45; q.Transaction = tx; return q;
    }
    private static void Add(SqlCommand q, string name, SqlDbType type, object? value, int size = 0)
    {
        var p = size == 0 ? q.Parameters.Add(name, type) : q.Parameters.Add(name, type, size);
        p.Value = value ?? DBNull.Value;
    }
    private static int? NInt(SqlDataReader r, int i) => r.IsDBNull(i) ? null : r.GetInt32(i);
    private static string? NString(SqlDataReader r, int i) => r.IsDBNull(i) ? null : r.GetString(i);
    private static bool Enabled(SqlDataReader r, int i) => r.IsDBNull(i) || r.GetBoolean(i);
    private static string? Version(SqlDataReader r, int i) => r.IsDBNull(i) ? null : Convert.ToBase64String((byte[])r.GetValue(i));
    private static byte[] ParseVersion(string? value)
    {
        try { var b = Convert.FromBase64String(value ?? ""); if (b.Length == 8) return b; } catch (FormatException) { }
        throw new OfferingException(400, "version_required", "نسخة السجل غير صالحة. حدّث البيانات أولاً.");
    }
    private static (Guid tenant, Guid actor) Actor(ClaimsPrincipal p)
    {
        if (!Guid.TryParse(p.GetTenantId(), out var tenant) || !Guid.TryParse(p.GetObjectId(), out var actor))
            throw new OfferingException(403, "identity_missing", "تعذر التحقق من هوية الموظف.");
        return (tenant, actor);
    }
    private static async Task<bool> Support(SqlConnection c, CancellationToken ct, SqlTransaction? tx = null)
    {
        await using var q = Cmd(c, "SELECT CASE WHEN OBJECT_ID(N'sis.OfferingLectureCounter',N'U') IS NOT NULL AND OBJECT_ID(N'sis.OfferingChildCounter',N'U') IS NOT NULL AND OBJECT_ID(N'sis.OfferingAudit',N'U') IS NOT NULL AND COL_LENGTH(N'Offering.OfferedCourses',N'SisVersion') IS NOT NULL AND COL_LENGTH(N'Offering.Section',N'SisVersion') IS NOT NULL THEN 1 ELSE 0 END", tx);
        return Convert.ToInt32(await q.ExecuteScalarAsync(ct)) == 1;
    }
    private static async Task<(int? id,string? name,string? error)> Term(SqlConnection c, CancellationToken ct, SqlTransaction? tx = null)
    {
        await using var q = Cmd(c, "SELECT TOP (2) a.OfferingSemester,s.ArSemesterName,s.Hide FROM dbo.ActiveSemesters a LEFT JOIN dbo.Semesters s ON s.SemesterId=a.OfferingSemester ORDER BY a.Id", tx);
        await using var r = await q.ExecuteReaderAsync(ct);
        if (!await r.ReadAsync(ct)) return (null,null,"لم يتم إعداد الفصل النشط للطرح.");
        var id = NInt(r,0); var name = NString(r,1); var hidden = !r.IsDBNull(2) && r.GetBoolean(2);
        if (await r.ReadAsync(ct)) return (null,null,"يوجد أكثر من سجل إعدادات للفصل النشط.");
        if (id is null || name is null || hidden) return (id,name,"فصل الطرح النشط غير مضبوط أو غير متاح.");
        return (id,name,null);
    }
    public async Task<OfferingContext> Context(CancellationToken ct)
    {
        await using var c = await Open(ct);
        var term = await Term(c,ct); var support = await Support(c,ct);
        var message = term.error ?? (!support ? "لم تُطبّق جداول دعم الطرح بعد." : !WritesEnabled ? "كتابة الطرح موقوفة في الإعدادات." : null);
        return new(term.id,term.name,support,WritesEnabled && support && term.error is null,message);
    }
    public async Task<object> Lookups(CancellationToken ct)
    {
        await using var c = await Open(ct);
        async Task<List<OfferingLookup>> Read(string sql, bool code)
        {
            await using var q = Cmd(c,sql); await using var r = await q.ExecuteReaderAsync(ct);
            var items = new List<OfferingLookup>();
            while (await r.ReadAsync(ct)) items.Add(new(r.GetInt32(0),NString(r,1) ?? $"#{r.GetInt32(0)}", code ? NString(r,2) : null,
                !r.IsDBNull(code ? 3 : 2) && r.GetBoolean(code ? 3 : 2)));
            return items;
        }
        return new {
            semesters = await Read("SELECT SemesterId,ArSemesterName,Hide FROM dbo.Semesters ORDER BY SemesterId DESC",false),
            departments = await Read("SELECT DepartmentId,ArDepartmentName,Hide FROM dbo.Departments ORDER BY ArDepartmentName",false),
            courses = await Read("SELECT CourseId,ArCourseName,ArCourseCode,Hide FROM dbo.Courses ORDER BY ArCourseName",true),
            sectionTypes = await Read("SELECT SectionTypeid,SectionTypeName,CAST(0 AS bit) FROM Offering.SectionType ORDER BY SectionTypeid",false)
        };
    }
    private const string OfferingSelect = """
      SELECT o.Id,o.CourseId,o.SemesterId,o.DepartmentId,c.ArCourseName,c.ArCourseCode,d.ArDepartmentName,o.Active,
        (SELECT COUNT(*) FROM Offering.Section s WHERE s.CourseId=o.CourseId AND s.SemesterId=o.SemesterId AND (s.DepartmentId=o.DepartmentId OR (s.DepartmentId IS NULL AND EXISTS (SELECT 1 FROM Offering.Section p WHERE p.SectionId=s.ParentId AND p.DepartmentId=o.DepartmentId)))) AS SectionCount,
        (SELECT COUNT(*) FROM dbo.StudentSection ss JOIN Offering.Section s ON s.SectionId=ss.SectionId WHERE s.CourseId=o.CourseId AND s.SemesterId=o.SemesterId AND s.DepartmentId=o.DepartmentId) AS EnrollmentCount,
        o.SisVersion,
        CASE WHEN (SELECT COUNT(*) FROM Offering.OfferedCourses du WHERE du.CourseId=o.CourseId AND du.SemesterId=o.SemesterId AND du.DepartmentId=o.DepartmentId)>1 THEN N'طرح مكرر'
             WHEN NOT EXISTS(SELECT 1 FROM Offering.Section s WHERE s.CourseId=o.CourseId AND s.SemesterId=o.SemesterId AND s.DepartmentId=o.DepartmentId) THEN N'لا توجد محاضرة'
             ELSE NULL END AS Warning
      FROM Offering.OfferedCourses o
      LEFT JOIN dbo.Courses c ON c.CourseId=o.CourseId
      LEFT JOIN dbo.Departments d ON d.DepartmentId=o.DepartmentId
    """;
    private static OfferingRow MapOffering(SqlDataReader r) => new(r.GetInt32(0),NInt(r,1),NInt(r,2),NInt(r,3),NString(r,4),NString(r,5),NString(r,6),Enabled(r,7),r.GetInt32(8),r.GetInt32(9),Version(r,10),NString(r,11));
    public async Task<OfferingSearchResult> Search(OfferingSearch search, CancellationToken ct)
    {
        if (search.Page < 1 || search.Page > 100000) throw new OfferingException(400,"invalid_page","رقم الصفحة غير صالح.");
        await using var c = await Open(ct);
        var term = await Term(c,ct); var semester = search.SemesterId ?? term.id;
        if (semester is null) return new(Array.Empty<OfferingRow>(),0,search.Page);
        var query = (search.Query ?? "").Trim(); if (query.Length>100) throw new OfferingException(400,"invalid_query","البحث طويل جداً.");
        var where = " WHERE o.SemesterId=@term AND (@dept IS NULL OR o.DepartmentId=@dept) AND (@query=N'' OR c.ArCourseName LIKE @pattern OR c.ArCourseCode LIKE @pattern OR c.CourseCode LIKE @pattern) AND (@state=N'all' OR (@state=N'active' AND ISNULL(o.Active,1)=1) OR (@state=N'inactive' AND o.Active=0)) ";
        if (search.MissingSections == true) where += " AND NOT EXISTS(SELECT 1 FROM Offering.Section s WHERE s.CourseId=o.CourseId AND s.SemesterId=o.SemesterId AND s.DepartmentId=o.DepartmentId) ";
        await using var count = Cmd(c,"SELECT COUNT(*) FROM Offering.OfferedCourses o LEFT JOIN dbo.Courses c ON c.CourseId=o.CourseId"+where);
        Params(count);
        var total = Convert.ToInt32(await count.ExecuteScalarAsync(ct));
        await using var q = Cmd(c,OfferingSelect+where+" ORDER BY o.Id DESC OFFSET @offset ROWS FETCH NEXT 25 ROWS ONLY");
        Params(q); Add(q,"@offset",SqlDbType.Int,(search.Page-1)*25);
        await using var r = await q.ExecuteReaderAsync(ct); var rows = new List<OfferingRow>();
        while (await r.ReadAsync(ct)) rows.Add(MapOffering(r));
        return new(rows,total,search.Page);
        void Params(SqlCommand command) { Add(command,"@term",SqlDbType.Int,semester); Add(command,"@dept",SqlDbType.Int,search.DepartmentId); Add(command,"@query",SqlDbType.NVarChar,query,100); Add(command,"@pattern",SqlDbType.NVarChar,"%"+query.Replace("[","[[]").Replace("%","[%]").Replace("_","[_]")+"%",205); Add(command,"@state",SqlDbType.NVarChar,search.State is "active" or "inactive" ? search.State : "all",10); }
    }
    public async Task<OfferingDetail> Detail(int id, CancellationToken ct)
    {
        await using var c = await Open(ct);
        await using var q = Cmd(c,OfferingSelect+" WHERE o.Id=@id"); Add(q,"@id",SqlDbType.Int,id);
        await using var r = await q.ExecuteReaderAsync(ct);
        if (!await r.ReadAsync(ct)) throw new OfferingException(404,"offering_missing","الطرح غير موجود.");
        var offering = MapOffering(r); await r.DisposeAsync();
        await using var sq = Cmd(c,"""
            SELECT s.SectionId,s.ParentId,s.SectionTypeId,t.SectionTypeName,s.SectionCode,s.Capacity,s.IsActive,
              (SELECT COUNT(*) FROM dbo.StudentSection ss WHERE ss.SectionId=s.SectionId),
              CASE WHEN EXISTS(SELECT 1 FROM Offering.SummerizeScheduale x WHERE x.SectionId=s.SectionId)
                     OR EXISTS(SELECT 1 FROM Offering.Scheduale x WHERE x.SectionId=s.SectionId) THEN CAST(1 AS bit) ELSE CAST(0 AS bit) END,
              s.SisVersion
            FROM Offering.Section s LEFT JOIN Offering.SectionType t ON t.SectionTypeid=s.SectionTypeId
            WHERE s.CourseId=@course AND s.SemesterId=@term
              AND (s.DepartmentId=@dept OR (s.DepartmentId IS NULL AND EXISTS
                  (SELECT 1 FROM Offering.Section p WHERE p.SectionId=s.ParentId AND p.DepartmentId=@dept)))
            ORDER BY COALESCE(NULLIF(s.ParentId,s.SectionId),s.SectionId),CASE WHEN s.ParentId=s.SectionId THEN 0 ELSE 1 END,s.SectionId
            """);
        Add(sq,"@course",SqlDbType.Int,offering.CourseId); Add(sq,"@term",SqlDbType.Int,offering.SemesterId); Add(sq,"@dept",SqlDbType.Int,offering.DepartmentId);
        await using var sr = await sq.ExecuteReaderAsync(ct); var sections = new List<SectionRow>();
        while (await sr.ReadAsync(ct)) sections.Add(new(sr.GetInt32(0),NInt(sr,1),NInt(sr,2),NString(sr,3),NString(sr,4),NInt(sr,5),Enabled(sr,6),sr.GetInt32(7),sr.GetBoolean(8),Version(sr,9)));
        return new(offering,sections);
    }
    public async Task<IReadOnlyList<OfferingIssue>> Review(int semesterId, CancellationToken ct)
    {
        if (semesterId <= 0) throw new OfferingException(400,"invalid_term","الفصل غير صالح.");
        await using var c = await Open(ct);
        await using var q = Cmd(c,"""
            SELECT TOP (100) s.SectionId,s.SectionCode,c.ArCourseName,
              CASE WHEN NOT EXISTS(SELECT 1 FROM Offering.OfferedCourses o WHERE o.CourseId=s.CourseId AND o.SemesterId=s.SemesterId)
                   THEN N'شعبة بلا طرح مطابق' ELSE N'رابط المحاضرة الأصلية غير صالح' END AS Issue
            FROM Offering.Section s LEFT JOIN dbo.Courses c ON c.CourseId=s.CourseId
            WHERE s.SemesterId=@term AND (
              NOT EXISTS(SELECT 1 FROM Offering.OfferedCourses o WHERE o.CourseId=s.CourseId AND o.SemesterId=s.SemesterId)
              OR s.ParentId IS NULL
              OR (s.ParentId<>s.SectionId AND NOT EXISTS(SELECT 1 FROM Offering.Section p WHERE p.SectionId=s.ParentId AND p.CourseId=s.CourseId AND p.SemesterId=s.SemesterId))
            ) ORDER BY s.SectionId DESC
            """);
        Add(q,"@term",SqlDbType.Int,semesterId);
        await using var r=await q.ExecuteReaderAsync(ct); var issues=new List<OfferingIssue>();
        while(await r.ReadAsync(ct)) issues.Add(new(r.GetInt32(0),NString(r,1),NString(r,2),r.GetString(3)));
        return issues;
    }
    private async Task<(SqlConnection c,SqlTransaction tx,int term,Guid tenant,Guid actor)> BeginWrite(ClaimsPrincipal principal,CancellationToken ct)
    {
        if (!WritesEnabled) throw new OfferingException(503,"writes_disabled","كتابة الطرح موقوفة في الإعدادات.");
        var identity=Actor(principal); var c=await Open(ct);
        try {
            var tx=(SqlTransaction)await c.BeginTransactionAsync(IsolationLevel.Serializable,ct);
            if (!await Support(c,ct,tx)) throw new OfferingException(503,"schema_missing","جداول دعم الطرح غير جاهزة.");
            var term=await Term(c,ct,tx);
            if (term.error is not null || term.id is null) throw new OfferingException(503,"term_missing",term.error ?? "فصل الطرح غير مضبوط.");
            return (c,tx,term.id.Value,identity.tenant,identity.actor);
        } catch { await c.DisposeAsync(); throw; }
    }
    private static async Task Audit(SqlConnection c,SqlTransaction tx,string entity,int id,string action,Guid tenant,Guid actor,byte[]? before,byte[]? after,CancellationToken ct)
    {
        await using var q=Cmd(c,"INSERT sis.OfferingAudit(EntityType,EntityId,ActionName,ActorTenantId,ActorObjectId,PreviousVersion,NewVersion) VALUES(@entity,@id,@action,@tenant,@actor,@before,@after)",tx);
        Add(q,"@entity",SqlDbType.VarChar,entity,20); Add(q,"@id",SqlDbType.Int,id); Add(q,"@action",SqlDbType.VarChar,action,20);
        Add(q,"@tenant",SqlDbType.UniqueIdentifier,tenant); Add(q,"@actor",SqlDbType.UniqueIdentifier,actor);
        Add(q,"@before",SqlDbType.VarBinary,before,8); Add(q,"@after",SqlDbType.VarBinary,after,8);
        await q.ExecuteNonQueryAsync(ct);
    }
    private static async Task<byte[]> ReadVersion(SqlConnection c,SqlTransaction tx,string table,string key,int id,CancellationToken ct)
    {
        await using var q=Cmd(c,$"SELECT SisVersion FROM {table} WHERE {key}=@id",tx); Add(q,"@id",SqlDbType.Int,id);
        return (byte[]?)await q.ExecuteScalarAsync(ct) ?? throw new OfferingException(404,"record_missing","السجل غير موجود.");
    }
    private static void Match(string? supplied,byte[] actual)
    {
        if (!ParseVersion(supplied).SequenceEqual(actual)) throw new OfferingException(409,"version_conflict","تغير السجل منذ فتحه. حدّث البيانات.");
    }
    private static async Task<int> ScalarInt(SqlConnection c,SqlTransaction tx,string sql,CancellationToken ct,params (string,SqlDbType,object?)[] args)
    {
        await using var q=Cmd(c,sql,tx); foreach(var a in args) Add(q,a.Item1,a.Item2,a.Item3);
        return Convert.ToInt32(await q.ExecuteScalarAsync(ct));
    }
    private static (string,SqlDbType,object?) P(string name,int? value)=>(name,SqlDbType.Int,value);
    public async Task<object> SaveOffering(int? id,OfferingInput input,ClaimsPrincipal principal,CancellationToken ct)
    {
        if(input.CourseId<=0 || input.DepartmentId<=0) throw new OfferingException(400,"invalid_input","اختر المقرر والقسم.");
        var w=await BeginWrite(principal,ct); await using var c=w.c; await using var tx=w.tx;
        try {
            if (await ScalarInt(c,tx,"SELECT COUNT(*) FROM dbo.Courses WHERE CourseId=@id AND ISNULL(Hide,0)=0",ct,P("@id",input.CourseId))!=1 ||
                await ScalarInt(c,tx,"SELECT COUNT(*) FROM dbo.Departments WHERE DepartmentId=@id AND ISNULL(Hide,0)=0",ct,P("@id",input.DepartmentId))!=1)
                throw new OfferingException(400,"invalid_lookup","المقرر أو القسم غير متاح.");
            byte[]? before=null;
            if(id is not null) {
                await using var old=Cmd(c,"SELECT SemesterId,CourseId,DepartmentId,Active,SisVersion FROM Offering.OfferedCourses WITH (UPDLOCK,HOLDLOCK) WHERE Id=@id",tx);
                Add(old,"@id",SqlDbType.Int,id); await using var r=await old.ExecuteReaderAsync(ct);
                if(!await r.ReadAsync(ct)) throw new OfferingException(404,"offering_missing","الطرح غير موجود.");
                if(NInt(r,0)!=w.term) throw new OfferingException(409,"historical_read_only","يمكن تعديل فصل الطرح النشط فقط.");
                if(!Enabled(r,3)) throw new OfferingException(409,"inactive_offering","الطرح غير نشط.");
                before=(byte[])r.GetValue(4); Match(input.Version,before);
                var previousCourse=NInt(r,1); var previousDepartment=NInt(r,2);
                var changed=previousCourse!=input.CourseId || previousDepartment!=input.DepartmentId;
                await r.DisposeAsync();
                if(changed && await ScalarInt(c,tx,"SELECT COUNT(*) FROM Offering.Section s WHERE s.CourseId=@course AND s.SemesterId=@term AND (s.DepartmentId=@dept OR (s.DepartmentId IS NULL AND EXISTS(SELECT 1 FROM Offering.Section p WHERE p.SectionId=s.ParentId AND p.DepartmentId=@dept)))",ct,P("@course",previousCourse),P("@term",w.term),P("@dept",previousDepartment))>0)
                    throw new OfferingException(409,"sections_exist","لا يمكن تغيير المقرر أو القسم بعد إنشاء شعب.");
            }
            if(await ScalarInt(c,tx,"SELECT COUNT(*) FROM Offering.OfferedCourses WITH (UPDLOCK,HOLDLOCK) WHERE CourseId=@course AND DepartmentId=@dept AND SemesterId=@term AND (@id IS NULL OR Id<>@id)",ct,P("@course",input.CourseId),P("@dept",input.DepartmentId),P("@term",w.term),P("@id",id))>0)
                throw new OfferingException(409,"duplicate_offering","هذا المقرر مطروح بالفعل لهذا القسم والفصل.");
            int saved;
            if(id is null) {
                await using var q=Cmd(c,"INSERT Offering.OfferedCourses(CourseId,SemesterId,DepartmentId,AddedDate,Active) OUTPUT INSERTED.Id VALUES(@course,@term,@dept,GETDATE(),1)",tx);
                Add(q,"@course",SqlDbType.Int,input.CourseId); Add(q,"@term",SqlDbType.Int,w.term); Add(q,"@dept",SqlDbType.Int,input.DepartmentId);
                saved=Convert.ToInt32(await q.ExecuteScalarAsync(ct));
            } else {
                saved=id.Value; await using var q=Cmd(c,"UPDATE Offering.OfferedCourses SET CourseId=@course,DepartmentId=@dept WHERE Id=@id AND SisVersion=@version",tx);
                Add(q,"@course",SqlDbType.Int,input.CourseId); Add(q,"@dept",SqlDbType.Int,input.DepartmentId); Add(q,"@id",SqlDbType.Int,id); Add(q,"@version",SqlDbType.VarBinary,before,8);
                if(await q.ExecuteNonQueryAsync(ct)!=1) throw new OfferingException(409,"version_conflict","تغير السجل منذ فتحه.");
            }
            var after=await ReadVersion(c,tx,"Offering.OfferedCourses","Id",saved,ct);
            await Audit(c,tx,"Offering",saved,id is null?"Create":"Update",w.tenant,w.actor,before,after,ct);
            await tx.CommitAsync(ct); return new { id=saved,version=Convert.ToBase64String(after) };
        } catch { await tx.RollbackAsync(CancellationToken.None); throw; }
    }
    public async Task<object> SaveSection(int? offeringId,int? sectionId,SectionInput input,ClaimsPrincipal principal,CancellationToken ct)
    {
        if(input.Capacity<1 || input.Capacity>10000) throw new OfferingException(400,"invalid_capacity","السعة يجب أن تكون بين 1 و 10000.");
        var w=await BeginWrite(principal,ct); await using var c=w.c; await using var tx=w.tx;
        try {
            int course,dept; int? parent=input.ParentId; byte[]? before=null;
            if(sectionId is null) {
                if(offeringId is null) throw new OfferingException(400,"offering_required","اختر الطرح.");
                await using var oq=Cmd(c,"SELECT CourseId,DepartmentId,SemesterId,Active FROM Offering.OfferedCourses WITH (UPDLOCK,HOLDLOCK) WHERE Id=@id",tx);
                Add(oq,"@id",SqlDbType.Int,offeringId); await using var r=await oq.ExecuteReaderAsync(ct);
                if(!await r.ReadAsync(ct)) throw new OfferingException(404,"offering_missing","الطرح غير موجود.");
                course=NInt(r,0)??0; dept=NInt(r,1)??0;
                if(NInt(r,2)!=w.term || !Enabled(r,3)) throw new OfferingException(409,"offering_not_writable","الطرح ليس نشطاً في الفصل الحالي.");
                await r.DisposeAsync();
                if(input.SectionTypeId==1) { if(parent is not null) throw new OfferingException(400,"parent_invalid","المحاضرة لا تتبع محاضرة أخرى."); }
                else if(input.SectionTypeId is not (2 or 3 or 25) || parent is null)
                    throw new OfferingException(400,"parent_required","اختر نوع الشعبة والمحاضرة الأصلية.");
            } else {
                await using var sq=Cmd(c,"SELECT CourseId,SemesterId,DepartmentId,ParentId,SectionTypeId,IsActive,SisVersion FROM Offering.Section WITH (UPDLOCK,HOLDLOCK) WHERE SectionId=@id",tx);
                Add(sq,"@id",SqlDbType.Int,sectionId); await using var r=await sq.ExecuteReaderAsync(ct);
                if(!await r.ReadAsync(ct)) throw new OfferingException(404,"section_missing","الشعبة غير موجودة.");
                course=NInt(r,0)??0; dept=NInt(r,2)??0;
                if(NInt(r,1)!=w.term || !Enabled(r,5)) throw new OfferingException(409,"section_not_writable","يمكن تعديل الشعب النشطة في الفصل الحالي فقط.");
                if(NInt(r,4)!=input.SectionTypeId || NInt(r,3)!=(input.SectionTypeId==1 ? sectionId : parent))
                    throw new OfferingException(400,"structure_immutable","نوع الشعبة والمحاضرة الأصلية لا يتغيران.");
                before=(byte[])r.GetValue(6); Match(input.Version,before); await r.DisposeAsync();
                if(await ScalarInt(c,tx,"SELECT COUNT(*) FROM dbo.StudentSection WHERE SectionId=@id",ct,P("@id",sectionId))>input.Capacity)
                    throw new OfferingException(409,"capacity_below_enrollment","السعة أقل من عدد الطلاب المسجلين.");
                await using var uq=Cmd(c,"UPDATE Offering.Section SET Capacity=@capacity WHERE SectionId=@id AND SisVersion=@version",tx);
                Add(uq,"@capacity",SqlDbType.Int,input.Capacity); Add(uq,"@id",SqlDbType.Int,sectionId); Add(uq,"@version",SqlDbType.VarBinary,before,8);
                if(await uq.ExecuteNonQueryAsync(ct)!=1) throw new OfferingException(409,"version_conflict","تغيرت الشعبة منذ فتحها.");
                var updated=await ReadVersion(c,tx,"Offering.Section","SectionId",sectionId.Value,ct);
                await Audit(c,tx,"Section",sectionId.Value,"Update",w.tenant,w.actor,before,updated,ct);
                await tx.CommitAsync(ct); return new { id=sectionId,version=Convert.ToBase64String(updated) };
            }
            string prefix;
            if(input.SectionTypeId==1) {
                await using var cq=Cmd(c,"SELECT LTRIM(RTRIM(ArCourseCode)) FROM dbo.Courses WHERE CourseId=@id AND ISNULL(Hide,0)=0",tx);
                Add(cq,"@id",SqlDbType.Int,course); prefix=(string?)await cq.ExecuteScalarAsync(ct) ?? "";
                if(string.IsNullOrWhiteSpace(prefix) || prefix.Length>40) throw new OfferingException(409,"course_code_missing","كود المقرر العربي غير صالح لتوليد كود المحاضرة.");
            } else {
                await using var pq=Cmd(c,"SELECT SectionCode FROM Offering.Section WITH (UPDLOCK,HOLDLOCK) WHERE SectionId=@parent AND ParentId=SectionId AND SectionTypeId=1 AND CourseId=@course AND SemesterId=@term AND DepartmentId=@dept AND ISNULL(IsActive,1)=1",tx);
                Add(pq,"@parent",SqlDbType.Int,parent); Add(pq,"@course",SqlDbType.Int,course); Add(pq,"@term",SqlDbType.Int,w.term); Add(pq,"@dept",SqlDbType.Int,dept);
                prefix=(string?)await pq.ExecuteScalarAsync(ct) ?? throw new OfferingException(409,"invalid_parent","المحاضرة الأصلية غير نشطة أو لا تتبع هذا الطرح.");
            }
            int next=0; string code="";
            for(var attempt=0;attempt<100;attempt++) {
                if(input.SectionTypeId==1) {
                    await using var seed=Cmd(c,"IF NOT EXISTS(SELECT 1 FROM sis.OfferingLectureCounter WITH (UPDLOCK,HOLDLOCK) WHERE Prefix=@prefix) INSERT sis.OfferingLectureCounter(Prefix,LastAllocated) VALUES(@prefix,0)",tx);
                    Add(seed,"@prefix",SqlDbType.NVarChar,prefix,50); await seed.ExecuteNonQueryAsync(ct);
                    await using var aq=Cmd(c,"UPDATE sis.OfferingLectureCounter SET LastAllocated=LastAllocated+1 OUTPUT INSERTED.LastAllocated WHERE Prefix=@prefix",tx);
                    Add(aq,"@prefix",SqlDbType.NVarChar,prefix,50); next=Convert.ToInt32(await aq.ExecuteScalarAsync(ct));
                } else {
                    await using var seed=Cmd(c,"IF NOT EXISTS(SELECT 1 FROM sis.OfferingChildCounter WITH (UPDLOCK,HOLDLOCK) WHERE ParentSectionId=@parent) INSERT sis.OfferingChildCounter(ParentSectionId,LastAllocated) VALUES(@parent,0)",tx);
                    Add(seed,"@parent",SqlDbType.Int,parent); await seed.ExecuteNonQueryAsync(ct);
                    await using var aq=Cmd(c,"UPDATE sis.OfferingChildCounter SET LastAllocated=LastAllocated+1 OUTPUT INSERTED.LastAllocated WHERE ParentSectionId=@parent",tx);
                    Add(aq,"@parent",SqlDbType.Int,parent); next=Convert.ToInt32(await aq.ExecuteScalarAsync(ct));
                }
                code=$"{prefix}-{next}";
                if(code.Length>50) throw new OfferingException(409,"code_too_long","كود الشعبة الناتج أطول من 50 حرفاً.");
                if(await ScalarInt(c,tx,"SELECT COUNT(*) FROM Offering.Section WITH (UPDLOCK,HOLDLOCK) WHERE SemesterId=@term AND SectionCode=@code",ct,P("@term",w.term),("@code",SqlDbType.NVarChar,code))==0) break;
                if(attempt==99) throw new OfferingException(409,"code_exhausted","تعذر توليد كود شعبة فريد.");
            }
            int saved;
            await using(var iq=Cmd(c,"INSERT Offering.Section(SectionName,SectionCode,ParentId,Capacity,SectionTypeId,CourseId,SemesterId,DepartmentId,IsActive) OUTPUT INSERTED.SectionId VALUES(@name,@code,@parent,@capacity,@type,@course,@term,@dept,1)",tx)) {
                Add(iq,"@name",SqlDbType.NVarChar,input.SectionTypeId==1?code:null,50); Add(iq,"@code",SqlDbType.NVarChar,code,50);
                Add(iq,"@parent",SqlDbType.Int,parent); Add(iq,"@capacity",SqlDbType.Int,input.Capacity);
                Add(iq,"@type",SqlDbType.Int,input.SectionTypeId); Add(iq,"@course",SqlDbType.Int,course); Add(iq,"@term",SqlDbType.Int,w.term);
                Add(iq,"@dept",SqlDbType.Int,input.SectionTypeId==1?dept:null);
                saved=Convert.ToInt32(await iq.ExecuteScalarAsync(ct));
            }
            if(input.SectionTypeId==1) {
                await using var self=Cmd(c,"UPDATE Offering.Section SET ParentId=SectionId WHERE SectionId=@id",tx);
                Add(self,"@id",SqlDbType.Int,saved); await self.ExecuteNonQueryAsync(ct);
            }
            var version=await ReadVersion(c,tx,"Offering.Section","SectionId",saved,ct);
            await Audit(c,tx,"Section",saved,"Create",w.tenant,w.actor,null,version,ct);
            await tx.CommitAsync(ct); return new { id=saved,code,version=Convert.ToBase64String(version) };
        } catch { await tx.RollbackAsync(CancellationToken.None); throw; }
    }
    private static async Task CheckDependencies(SqlConnection c,SqlTransaction tx,int id,CancellationToken ct)
    {
        var sql="""
           SELECT (SELECT COUNT(*) FROM dbo.StudentSection WHERE SectionId=@id)
                + (SELECT COUNT(*) FROM Offering.SummerizeScheduale WHERE SectionId=@id)
                + (SELECT COUNT(*) FROM Offering.Scheduale WHERE SectionId=@id)
                + (SELECT COUNT(*) FROM dbo.ScheduleGroupsTerms WHERE SectionId=@id)
                + (SELECT COUNT(*) FROM dbo.CurrentSchedule WHERE SectionId=@id)
                + (SELECT COUNT(*) FROM dbo.MemberPerCourses_asp WHERE SectionId=@id)
                + (SELECT COUNT(*) FROM dbo.AbsentStudents WHERE Sectionid=@id)
                + (SELECT COUNT(*) FROM dbo.Books WHERE SectionId=@id)
                + (SELECT COUNT(*) FROM dbo.StudentUsersSections WHERE SectionId=@id)
                + (SELECT COUNT(*) FROM dbo.UsersSections WHERE SectionId=@id)
                + (SELECT COUNT(*) FROM dbo.astusection WHERE SectionId=@id)
           """;
        if(await ScalarInt(c,tx,sql,ct,P("@id",id))>0)
            throw new OfferingException(409,"section_in_use","الشعبة مرتبطة بتسجيل طلاب أو جدول، ولا يمكن إيقافها.");
    }
    public async Task<object> DeactivateSection(int id,string version,ClaimsPrincipal principal,CancellationToken ct)
    {
        var w=await BeginWrite(principal,ct); await using var c=w.c; await using var tx=w.tx;
        try {
            await using var q=Cmd(c,"SELECT SemesterId,ParentId,IsActive,SisVersion FROM Offering.Section WITH (UPDLOCK,HOLDLOCK) WHERE SectionId=@id",tx);
            Add(q,"@id",SqlDbType.Int,id); await using var r=await q.ExecuteReaderAsync(ct);
            if(!await r.ReadAsync(ct)) throw new OfferingException(404,"section_missing","الشعبة غير موجودة.");
            if(NInt(r,0)!=w.term) throw new OfferingException(409,"historical_read_only","يمكن تعديل فصل الطرح النشط فقط.");
            if(!Enabled(r,2)) throw new OfferingException(409,"already_inactive","الشعبة موقوفة بالفعل.");
            var parent=NInt(r,1); var before=(byte[])r.GetValue(3); Match(version,before); await r.DisposeAsync();
            if(parent==id && await ScalarInt(c,tx,"SELECT COUNT(*) FROM Offering.Section WHERE ParentId=@id AND SectionId<>@id AND ISNULL(IsActive,1)=1",ct,P("@id",id))>0)
                throw new OfferingException(409,"active_children","أوقف الشعب التابعة أولاً.");
            await CheckDependencies(c,tx,id,ct);
            await using var update=Cmd(c,"UPDATE Offering.Section SET IsActive=0 WHERE SectionId=@id AND SisVersion=@version",tx);
            Add(update,"@id",SqlDbType.Int,id); Add(update,"@version",SqlDbType.VarBinary,before,8);
            if(await update.ExecuteNonQueryAsync(ct)!=1) throw new OfferingException(409,"version_conflict","تغيرت الشعبة منذ فتحها.");
            var after=await ReadVersion(c,tx,"Offering.Section","SectionId",id,ct);
            await Audit(c,tx,"Section",id,"Deactivate",w.tenant,w.actor,before,after,ct);
            await tx.CommitAsync(ct); return new { id,version=Convert.ToBase64String(after) };
        } catch { await tx.RollbackAsync(CancellationToken.None); throw; }
    }
    public async Task<object> DeactivateOffering(int id,string version,ClaimsPrincipal principal,CancellationToken ct)
    {
        var w=await BeginWrite(principal,ct); await using var c=w.c; await using var tx=w.tx;
        try {
            await using var q=Cmd(c,"SELECT CourseId,SemesterId,DepartmentId,Active,SisVersion FROM Offering.OfferedCourses WITH (UPDLOCK,HOLDLOCK) WHERE Id=@id",tx);
            Add(q,"@id",SqlDbType.Int,id); await using var r=await q.ExecuteReaderAsync(ct);
            if(!await r.ReadAsync(ct)) throw new OfferingException(404,"offering_missing","الطرح غير موجود.");
            var course=NInt(r,0); var dept=NInt(r,2);
            if(NInt(r,1)!=w.term) throw new OfferingException(409,"historical_read_only","يمكن تعديل فصل الطرح النشط فقط.");
            if(!Enabled(r,3)) throw new OfferingException(409,"already_inactive","الطرح موقوف بالفعل.");
            var before=(byte[])r.GetValue(4); Match(version,before); await r.DisposeAsync();
            var sections=new List<int>();
            await using(var sq=Cmd(c,"SELECT SectionId FROM Offering.Section WITH (UPDLOCK,HOLDLOCK) WHERE CourseId=@course AND SemesterId=@term AND (DepartmentId=@dept OR ParentId IN (SELECT SectionId FROM Offering.Section WHERE CourseId=@course AND SemesterId=@term AND DepartmentId=@dept))",tx)) {
                Add(sq,"@course",SqlDbType.Int,course); Add(sq,"@term",SqlDbType.Int,w.term); Add(sq,"@dept",SqlDbType.Int,dept);
                await using var sr=await sq.ExecuteReaderAsync(ct); while(await sr.ReadAsync(ct)) sections.Add(sr.GetInt32(0));
            }
            if(sections.Count>0) {
                if(await ScalarInt(c,tx,"SELECT COUNT(*) FROM Offering.Section WHERE CourseId=@course AND SemesterId=@term AND (DepartmentId=@dept OR ParentId IN (SELECT SectionId FROM Offering.Section WHERE CourseId=@course AND SemesterId=@term AND DepartmentId=@dept)) AND ISNULL(IsActive,1)=1",ct,P("@course",course),P("@term",w.term),P("@dept",dept))>0)
                    throw new OfferingException(409,"active_sections","أوقف الشعب النشطة أولاً.");
                foreach(var section in sections) await CheckDependencies(c,tx,section,ct);
            }
            await using var update=Cmd(c,"UPDATE Offering.OfferedCourses SET Active=0 WHERE Id=@id AND SisVersion=@version",tx);
            Add(update,"@id",SqlDbType.Int,id); Add(update,"@version",SqlDbType.VarBinary,before,8);
            if(await update.ExecuteNonQueryAsync(ct)!=1) throw new OfferingException(409,"version_conflict","تغير الطرح منذ فتحه.");
            var after=await ReadVersion(c,tx,"Offering.OfferedCourses","Id",id,ct);
            await Audit(c,tx,"Offering",id,"Deactivate",w.tenant,w.actor,before,after,ct);
            await tx.CommitAsync(ct); return new { id,version=Convert.ToBase64String(after) };
        } catch { await tx.RollbackAsync(CancellationToken.None); throw; }
    }
}
