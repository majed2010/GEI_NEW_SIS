using Gei.Sis.Api.Offering;
using Microsoft.Extensions.Configuration;
using System.Security.Claims;

if (args.Contains("--write")) { await WriteSmoke.Run(); return; }

var configuration = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string,string?> {
    ["ConnectionStrings:TeiDB"] = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=TeiDB;Integrated Security=True;Encrypt=False;Application Name=GEI SIS Offering Smoke",
    ["Offering:WritesEnabled"] = "true"
}).Build();
var service = new OfferingService(configuration);
var context = await service.Context(CancellationToken.None);
if (context.SemesterId != 66 || !context.WritesEnabled) throw new Exception($"Offering context not ready: {context}");
var lookups = await service.Lookups(CancellationToken.None);
var current = await service.Search(new OfferingSearch(null,null,null,"all",null),CancellationToken.None);
var past = await service.Search(new OfferingSearch(68,null,null,"all",null),CancellationToken.None);
var issues = await service.Review(66,CancellationToken.None);
Console.WriteLine($"Context: {context.SemesterId} {context.SemesterName}; support and writes ready");
Console.WriteLine($"Lookups: {lookups}");
Console.WriteLine($"Current: {current}");
Console.WriteLine($"Historical: {past}");
Console.WriteLine($"Review issues: {issues.Count}");
if (current.Total < current.Rows.Count || past.Total < past.Rows.Count || current.Rows.Count == 0 || past.Rows.Count == 0)
    throw new Exception("Unexpected offering search result.");
var detail = await service.Detail(current.Rows[0].Id,CancellationToken.None);
Console.WriteLine($"Detail: {detail.Offering.Id}, {detail.Sections.Count} sections");
var principal = new ClaimsPrincipal(new ClaimsIdentity(new[] {
    new Claim("tid", Guid.NewGuid().ToString()), new Claim("oid", Guid.NewGuid().ToString())
}, "OfferingSmoke"));
async Task Expect(int status, Func<Task> operation)
{
    try { await operation(); throw new Exception($"Expected HTTP {status} guard."); }
    catch (OfferingException e) when (e.Status == status) { Console.WriteLine($"Guard passed: {e.Code}"); }
}
var currentRow = current.Rows[0]; var oldRow = past.Rows[0];
if (currentRow.CourseId is not null && currentRow.DepartmentId is not null)
    await Expect(409, async () => await service.SaveOffering(null,new(currentRow.CourseId.Value,currentRow.DepartmentId.Value,null),principal,CancellationToken.None));
if (oldRow.CourseId is not null && oldRow.DepartmentId is not null)
    await Expect(409, async () => await service.SaveOffering(oldRow.Id,new(oldRow.CourseId.Value,oldRow.DepartmentId.Value,oldRow.Version),principal,CancellationToken.None));
await Expect(400, async () => await service.SaveSection(currentRow.Id,null,new(null,1,0,null),principal,CancellationToken.None));
if (detail.Sections.Any(s=>s.Active) && currentRow.Version is not null)
    await Expect(409, async () => await service.DeactivateOffering(currentRow.Id,currentRow.Version,principal,CancellationToken.None));
Console.WriteLine("Offering read smoke passed.");
