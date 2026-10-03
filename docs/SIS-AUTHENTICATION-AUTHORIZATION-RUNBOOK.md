# GEI SIS authentication and authorization runbook

This guide explains how staff sign in to the current Angular and ASP.NET Core SIS, how an Entra administrator grants or removes access, and how to diagnose common failures. It reflects the repository as of **3 October 2026**. The student portal is outside this project's current scope. Portal labels can move over time; use the application names and IDs below to confirm that you are editing the right objects.

For the original application-registration walkthrough, see [Microsoft 365 staff SSO setup](MICROSOFT-SSO-SETUP.md). For Offering-specific operations, see [Offering operations](OFFERING-OPERATIONS.md).

## 1. The four separate access decisions

| Decision | Where it is configured | What it means in this SIS |
| --- | --- | --- |
| **Authentication** | Microsoft Entra ID | The person signs in to the institute tenant and satisfies its MFA/Conditional Access rules. |
| **Web app assignment** | **GEI SIS Web** enterprise application | If **Assignment required?** is **Yes**, the person must be assigned to the Web app (directly or through an eligible security group) to sign in. `Default Access` is sufficient when the Web app has no custom roles. |
| **Delegated API consent** | **GEI SIS Web** app registration → **API permissions** | An administrator grants the Web app permission to request `access_as_user` tokens for **GEI SIS API**. This is tenant/app permission, not a grant of SIS staff rights to every user. |
| **API authorization** | **GEI SIS API** app roles and ASP.NET Core policies | The user must have `SIS.Staff`; certain actions need another role. The API also requires the `access_as_user` scope in the access token. |

The **app registration** defines the application, its redirect URLs, scopes, and role definitions. The **enterprise application** is the tenant's service principal where users/groups are assigned to those roles. An **Entra directory administrator role** such as Global Administrator is different from an **SIS app role** such as `Offering.Administrator`; normal SIS staff do not need directory administrator rights. Microsoft explains [app roles and their token claims](https://learn.microsoft.com/en-us/entra/identity-platform/howto-add-app-roles-in-apps) and [enterprise-app assignments](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/assign-user-or-group-access-portal).

## 2. Current GEI application identifiers

| Item | Current value | Used by |
| --- | --- | --- |
| Directory (tenant) ID | `4f250331-fa28-4f3a-bc05-6f4a9ab2e6dd` | Both apps |
| GEI SIS Web application (client) ID | `93141cb7-57b1-408d-a1df-49fc187dfb13` | Angular/MSAL |
| GEI SIS API application (client) ID | `78f9de93-d724-4d8b-8a41-f5ddd64b65b4` | API token audience/configuration |
| Delegated scope | `api://78f9de93-d724-4d8b-8a41-f5ddd64b65b4/access_as_user` | Web requests it; API checks `access_as_user` |
| Development SPA redirect | `http://localhost:4200/` | Web app registration and Angular configuration |

These IDs are configuration identifiers, not secrets. Check the **Application (client) ID** in each app registration before changing permissions; the Web and API have separate registrations **and** separate enterprise-app entries. The development values live in [`frontend/public/app-config.json`](../frontend/public/app-config.json). The API reads `AzureAd:TenantId` and `AzureAd:ClientId` from configuration; see the [setup guide](MICROSOFT-SSO-SETUP.md). Never put a client secret, password, MFA code, or access token in Angular configuration, tickets, or chat.

If you later use Microsoft Graph or PowerShell, distinguish these **application/client IDs** from the enterprise applications' **Object IDs** (service-principal IDs) and the individual **app-role IDs**. Graph role-assignment commands need the latter two; copying the API client ID into their `resourceId` field will target the wrong identifier. [Microsoft: app-role assignment fields](https://learn.microsoft.com/en-us/graph/api/resources/approleassignment).

## 3. What happens when a staff member signs in

```mermaid
sequenceDiagram
    participant Staff
    participant Angular as Angular + MSAL
    participant Entra as Microsoft Entra ID
    participant API as ASP.NET Core SIS API
    Staff->>Angular: Choose Microsoft 365 sign-in
    Angular->>Entra: Redirect for authorization-code + PKCE; request access_as_user
    Entra->>Staff: Authenticate, apply MFA/Conditional Access
    Entra-->>Angular: Return sign-in result and API access token
    Angular->>API: GET /api/me with Bearer access token
    API->>API: Validate token, delegated scope, SIS.Staff role
    API-->>Angular: Name and API role values, or 401/403
    Angular->>Staff: Show authorized workspace and permitted actions
```

1. [`AuthService`](../frontend/src/app/auth.service.ts) loads the public configuration and uses MSAL Browser against this single tenant. MSAL uses the browser authorization-code flow with PKCE; the app stores its MSAL cache in `sessionStorage`. See Microsoft's [SPA flow guidance](https://learn.microsoft.com/en-us/entra/identity-platform/v2-oauth2-auth-code-flow).
2. Angular asks for the **API access token** with `access_as_user`. It sends that token as `Authorization: Bearer ...` to `/api/me` and later API requests. [`staffGuard`](../frontend/src/app/auth.service.ts) protects `/workspace` routes. Angular's role-based buttons improve the interface but do **not** grant or enforce security.
3. [`Program.cs`](../backend/Gei.Sis.Api/Program.cs) uses `Microsoft.Identity.Web` to validate the bearer token for the configured API. Its policies inspect the token's delegated `scp` scope and `roles` claim. `scp` answers *what the Web client may do on behalf of this user*; `roles` answers *which SIS roles this user has for the API*. The access token's audience must be the API, not the Web client or Microsoft Graph. See Microsoft's [access-token claims reference](https://learn.microsoft.com/en-us/entra/identity-platform/access-token-claims-reference) and [API token validation guidance](https://learn.microsoft.com/en-us/entra/identity-platform/claims-validation).
4. `/api/me` returns the user's display name, object ID, and SIS API roles after the **Staff** policy succeeds. Check the response in the browser's **Network** tab; do not copy or publish the bearer token itself. Opening `/api/me` directly in a new browser tab does not send Angular's bearer token.

The preview routes use fictional local data and do not call the protected API. A successful preview is not proof of staff authorization.

## 4. Current SIS role matrix

Define these **exact role values** on the **GEI SIS API app registration**, with **Allowed member types = Users/Groups**, then assign users or security groups in the **GEI SIS API enterprise application**. The display name may be friendly; the **Value** must match the code exactly. Microsoft documents [creating and assigning app roles](https://learn.microsoft.com/en-us/entra/identity-platform/howto-add-app-roles-in-apps).

| API app-role value | Intended staff | What it adds |
| --- | --- | --- |
| `SIS.Staff` | Every staff member who may use SIS | Workspace; Admissions and Offering read operations; current Admissions add/edit/photo operations. |
| `Admissions.Supervisor` | Admissions supervisors | Archived-student search/detail plus archive/restore. |
| `Offering.Manager` | Offering managers | Create and edit course offerings and sections. |
| `Offering.Administrator` | Offering administrators | Offering manager actions **and** offering/section deactivation, as implemented by the API. |

**Every protected API call requires `SIS.Staff` and delegated `access_as_user`.** The extra role never replaces `SIS.Staff`. The API code treats `Offering.Administrator` as sufficient for manager actions; Entra itself does not create a role hierarchy. A person doing both Admissions supervision and Offering administration needs `SIS.Staff`, `Admissions.Supervisor`, and `Offering.Administrator` in the API access token.

The current endpoint rules are:

| Action | Required API roles, in addition to `access_as_user` |
| --- | --- |
| `/api/me`, Admissions search/view/add/edit/photo, Offering view/search | `SIS.Staff` |
| Admissions archived records, archive, restore | `SIS.Staff` + `Admissions.Supervisor` |
| Offering and section create/edit | `SIS.Staff` + (`Offering.Manager` **or** `Offering.Administrator`) |
| Offering and section deactivate | `SIS.Staff` + `Offering.Administrator` |

These rules come from [`Program.cs`](../backend/Gei.Sis.Api/Program.cs), [Admissions endpoints](../backend/Gei.Sis.Api/Admissions/AdmissionsEndpoints.cs), and [Offering endpoints](../backend/Gei.Sis.Api/Offering/OfferingEndpoints.cs). The API also has separate `Admissions:WritesEnabled` and `Offering:WritesEnabled` configuration switches. A person with the correct role still cannot write while the relevant switch is off, and Offering writes also depend on the configured active term and database support. A role assignment never bypasses these workflow controls.

## 5. One-time Entra verification before onboarding people

Sign in at [Microsoft Entra admin center](https://entra.microsoft.com/) with an account permitted to manage applications and grant consent. Menu paths below start under **Entra ID**; some portal layouts show **Identity** first. Confirm the directory ID matches the table above.

1. Go to **App registrations → GEI SIS API → Expose an API**. Verify the Application ID URI is `api://78f9de93-d724-4d8b-8a41-f5ddd64b65b4` and the enabled delegated scope is `access_as_user`. [Microsoft: expose an API](https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-configure-app-expose-web-apis).
2. In **App registrations → GEI SIS API → App roles**, verify all four values in the role table exist, are enabled, and allow **Users/Groups**. If one is missing, choose **Create app role**, set a clear display name and description, enter the exact **Value**, and save. Create roles on **API**, because the API access token must contain them. Merely defining a role does not assign it to anyone. [Microsoft: app roles](https://learn.microsoft.com/en-us/entra/identity-platform/howto-add-app-roles-in-apps).
3. Go to **App registrations → GEI SIS Web → Authentication**. Verify the development redirect is under the **Single-page application** platform and exactly matches `http://localhost:4200/`. Add the real HTTPS production redirect here when the SIS site is deployed; set the same value in Angular. Do not switch the SPA to an implicit flow or add a browser client secret. [Microsoft: SPA configuration](https://learn.microsoft.com/en-us/entra/identity-platform/scenario-spa-app-configuration).
4. Go to **App registrations → GEI SIS Web → API permissions**. Verify the API's **Delegated** `access_as_user` permission appears and shows **Granted for GEI.edu.eg** (or the institute tenant's current display name). If it is missing, use **Add a permission → My APIs → GEI SIS API → Delegated permissions → access_as_user**. An authorized admin must review the requested permission and choose **Grant admin consent for [tenant]**. This is the fix for the previously seen **“Need admin approval”** message when `access_as_user` was **Not granted**. Adding the user to a group does not grant tenant consent. [Microsoft: configure API access](https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-configure-app-access-web-apis), [grant admin consent](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/grant-admin-consent).
5. Go to **Enterprise applications → GEI SIS Web → Properties**. Decide and record **Assignment required? = Yes** for staff-only Web entry, then use **Users and groups** to assign allowed staff. If **Yes**, an unassigned user can be stopped before reaching the API. For the Web app without custom Web roles, **Default Access** is enough; it does not add `SIS.Staff`. [Microsoft: application properties](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/application-properties), [assignment troubleshooting](https://learn.microsoft.com/en-us/troubleshoot/entra/entra-id/app-integration/error-code-aadsts50105-user-not-assigned-role).

The API enterprise application's own **Assignment required?** setting is a separate control. The current ASP.NET Core policies already reject tokens without `SIS.Staff`. If an administrator also enables API assignment required, test token acquisition with real staff before rollout; it can block token issuance for users without an API app-role assignment.

## 6. Add one new staff member

This is the day-to-day portal procedure. Use an authorized Entra application administrator or service-principal owner for assignments; if a control is unavailable, ask your tenant administrator. [Microsoft: assign users/groups](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/assign-user-or-group-access-portal).

1. **Confirm the identity.** In **Entra ID → Users → All users**, search the staff member's work account and confirm it belongs to the GEI tenant and is enabled. If it does not exist, follow your organization's normal user-provisioning process; do not create a second identity for a synchronized/on-premises account. [Microsoft: create and manage users](https://learn.microsoft.com/en-us/entra/fundamentals/how-to-create-delete-users).
2. **Choose the job access.** Start with `SIS.Staff`. Add `Admissions.Supervisor`, `Offering.Manager`, or `Offering.Administrator` only when the person's duties require those actions. Record who approved the access in your normal IT process.
3. **Assign Web entry.** Open **Entra ID → Enterprise applications → GEI SIS Web → Users and groups → Add user/group**. Select the staff account (or its assigned security group), choose **Default Access** if prompted, then **Assign**. This is needed when the Web enterprise app has **Assignment required? = Yes**.
4. **Assign baseline API role.** Open **Enterprise applications → GEI SIS API → Users and groups → Add user/group**. Select the person or their staff security group, choose **SIS Staff** (`SIS.Staff`), and **Assign**.
5. **Assign extra API role(s).** In the **same API enterprise app**, assign each extra job role required by step 2. Check the resulting assignments. If the portal picker does not let you attach multiple roles directly to the same user, use the separate security-group assignments in section 7, or have an Entra administrator use the [Microsoft-documented Graph/PowerShell assignment method](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/assign-user-or-group-access-portal). **Do not remove `SIS.Staff` to make room for an extra role.** The final test is that all required values appear in `/api/me`.
6. **Test as that staff member.** Ask them to sign out of SIS and sign back in with the intended work account. Open `/workspace`, then inspect the `/api/me` response in the browser Network tab. Confirm the expected `roles` array and try one allowed action. Also verify that an action outside their role is unavailable or rejected. Do not ask them for their password, MFA code, or token.

Example: an Admissions supervisor needs **Web assignment** plus **API `SIS.Staff`** plus **API `Admissions.Supervisor`**. `access_as_user` must already have tenant admin consent; it is **not** granted separately for each new employee.

## 7. Manage many users with security groups

If your tenant has the required Microsoft Entra ID P1/P2 licensing for enterprise-app group assignment, groups are easier to audit than repeated person-by-person assignments. Use **security groups** and add staff as **direct members**; nested group members do not inherit enterprise-app assignments. Verify licensing before relying on this path. [Microsoft: group access and licensing](https://learn.microsoft.com/en-us/entra/identity/users/groups-saasapps), [assignment limitations](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/assign-user-or-group-access-portal).

| Proposed security group | Assign group to enterprise app | Select app role |
| --- | --- | --- |
| `GEI-SIS-Staff` | GEI SIS Web **and** GEI SIS API | Web: **Default Access**; API: `SIS.Staff` |
| `GEI-SIS-Admissions-Supervisors` | GEI SIS API | `Admissions.Supervisor` |
| `GEI-SIS-Offering-Managers` | GEI SIS API | `Offering.Manager` |
| `GEI-SIS-Offering-Administrators` | GEI SIS API | `Offering.Administrator` |

The names above are recommendations, **not** groups that this repository has created. Create them under **Entra ID → Groups → New group** using your organization's naming and ownership policy. Assign each group to the listed enterprise app/role under **Users and groups**. To onboard someone, add them directly to `GEI-SIS-Staff` and to their job group(s), then confirm all roles via `/api/me`. To remove a privilege, remove the person from its job group; to remove all SIS access, remove them from the staff group and review any direct assignments. A feature group alone cannot pass the API's base `SIS.Staff` policy.

If P1/P2 group assignment is unavailable, use direct user assignments and check each required role. Do not substitute a broad Entra directory administrator role for an SIS app-role assignment.

## 8. Change access or remove a staff member

- **Promotion or new duty:** approve the requested duty; add the corresponding API role assignment or job-group membership; leave `SIS.Staff` in place; have the user sign out and in and verify `/api/me` plus the action.
- **Remove one duty:** remove only the corresponding API role assignment or job-group membership. Check for another path to the same role (for example, a direct assignment as well as group membership). Refresh the user's token by signing out and back in; verify the role is absent and the API denies the action.
- **Remove SIS access:** remove Web assignment and API role assignments, and remove the person from all SIS groups. Check for direct assignments that remain. For a leaver, follow the organization's identity offboarding process as well.
- **Urgent account compromise:** an Entra administrator should block sign-in and revoke sessions in addition to removing app access. Existing bearer access tokens may remain valid until they expire; removing an assignment is **not** guaranteed to terminate an already issued token immediately in this API. Follow [Microsoft's emergency-revocation guidance](https://learn.microsoft.com/en-us/entra/identity/users/users-revoke-access).

Keep a record of the approver, person/group, exact API role, reason, and removal date in the institute's access register. Periodically review the **Users and groups** lists for both enterprise applications. Do not rely on disabling an app-role definition to revoke access: Microsoft notes that existing assignments can continue to put a disabled role in tokens; remove the assignments themselves. [Microsoft: app-role behavior](https://learn.microsoft.com/en-us/entra/identity-platform/howto-add-app-roles-in-apps).

## 9. Add a new SIS permission in a future release

1. Write a small permission matrix: which operation needs the new role, which existing roles retain access, and who can assign it. Prefer stable job roles over a separate role for every button.
2. In **GEI SIS API → App roles**, create an enabled **Users/Groups** role with an exact stable value such as `Registrar.Manager`. Record the value in this guide.
3. In the .NET API, add or update an authorization policy in `Program.cs` and apply it to the appropriate endpoint(s). Keep the base `SIS.Staff` and delegated `access_as_user` checks unless the security model is deliberately redesigned. Add tests for allowed and denied callers.
4. In Angular, use `/api/me` roles to show the permitted UI and a clear denial message. The API policy remains the enforcement point: hiding a button does not protect an endpoint.
5. Assign the new API role to the approved user/group under the **API enterprise application**, obtain a new token, and verify both the allowed and denied cases. A new **app role** under the existing API scope does not itself require another delegated-permission consent; adding a **new API scope/permission** does require updating Web API permissions and obtaining the appropriate consent.

## 10. Troubleshooting by symptom

First identify **where** the failure occurs: Microsoft sign-in page, Angular route, `/api/me`, or a specific API action. In **Entra ID → Monitoring & health → Sign-in logs**, filter by user and application, then inspect the failure reason, error code, timestamp, and correlation ID. Sign-in logs help with identity/consent/assignment problems; API HTTP status and backend logs help with API policy and database errors. [Microsoft: troubleshoot sign-ins](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/howto-troubleshoot-sign-in-errors).

| Symptom | Likely check and action |
| --- | --- |
| **“Need admin approval”** for **GEI SIS Web** / `access_as_user` | In **Web app registration → API permissions**, verify the **Delegated** API permission and **Granted for [tenant]** status. Have an authorized admin review and grant tenant consent. Web/API group membership does not replace consent. |
| **AADSTS50105** or “user not assigned to this application” | Check **Web enterprise app → Properties → Assignment required?**, then **Users and groups**. Confirm the correct person or **direct** security-group membership. `Default Access` works for Web entry but does not produce `SIS.Staff`. [Microsoft: AADSTS50105](https://learn.microsoft.com/en-us/troubleshoot/entra/entra-id/app-integration/error-code-aadsts50105-user-not-assigned-role). |
| **AADSTS50011** redirect URI mismatch | Compare the exact scheme, host, port, path, and trailing slash in the **Web SPA redirect** and `frontend/public/app-config.json`. `localhost` and `127.0.0.1` are different. |
| Sign-in completes, then `/api/me` is **403 Forbidden** | Confirm `SIS.Staff` is assigned on the **API enterprise app** and `access_as_user` is the requested/consented delegated scope. Get a fresh token by signing out and back in, then inspect `/api/me`. |
| `/api/me` is **401 Unauthorized** | Check that Angular sent a bearer token for the **API**, the frontend API scope and backend API client/tenant IDs match, and the token has not expired. Check API logs; do not paste the token into chat. |
| `/api/me` works but an action is **403** | Compare `/api/me.roles` with the role matrix. Check the **API** job-role assignment and sign in again. Example: `SIS.Staff` alone cannot archive a student or edit an Offering. |
| Correct role is present, but write is unavailable | Check the relevant `WritesEnabled` switch, Offering active term/support, and any business-rule error returned by the API. These are separate from Entra authorization. |
| Role was assigned but the button is absent | Reload after sign-out/sign-in and check `/api/me.roles`. Angular uses this response to decide which action controls to show. If the API permits the action but the UI remains wrong, it is a frontend issue. |
| Protected API responds **503** during local development | The API may be missing valid `AzureAd:TenantId` or `AzureAd:ClientId` configuration; check local API setup. A 503 from an action can also indicate that writes are disabled. |
| API **404** or **500** | Usually investigate API routing, proxy, endpoint, or server/database logs after confirming sign-in works. These status codes alone do not prove an Entra role problem. |

For a help request, collect the user's work account, time and time zone, the Web or API app name, URL/action, HTTP status or Entra error code, sign-in-log correlation ID, and expected versus actual role names. **Never** collect passwords, MFA codes, client secrets, or access tokens.

## 11. Production checklist

- Register the exact **HTTPS** production URL as a **SPA** redirect for GEI SIS Web and use it in the deployed Angular config. Serve Angular and `/api` under the planned same-origin deployment, or explicitly review cross-origin configuration.
- Verify the Web app uses single-tenant sign-in, the API expects this tenant and its own audience, and only the required delegated API permission has tenant consent.
- Require institute MFA/Conditional Access as appropriate. Keep Web entry limited to assigned staff; leave students unassigned during this project phase.
- Grant `SIS.Staff` and extra roles through the API enterprise app, review membership regularly, and use least privilege. Test with a normal staff account, a supervisor/manager, and a denied account; administrator accounts can have special tenant behavior, so they are poor denial-test accounts.
- Keep secrets out of the SPA. Do not log bearer tokens or put them in bug reports. Plan for access-token expiry during offboarding and respond to compromise using the tenant's emergency process.

Microsoft's documentation is authoritative for portal behavior and licensing; the linked repository files are authoritative for what this version of GEI SIS enforces.
