# Initial verification — 26 September 2026

Passed:

- Angular production build, including strict template compilation.
- TypeScript strict typecheck.
- ASP.NET Core build: zero warnings/errors.
- Frontend, runtime configuration and local Arabic font HTTP checks: 200.
- API health endpoint: 200.
- API without SSO configuration: `/api/me` returns 503 for missing and invalid bearer tokens.
- Temporary API with dummy tenant/client GUIDs: `/api/me` returns 401 for missing and invalid bearer tokens.

Not yet verified:

- In-browser visual layout, keyboard flow and interactive UI behavior: browser tool failed to connect due to an environment error (`missing field sandboxPolicy`). Responsive styles and native modal focus containment are implemented but require browser review.
- Live Microsoft 365 sign-in, staff role/scope authorization with real tokens, tenant MFA and logout: requires the institute's Entra configuration and test account.
- Database behavior: no connection or schema modification has been made.

Suggested visual acceptance: review `/login` and `/preview` on desktop and narrow/mobile screens, search modules, filter and inspect a sample request, switch academic year, navigate module pages, open/close dialogs with keyboard, and return to login. Configure the tenant and verify allowed staff and denied non-staff accounts before deployment.
