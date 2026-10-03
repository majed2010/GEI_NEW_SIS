using Gei.Sis.Api.Admissions;
using Microsoft.Extensions.Configuration;

// Read-only smoke test. Never calls AdmissionsWriter or writes application data.
var configuration = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
{
    ["ConnectionStrings:TeiDB"] = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=TeiDB;Integrated Security=True;Encrypt=False;Application Name=GEI SIS Admissions Read Smoke",
    ["Admissions:WritesEnabled"] = "true"
}).Build();
var repository = new AdmissionsRepository(configuration);
var context = await repository.GetContextAsync(CancellationToken.None);
Console.WriteLine($"Context: year={context.AdmissionYearId}, semester={context.AdmissionsSemesterId?.ToString() ?? "unset"}, canWrite={context.CanWrite}, canCreate={context.CanCreate}");
var lookups = await repository.GetLookupsAsync(CancellationToken.None);
Console.WriteLine($"Lookups: {lookups.Count} lists, all read successfully");
var result = await repository.SearchAsync(new SearchStudentsRequest(null, null, null, null, null, null, PageSize: 1), CancellationToken.None);
Console.WriteLine($"Search: total={result.Total}, returned={result.Items.Count}");
if (result.Items.Count > 0)
{
    var detail = await repository.GetByIdAsync(result.Items[0].StudentId, CancellationToken.None);
    if (detail is null) throw new Exception("Search result could not be opened.");
    Console.WriteLine($"Detail: loaded, related sections={detail.Metadata.Count}");
}
Console.WriteLine("Admissions repository read smoke passed.");
