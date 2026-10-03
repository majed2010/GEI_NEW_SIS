# Offering operations

The first Offering release is implemented for course offerings and lecture/child sections. The authoritative write term is `dbo.ActiveSemesters.OfferingSemester`; the administrator approved `SemesterId=66` and the cutover set it to 66. Historical terms are read-only in the SIS.

## Running the module

Start the API and Angular frontend as described in the project README. Open **طرح المقررات والشعب** in the sidebar. Every authenticated `SIS.Staff` user can search and view. New offerings use the active term automatically; they cannot select a different insertion term. The API also rejects edits/deactivation of historical terms.

In the **GEI SIS API** Entra app registration, define app roles with exact values `Offering.Manager` and `Offering.Administrator` for users/groups, then assign the appropriate staff groups to those roles in the API enterprise application. An offering manager can create offerings and sections and edit offering course/department before sections exist or section capacity. An offering administrator has those actions plus deactivation. The existing `SIS.Staff` role and delegated `access_as_user` scope remain required for every endpoint. Users need a fresh access token after role assignments; signing out and back in is the simplest way to obtain one. `Offering:WritesEnabled` is an additional API switch, set to `true` in `appsettings.json` here. Restrict this flag in a deployed environment as needed.

## Database cutover and backup

The migration is [003-offering-support.sql](../database/003-offering-support.sql). The applied cutover created a verified backup at `database/backups/TeiDB-before-offering-20261003-144251.bak`, added `SisVersion` to the two Offering tables, audit and numbering-counter tables in `sis`, query indexes, and set `OfferingSemester=66`. The one-time migration deliberately fails on repeat so counters are never silently reseeded. [apply-offering-support.ps1](../scripts/apply-offering-support.ps1) makes and verifies a backup before running the migration for a fresh installation; it is **not** a repeatable startup command.

To move the active term later, an administrator should verify that exactly one `ActiveSemesters` row exists, the desired semester is visible and valid, and outstanding edits for the previous term are complete. Then update `OfferingSemester` directly in the database under the institute's change procedure. The SIS reads the value each time it opens a write transaction and never falls back to `AdmissionsSemester`.

Generated section codes use a one-time seed from all parseable legacy codes. The 1,910 seeded counter values were recorded in [003-offering-counter-seeds-20261003.csv](../database/review/003-offering-counter-seeds-20261003.csv). Historical anomalies remain untouched. Each new number is allocated by an atomic counter update within the section creation transaction; a term-wide collision check runs before insert. New sections leave `ScheduleCapacity` untouched and receive the table default for `ReservedCapacity` (0), matching the existing advising convention. These fields are absent from the Offering API and page.

## Validation and limitations

The Angular build and .NET build pass. `scripts/OfferingSmoke` checks live context, lookups, current and historical search, and offering detail without changing records. The existing 292 term-66 offerings and 257 term-68 offerings remained unchanged during those checks. Run `dotnet .tools/offering-smoke/OfferingSmoke.dll --write` after building the smoke project to create a temporary LocalDB test database under `.tools`, exercise offering/lecture/child creation, generated codes, duplicate and stale-version guards, capacity edit, dependency blocks, deactivation and audit, then drop that database. This isolated write smoke passed. No end-to-end create/edit/deactivate sequence was run against production TeiDB because that would add test academic records. Before assigning manager roles to staff, confirm downstream advising/registration reads with a representative generated lecture and child section in a restored copy of the full TeiDB.

The isolated test also creates two lectures simultaneously and verifies that they receive distinct, sequential codes. It allows a cross-department offering and an edit to an unused offering even when the same course has sections in another department.

The first release intentionally excludes timetable, room and instructor assignment, template-driven generation, and edits to reserved/schedule capacity. Legacy duplicate offerings and invalid historical parent links remain visible rather than modified.
