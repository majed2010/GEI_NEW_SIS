using System.Security.Claims;
using Gei.Sis.Api.Offering;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;

internal static class WriteSmoke
{
    private static async Task Execute(SqlConnection connection, string sql)
    {
        await using var command = connection.CreateCommand(); command.CommandText = sql; command.CommandTimeout = 60;
        await command.ExecuteNonQueryAsync();
    }
    private static int Id(object result) => Convert.ToInt32(result.GetType().GetProperty("id")!.GetValue(result));
    private static async Task Expect(int status, Func<Task> action)
    {
        try { await action(); throw new Exception($"Expected HTTP {status} guard."); }
        catch (OfferingException e) when (e.Status == status) { Console.WriteLine($"Guard passed: {e.Code}"); }
    }
    public static async Task Run()
    {
        var name = "GeiOfferingSmoke_" + Guid.NewGuid().ToString("N");
        var root = Path.GetFullPath(Path.Combine(Directory.GetCurrentDirectory(), ".tools"));
        Directory.CreateDirectory(root);
        var data = Path.Combine(root, name + ".mdf"); var log = Path.Combine(root, name + ".ldf");
        var master = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=master;Integrated Security=True;Encrypt=False;Connect Timeout=30;Application Name=GEI SIS Offering Isolated Smoke";
        await using var admin = new SqlConnection(master); await admin.OpenAsync();
        try
        {
            await Execute(admin, $"CREATE DATABASE [{name}] ON PRIMARY (NAME=N'{name}_data',FILENAME=N'{data.Replace("'", "''")}') LOG ON (NAME=N'{name}_log',FILENAME=N'{log.Replace("'", "''")}')");
            var connection = $"Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog={name};Integrated Security=True;Encrypt=False;Application Name=GEI SIS Offering Isolated Smoke";
            await using (var c = new SqlConnection(connection))
            {
                await c.OpenAsync();
                await Execute(c, "CREATE SCHEMA Offering AUTHORIZATION dbo");
                await Execute(c, "CREATE SCHEMA sis AUTHORIZATION dbo");
                await Execute(c, """
                    CREATE TABLE dbo.ActiveSemesters(Id int NOT NULL PRIMARY KEY,OfferingSemester int NULL);
                    CREATE TABLE dbo.Semesters(SemesterId int NOT NULL PRIMARY KEY,ArSemesterName nvarchar(100),Hide bit);
                    CREATE TABLE dbo.Courses(CourseId int NOT NULL PRIMARY KEY,ArCourseName nvarchar(100),ArCourseCode nvarchar(50),CourseCode varchar(50),Hide bit);
                    CREATE TABLE dbo.Departments(DepartmentId int NOT NULL PRIMARY KEY,ArDepartmentName nvarchar(100),Hide bit);
                    CREATE TABLE dbo.StudentSection(SectionId int); CREATE TABLE dbo.ScheduleGroupsTerms(SectionId int);
                    CREATE TABLE dbo.CurrentSchedule(SectionId int); CREATE TABLE dbo.MemberPerCourses_asp(SectionId int);
                    CREATE TABLE dbo.AbsentStudents(Sectionid int); CREATE TABLE dbo.Books(SectionId int);
                    CREATE TABLE dbo.StudentUsersSections(SectionId int); CREATE TABLE dbo.UsersSections(SectionId int);
                    CREATE TABLE dbo.astusection(SectionId int);
                    CREATE TABLE Offering.SectionType(SectionTypeid int NOT NULL PRIMARY KEY,SectionTypeName nvarchar(50));
                    CREATE TABLE Offering.OfferedCourses(Id int IDENTITY(1,1) NOT NULL PRIMARY KEY,CourseId int,SemesterId int,DepartmentId int,AddedDate datetime,Active bit,SisVersion rowversion NOT NULL);
                    CREATE INDEX IX_SmokeOfferingKey ON Offering.OfferedCourses(SemesterId,DepartmentId,CourseId);
                    CREATE TABLE Offering.Section(SectionId int IDENTITY(1,1) NOT NULL PRIMARY KEY,SectionName nvarchar(50),SectionCode nvarchar(50),ParentId int,Capacity int,ReservedCapacity int DEFAULT 0,SectionTypeId int,CourseId int,SemesterId int,DepartmentId int,IsActive bit,ScheduleCapacity int,SisVersion rowversion NOT NULL);
                    CREATE TABLE Offering.SummerizeScheduale(SectionId int); CREATE TABLE Offering.Scheduale(SectionId int);
                    CREATE TABLE sis.OfferingLectureCounter(Prefix nvarchar(50) NOT NULL PRIMARY KEY,LastAllocated int NOT NULL);
                    CREATE TABLE sis.OfferingChildCounter(ParentSectionId int NOT NULL PRIMARY KEY,LastAllocated int NOT NULL);
                    CREATE TABLE sis.OfferingAudit(AuditId bigint IDENTITY(1,1) NOT NULL PRIMARY KEY,EntityType varchar(20),EntityId int,ActionName varchar(20),OccurredAtUtc datetime2 DEFAULT SYSUTCDATETIME(),ActorTenantId uniqueidentifier,ActorObjectId uniqueidentifier,PreviousVersion varbinary(8),NewVersion varbinary(8));
                    INSERT dbo.ActiveSemesters VALUES(1,66);
                    INSERT dbo.Semesters VALUES(66,N'الفصل الدراسي الأول',0),(68,N'الفصل الدراسي الثاني',0);
                    INSERT dbo.Courses VALUES(1,N'اختبار هندسة',N'همد 407','ENG407',0),(2,N'اختبار رياضيات',N'ريض 101','MTH101',0);
                    INSERT dbo.Departments VALUES(1,N'الهندسة المدنية',0),(2,N'هندسة الاتصالات',0);
                    INSERT Offering.SectionType VALUES(1,N'محاضرة'),(2,N'عملي'),(3,N'سكشن'),(25,N'تمارين');
                    """);
            }
            var configuration = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string,string?> {
                ["ConnectionStrings:TeiDB"] = connection, ["Offering:WritesEnabled"] = "true"
            }).Build();
            var service = new OfferingService(configuration);
            var actor = new ClaimsPrincipal(new ClaimsIdentity(new[] { new Claim("tid",Guid.NewGuid().ToString()), new Claim("oid",Guid.NewGuid().ToString()) },"Smoke"));
            var offeringId = Id(await service.SaveOffering(null,new OfferingInput(1,1,null),actor,CancellationToken.None));
            await Expect(409, async () => await service.SaveOffering(null,new OfferingInput(1,1,null),actor,CancellationToken.None));
            var lectureId = Id(await service.SaveSection(offeringId,null,new SectionInput(null,1,40,null),actor,CancellationToken.None));
            var childId = Id(await service.SaveSection(offeringId,null,new SectionInput(lectureId,3,30,null),actor,CancellationToken.None));
            var detail = await service.Detail(offeringId,CancellationToken.None);
            var lecture = detail.Sections.Single(s=>s.Id==lectureId); var child=detail.Sections.Single(s=>s.Id==childId);
            if (lecture.Code != "همد 407-1" || child.Code != "همد 407-1-1" || child.ParentId != lectureId)
                throw new Exception($"Unexpected generated codes/parent: {lecture.Code}, {child.Code}, {child.ParentId}");
            var crossDepartmentId = Id(await service.SaveOffering(null,new OfferingInput(1,2,null),actor,CancellationToken.None));
            var crossDepartment = await service.Detail(crossDepartmentId,CancellationToken.None);
            await service.SaveOffering(crossDepartmentId,new OfferingInput(2,2,crossDepartment.Offering.Version),actor,CancellationToken.None);
            if((await service.Detail(crossDepartmentId,CancellationToken.None)).Offering.CourseId!=2)
                throw new Exception("Changing an unused cross-department offering failed.");
            await service.SaveSection(null,lectureId,new SectionInput(null,1,50,lecture.Version),actor,CancellationToken.None);
            await Expect(409, async () => await service.SaveSection(null,lectureId,new SectionInput(null,1,55,lecture.Version),actor,CancellationToken.None));
            detail=await service.Detail(offeringId,CancellationToken.None);
            await Expect(409, async () => await service.DeactivateOffering(offeringId,detail.Offering.Version!,actor,CancellationToken.None));
            await Expect(409, async () => await service.DeactivateSection(lectureId,detail.Sections.Single(s=>s.Id==lectureId).Version!,actor,CancellationToken.None));
            await service.DeactivateSection(childId,detail.Sections.Single(s=>s.Id==childId).Version!,actor,CancellationToken.None);
            detail=await service.Detail(offeringId,CancellationToken.None);
            await service.DeactivateSection(lectureId,detail.Sections.Single(s=>s.Id==lectureId).Version!,actor,CancellationToken.None);
            detail=await service.Detail(offeringId,CancellationToken.None);
            await service.DeactivateOffering(offeringId,detail.Offering.Version!,actor,CancellationToken.None);
            var secondOffering = Id(await service.SaveOffering(null,new OfferingInput(2,1,null),actor,CancellationToken.None));
            var parallel = await Task.WhenAll(
                service.SaveSection(secondOffering,null,new SectionInput(null,1,35,null),actor,CancellationToken.None),
                service.SaveSection(secondOffering,null,new SectionInput(null,1,35,null),actor,CancellationToken.None));
            if(parallel.Select(Id).Distinct().Count()!=2) throw new Exception("Parallel section IDs collided.");
            var generated = (await service.Detail(secondOffering,CancellationToken.None)).Sections.Select(s=>s.Code).Order().ToArray();
            if(!generated.SequenceEqual(new[]{"ريض 101-1","ريض 101-2"}))
                throw new Exception("Parallel section codes collided or skipped.");
            await using (var c = new SqlConnection(connection))
            {
                await c.OpenAsync(); await using var q=c.CreateCommand();
                q.CommandText="SELECT (SELECT COUNT(*) FROM sis.OfferingAudit),(SELECT ReservedCapacity FROM Offering.Section WHERE SectionId=1),(SELECT COUNT(*) FROM Offering.Section WHERE IsActive=0),(SELECT COUNT(*) FROM Offering.OfferedCourses WHERE Active=0)";
                await using var r=await q.ExecuteReaderAsync(); await r.ReadAsync();
                if(r.GetInt32(0)!=12 || r.GetInt32(1)!=0 || r.GetInt32(2)!=2 || r.GetInt32(3)!=1)
                    throw new Exception("Audit, capacity default or deactivation mismatch.");
            }
            Console.WriteLine("Offering isolated write smoke passed.");
        }
        finally
        {
            SqlConnection.ClearAllPools();
            await Execute(admin,$"IF DB_ID(N'{name}') IS NOT NULL BEGIN ALTER DATABASE [{name}] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE [{name}]; END");
        }
    }
}
