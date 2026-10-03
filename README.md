# GEI Student Information System

Arabic-first, right-to-left staff SIS foundation using Angular 21 and ASP.NET Core 10. Branding uses the original GEI logo and the institute website's blue (`#215381`), with navy and red accents from the logo.

## Run locally

Prerequisites: Node.js 24 (24.14+ for Angular 21), npm, and .NET SDK 10.

```powershell
# Terminal 1, repository root
dotnet run --project backend/Gei.Sis.Api

# Terminal 2
cd frontend
npm ci
npm start
```

Open **http://localhost:4200/**. Select **استكشف النظام** to open the preview workspace. The API runs at http://localhost:5100; Angular proxies `/api` to it.

This workspace also includes an ignored portable Node runtime under `.tools` because Node was not installed. Run `./scripts/start-frontend.ps1` to use it, or normal npm commands with an installed Node runtime.

## Included

- Branded Arabic login page and responsive RTL staff landing page.
- Admissions search, add/edit, student detail, photo, print, and supervisor archive/restore in the authenticated workspace; registrar, courses and curricula navigation remains foundational.
- Offering search, historical-term browsing, data-quality review, course offerings, generated lecture/child sections, capacity editing and administrator deactivation. See [Offering operations](docs/OFFERING-OPERATIONS.md) for roles and database cutover details.
- Search, request filters, academic-year selection, sample request details and help/notification dialogs.
- MSAL authorization-code flow with PKCE, session storage and single-tenant configuration.
- API token validation using Microsoft.Identity.Web; staff authorization requires both the delegated `access_as_user` scope and API app role `SIS.Staff`.
- Local logo and Cairo font files; no external font requests at runtime.

Preview routes are `/preview` and `/preview/:module`. They use explicitly fictional, local display data and never call protected APIs. Real staff routes are `/workspace` and `/workspace/:module`; the guard verifies permission against `/api/me`. Changing client-side preview flags does not bypass API authorization.

Admissions and Offering read the existing TeiDB through protected API endpoints. Registrar, courses and curricula remain foundations, and the authenticated dashboard still has empty states. No student portal is included. See [admissions implementation status](docs/ADMISSIONS-IMPLEMENTATION-STATUS.md) and [Offering operations](docs/OFFERING-OPERATIONS.md).

## Microsoft 365 setup

Follow [the complete step-by-step Entra guide](docs/MICROSOFT-SSO-SETUP.md). Do not put a client secret in the Angular application. No secret is needed for this SPA + protected API design.

For ongoing staff onboarding, app-role assignment, access removal, and troubleshooting, use the [authentication and authorization runbook](docs/SIS-AUTHENTICATION-AUTHORIZATION-RUNBOOK.md).

Frontend public configuration: `frontend/public/app-config.json`.
API local configuration: copy `backend/Gei.Sis.Api/appsettings.Local.example.json` to `appsettings.Local.json`, which is gitignored, and supply identifiers. Alternatively set `AzureAd__TenantId` and `AzureAd__ClientId` through the deployment environment.

Without Entra configuration, Development exposes `/api/health` and responds with HTTP 503 for other API routes. Production refuses to start without valid tenant/client GUIDs. Once configured, protected routes require a valid token and staff permission. The API never accepts preview credentials.

## Build and checks

```powershell
cd frontend
npm run build
npm run typecheck
cd ..
dotnet build backend/Gei.Sis.Api
dotnet run --project scripts/AdmissionsReadSmoke # read-only; run as the LocalDB owner
dotnet build scripts/OfferingSmoke/OfferingSmoke.csproj -o .tools/offering-smoke -p:UseAppHost=false
dotnet .tools/offering-smoke/OfferingSmoke.dll # read-only live checks and write rejection guards
dotnet .tools/offering-smoke/OfferingSmoke.dll --write # isolated temporary LocalDB write smoke
# With the unconfigured development API running:
./scripts/check-api.ps1
```

Production frontend files are generated under `frontend/dist/sis/browser`. Serve them with SPA fallback to `index.html`. Proxy `/api` to the ASP.NET service on the same origin. Set the public `redirectUri` to the exact registered HTTPS root URL and set `enablePreview` to `false`. Configure the API's `AllowedHosts`, HTTPS termination and trusted forwarded headers for the hosting environment. Do not deploy the Angular development server.

## Next phase inputs

1. SSO identifiers and a designated test staff account with `SIS.Staff` assignment.
2. Database engine/version, schema or sanitized structure export, existing keys and relationships. Do not send production credentials through chat.
3. Admissions and registration workflow rules, existing status codes, required documents and permission matrix.
4. Curriculum regulations, semester structure, prerequisites and academic program rules.
5. Hosting/domain, production support contact and approved academic calendar.

See [asset sources](docs/ASSETS.md) for branding and font attribution.
