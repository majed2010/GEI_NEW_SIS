using System.Security.Claims;
using Microsoft.AspNetCore.Mvc;

namespace Gei.Sis.Api.Admissions;

public static class AdmissionsEndpoints
{
    public static IEndpointRouteBuilder MapAdmissions(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/api/admissions").RequireAuthorization("Staff");
        group.MapGet("/context", async (AdmissionsRepository repository, CancellationToken ct) =>
            await Execute(() => repository.GetContextAsync(ct)));
        group.MapGet("/lookups", async (AdmissionsRepository repository, CancellationToken ct) =>
            await Execute(() => repository.GetLookupsAsync(ct)));
        group.MapPost("/students/search", async (SearchStudentsRequest request, ClaimsPrincipal principal, AdmissionsRepository repository, CancellationToken ct) =>
            request.Archived && !principal.IsInRole("Admissions.Supervisor")
                ? Results.Forbid() : await Execute(() => repository.SearchAsync(request, ct)));
        group.MapGet("/students/{id:int}", async (int id, ClaimsPrincipal principal, AdmissionsRepository repository, CancellationToken ct) =>
        {
            try
            {
                var student = await repository.GetByIdAsync(id, ct);
                return student is null ? Results.NotFound(new { code = "student_missing", message = "الطالب غير موجود." }) :
                    student.Archived && !principal.IsInRole("Admissions.Supervisor") ? Results.Forbid() : Results.Ok(student);
            }
            catch (AdmissionsException e) { return Failure(e); }
        });
        group.MapGet("/students/{id:int}/photo", async (int id, ClaimsPrincipal principal, AdmissionsPhotos photos, CancellationToken ct) =>
        {
            try
            {
                var photo = await photos.ReadAsync(id, principal, ct);
                return photo is null ? Results.NoContent() : Results.File(photo.Value.data, photo.Value.contentType);
            }
            catch (AdmissionsException e) { return Failure(e); }
        });
        group.MapPut("/students/{id:int}/photo", async (int id, HttpRequest request,
            [FromHeader(Name = "If-Match")] string? version, ClaimsPrincipal principal, AdmissionsPhotos photos, CancellationToken ct) =>
            await Execute(() => photos.SaveAsync(id, version, request.Body, request.ContentType, request.ContentLength, principal, ct)));
        group.MapPost("/students", async (StudentInput student, [FromHeader(Name = "Idempotency-Key")] string? key,
            ClaimsPrincipal principal, AdmissionsWriter writer, CancellationToken ct) =>
        {
            try
            {
                if (!Guid.TryParse(key, out var requestKey))
                    return Results.BadRequest(new { code = "idempotency_key_required", message = "أعد المحاولة بمفتاح طلب صحيح." });
                var result = await writer.CreateAsync(student, requestKey, principal, ct);
                return Results.Created($"/api/admissions/students/{result.StudentId}", result);
            }
            catch (AdmissionsException e) { return Failure(e); }
        });
        group.MapPut("/students/{id:int}", async (int id, StudentInput student, [FromHeader(Name = "If-Match")] string? version,
            ClaimsPrincipal principal, AdmissionsWriter writer, CancellationToken ct) =>
            await Execute(() => writer.UpdateAsync(id, student, version, principal, ct)));
        group.MapPost("/students/{id:int}/archive", async (int id, ArchiveCommand request,
            ClaimsPrincipal principal, AdmissionsWriter writer, CancellationToken ct) =>
        {
            try { await writer.ArchiveAsync(id, request, false, principal, ct); return Results.NoContent(); }
            catch (AdmissionsException e) { return Failure(e); }
        }).RequireAuthorization("AdmissionsSupervisor");
        group.MapPost("/students/{id:int}/restore", async (int id, ArchiveCommand request,
            ClaimsPrincipal principal, AdmissionsWriter writer, CancellationToken ct) =>
        {
            try { await writer.ArchiveAsync(id, request, true, principal, ct); return Results.NoContent(); }
            catch (AdmissionsException e) { return Failure(e); }
        }).RequireAuthorization("AdmissionsSupervisor");
        return app;
    }
    private static async Task<IResult> Execute<T>(Func<Task<T>> action)
    {
        try { return Results.Ok(await action()); }
        catch (AdmissionsException e) { return Failure(e); }
    }
    private static IResult Failure(AdmissionsException e) => Results.Json(new { code = e.Code, message = e.Message, errors = e.FieldErrors }, statusCode: e.StatusCode);
}
