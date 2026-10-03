# Microsoft 365 staff SSO — administrator setup

This application uses your Microsoft 365 organization's Microsoft Entra ID tenant. Staff sign in with their existing organizational accounts. The browser uses authorization code flow with PKCE; the ASP.NET API validates access tokens. **Neither app needs a client secret for this flow.**

You need an Entra administrator who can register applications, grant tenant consent and assign staff. If a menu/action is unavailable, ask the Microsoft 365 administrator to perform it. Do not create a new tenant or enable external/customer identities for this project.

## 1. Copy the tenant ID

1. Open https://entra.microsoft.com and sign in to the institute's organization.
2. Open **Entra ID → Overview** (some portal versions call this **Identity → Overview**).
3. Copy the **Tenant ID** / **Directory (tenant) ID**, a GUID.
4. Confirm you are in the institute's tenant, not a personal or unrelated organization.

## 2. Register the Angular frontend

1. Open **Entra ID → App registrations → New registration**.
2. Name: **GEI SIS Web**.
3. Supported account types: **Accounts in this organizational directory only (Single tenant)**.
4. Redirect URI platform: **Single-page application (SPA)**.
5. Development redirect URI: **`http://localhost:4200/`**. Keep the trailing slash. Use this hostname in your browser; `127.0.0.1` is a different redirect origin.
6. Select **Register**.
7. On **Overview**, copy the **Application (client) ID**. Label it **Web client ID**.
8. Under **Authentication**, confirm the redirect is under **Single-page application**, not Web. Leave implicit access-token/ID-token checkboxes disabled. Do not create a secret or enable public-client/password flows.

## 3. Register the API

1. Create another app registration, **GEI SIS API**.
2. Choose the same **single-tenant** account option.
3. Leave the redirect URI empty; this API does not perform browser login.
4. Register and copy its **Application (client) ID**. Label it **API client ID**.
5. Under **Manifest**, find `api.requestedAccessTokenVersion` and set it to **2**, then save. This is the requested **access-token** version, not an ID-token setting. Edit only this property.

## 4. Expose the delegated API scope

In **GEI SIS API → Expose an API**:

1. Set **Application ID URI** to `api://<API-client-ID>` (replace the placeholder with the actual API client ID).
2. Choose **Add a scope**.
3. Scope name: **`access_as_user`** (exactly this spelling).
4. Who can consent: **Admins only**.
5. Admin consent display name: **Access GEI SIS as the signed-in staff member**.
6. Admin consent description: **Allows the GEI SIS web application to access the SIS API on behalf of assigned staff.**
7. State: **Enabled**; save.
8. Copy the full scope: **`api://<API-client-ID>/access_as_user`**.

## 5. Define the API staff role

In **GEI SIS API → App roles → Create app role**:

| Field | Value |
|---|---|
| Display name | SIS Staff |
| Allowed member types | Users/Groups |
| Value | `SIS.Staff` |
| Description | Staff authorized to access the GEI SIS API |
| Enabled | Yes |

The role is defined on the **API**, not just on the web application. The API checks the role in its own access token. More granular admissions/registrar/curriculum permissions will be designed with your existing staff and database model later.

## 6. Give the web application permission to call the API

1. Open **GEI SIS Web → API permissions → Add a permission**.
2. Choose **My APIs** (or **APIs my organization uses**) and find **GEI SIS API**.
3. Choose **Delegated permissions → access_as_user → Add permissions**.
4. Select **Grant admin consent for [your organization]** using an authorized administrator account.
5. Confirm the permission shows consent granted.

This initial application does not call Microsoft Graph; additional Graph permissions are unnecessary.

## 7. Assign staff access

1. Go to **Entra ID → Enterprise applications → GEI SIS API → Users and groups**.
2. **Add user/group**; choose a test staff user or your staff security group.
3. Select the **SIS Staff** role and assign it.
4. Open **Enterprise applications → GEI SIS Web → Properties**, set **Assignment required? → Yes**, and save.
5. In **GEI SIS Web → Users and groups**, assign the same staff users/groups. If the web app has no custom role, use its default access assignment.
6. Group-based enterprise application assignment depends on your Entra licensing. If unavailable, assign individual staff users initially.

Assigning a user only to the web enterprise app is insufficient: they also need the API's `SIS.Staff` role. Keep students unassigned. Apply your existing staff MFA and Conditional Access policies.

## 8. Send these configuration values

```text
Tenant ID:
GEI SIS Web application (client) ID:
GEI SIS API application (client) ID:
Full delegated scope: api://.../access_as_user
Planned SIS website URL (if known):
Staff user/group assigned for testing (name only; no password):
```

These identifiers are configuration values, not passwords. **Do not send passwords, MFA codes, client secrets, access tokens or production database credentials.**

## 9. Apply the values to this project

Frontend `frontend/public/app-config.json`:

```json
{
  "tenantId": "YOUR-TENANT-ID",
  "clientId": "YOUR-WEB-CLIENT-ID",
  "apiScope": "api://YOUR-API-CLIENT-ID/access_as_user",
  "redirectUri": "http://localhost:4200/",
  "apiBaseUrl": "/api",
  "enablePreview": true
}
```

Backend `backend/Gei.Sis.Api/appsettings.Local.json`:

```json
{
  "AzureAd": {
    "Instance": "https://login.microsoftonline.com/",
    "TenantId": "YOUR-TENANT-ID",
    "ClientId": "YOUR-API-CLIENT-ID"
  }
}
```

Restart the API and frontend. Use **http://localhost:4200/** and choose Microsoft 365 sign-in. An assigned staff account should enter `/workspace`. A valid account without the API staff role should be denied by the API. Test sign-out, refresh and MFA with the administrator. Live tenant behavior cannot be validated before these registrations and assignments exist.

## 10. Before deployment

- Decide the actual SIS hostname, for example `https://sis.gei.edu.eg/` **only if your institute approves and provisions that name**.
- Add that exact HTTPS URL as a SPA redirect URI on **GEI SIS Web**. Configure the same `redirectUri` in the frontend.
- Set `enablePreview` to `false` in the deployed configuration.
- Configure SPA route fallback, same-origin `/api` proxy, API allowed hosts, trusted proxy headers, HTTPS and certificate management for the chosen host.
- Validate an allowed staff account and a denied non-staff account. Confirm missing/invalid tokens return 401 and missing staff role/scope returns 403.
- Connect the database only after schema and workflow review.

## Troubleshooting

| Symptom | Check |
|---|---|
| AADSTS50011 | The redirect URI, scheme, port and trailing slash must match the SPA registration. |
| Assignment-required error | Assign the user to the Web enterprise application. |
| API 403 | Assign `SIS.Staff` on the API enterprise app and verify `access_as_user` consent. Sign out/in after assignment changes. |
| API 401 | Tenant, API client ID/audience, requested token version, issuer and token expiry. Do not paste tokens into chat. |
| API 503 | Backend tenant/client settings are missing in Development. |
| Microsoft sign-in not configured | Fill the frontend tenant ID, Web client ID and API scope. |

Official references: [SPA configuration](https://learn.microsoft.com/en-us/entra/identity-platform/scenario-spa-app-configuration), [API scope and role verification](https://learn.microsoft.com/en-us/entra/identity-platform/scenario-protected-web-api-verification-scope-app-roles), [application roles](https://learn.microsoft.com/en-us/entra/identity-platform/howto-add-app-roles-in-apps), [manifest access-token version](https://learn.microsoft.com/en-us/entra/identity-platform/reference-app-manifest).
