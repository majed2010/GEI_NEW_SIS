using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Identity.Web;
using Gei.Sis.Api.Admissions;
using Gei.Sis.Api.Offering;

var builder = WebApplication.CreateBuilder(args);
builder.Configuration.AddJsonFile("appsettings.Local.json", optional: true, reloadOnChange: false).AddEnvironmentVariables();
var tenant = builder.Configuration["AzureAd:TenantId"];
var client = builder.Configuration["AzureAd:ClientId"];
var configured = Guid.TryParse(tenant, out _) && Guid.TryParse(client, out _);
if (!configured && !builder.Environment.IsDevelopment())
    throw new InvalidOperationException("Set AzureAd:TenantId and AzureAd:ClientId before running outside Development.");

builder.Services.AddProblemDetails();
builder.Services.AddScoped<AdmissionsRepository>();
builder.Services.AddScoped<AdmissionsWriter>();
builder.Services.AddScoped<AdmissionsPhotos>();
builder.Services.AddScoped<OfferingService>();
if (configured)
    builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
        .AddMicrosoftIdentityWebApi(builder.Configuration.GetSection("AzureAd"));
else
    builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme).AddJwtBearer();

builder.Services.AddAuthorization(options =>
{
    options.AddPolicy("Staff", policy => policy
        .RequireAuthenticatedUser().RequireRole("SIS.Staff")
        .RequireAssertion(context => context.User.Claims.Any(c =>
            (c.Type == "scp" || c.Type == "http://schemas.microsoft.com/identity/claims/scope") &&
            c.Value.Split(' ').Contains("access_as_user"))));
    options.AddPolicy("AdmissionsSupervisor", policy => policy
        .RequireAuthenticatedUser().RequireRole("SIS.Staff", "Admissions.Supervisor")
        .RequireAssertion(context => context.User.IsInRole("Admissions.Supervisor") &&
            context.User.Claims.Any(c => (c.Type == "scp" || c.Type == "http://schemas.microsoft.com/identity/claims/scope") &&
                c.Value.Split(' ').Contains("access_as_user"))));
    options.AddPolicy("OfferingManager", policy => policy.RequireAuthenticatedUser()
        .RequireRole("SIS.Staff")
        .RequireAssertion(context => (context.User.IsInRole("Offering.Manager") || context.User.IsInRole("Offering.Administrator")) &&
            context.User.Claims.Any(c => (c.Type == "scp" || c.Type == "http://schemas.microsoft.com/identity/claims/scope") && c.Value.Split(' ').Contains("access_as_user"))));
    options.AddPolicy("OfferingAdministrator", policy => policy.RequireAuthenticatedUser()
        .RequireRole("SIS.Staff", "Offering.Administrator")
        .RequireAssertion(context => context.User.IsInRole("Offering.Administrator") &&
            context.User.Claims.Any(c => (c.Type == "scp" || c.Type == "http://schemas.microsoft.com/identity/claims/scope") && c.Value.Split(' ').Contains("access_as_user"))));
});

var app = builder.Build();
app.UseExceptionHandler();
if (!app.Environment.IsDevelopment()) { app.UseHsts(); app.UseHttpsRedirection(); }
app.Use(async (context, next) =>
{
    context.Response.Headers["X-Content-Type-Options"] = "nosniff";
    context.Response.Headers["Referrer-Policy"] = "strict-origin-when-cross-origin";
    if (context.Request.Path.StartsWithSegments("/api")) context.Response.Headers.CacheControl = "no-store";
    if (!configured && context.Request.Path.StartsWithSegments("/api") && context.Request.Path != "/api/health")
    {
        await Results.Problem(statusCode: 503, title: "Staff SSO has not been configured.").ExecuteAsync(context);
        return;
    }
    await next(context);
});
app.UseAuthentication();
app.UseAuthorization();
app.MapGet("/api/health", () => Results.Ok(new { status = "ok", service = "GEI SIS API" })).AllowAnonymous();
app.MapGet("/api/me", (System.Security.Claims.ClaimsPrincipal user) => Results.Ok(new {
    name = user.FindFirst("name")?.Value ?? user.Identity?.Name,
    objectId = user.GetObjectId(),
    roles = user.FindAll(System.Security.Claims.ClaimTypes.Role).Select(c => c.Value)
})).RequireAuthorization("Staff");
app.MapAdmissions();
app.MapOffering();
app.Run();
