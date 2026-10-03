# Admissions section — implementation plan for approval

**Status: Application implementation authorized; database cutover pending separate review.**  
**Date: 26 September 2026.**  
**Scope: Arabic RTL staff screens to search, add, view, update, archive and restore new-student records.**

**Revision 4 — admissions semester confirmed:** [ADMISSIONS-DECISIONS.md](ADMISSIONS-DECISIONS.md) records the authoritative latest requirements and verified default status IDs. Creation derives year from `ActiveSemesters.AdmissionYear` and semester from `ActiveSemesters.AdmissionsSemester`; admissions staff cannot change either insertion setting. `AdmissionsSemester` currently has no value, so creation must be blocked until valid configuration is supplied. Archive/restore replaces permanent-delete proposals. Application implementation was authorized on 1 October 2026; database scripts remain review-only.

**Revision 2 — legacy reference reviewed:** This plan now incorporates the dedicated insert and student-search workflows from TEIADMIN, including their compiled data-access methods and current TeiDB SQL. Read the [legacy behavior and enhancement comparison](LEGACY-ADMISSIONS-REVIEW.md) alongside this plan. Confirmed mappings below replace the earlier guesses. Database changes still require separate approval.

The current implementation state is tracked in [ADMISSIONS-IMPLEMENTATION-STATUS.md](ADMISSIONS-IMPLEMENTATION-STATUS.md). The database migration has not been applied and no student data has been modified.

## 1. Confirm the main table and the meaning of “new student”

You identified the main table as **Student**. Live inspection of TeiDB found:

| Object | Verified structure | Proposed use |
|---|---|---|
| `dbo.Students` | 40 columns; identity primary key `StudentId` | Confirmed target of both legacy insert paths |
| `dbo.NewStudents` | Separate table with 39 columns and its own identity `StudentId` | Not used by the reviewed legacy insertion paths; do not write here |
| `dbo.StudentsAcceptance` | Admission information linked logically by `StudentId` | Included in the legacy aggregate; confirm defaults and cardinality |
| `dbo.StudentsContacts` | Contact information linked logically by `StudentId` | Included in the legacy aggregate; confirm cardinality |

**No object named `Student` was returned by the live object-name check.** The C# model can be named `Student` while mapping to `dbo.Students`; no database rename is proposed. IDs from `NewStudents` and `Students` must not be treated as interchangeable.

**Resolved by source review:** The C# `TeiLib.Student` model maps through `StudentsDAL` to `dbo.Students`. No table rename is needed.

**Admission context:** Use `ActiveSemesters.AdmissionYear` for `Students.YearId` and to resolve `Years.ActualYear` for the code prefix. Use the newly added `ActiveSemesters.AdmissionsSemester` for `Students.SemesterId`. Verify that the semester exists and that `Semesters.YearId` matches the admission year. Current admission year 21 resolves to 2019/2020 and code prefix 2020, while `AdmissionsSemester` is NULL. Do not change these settings or infer the calendar year; block creation until a valid admissions semester is configured. Proposed new-student filter is active admission year plus acceptance/enrollment `مستجد`, excluding archived records; the exact filter still needs confirmation.

## 2. User experience

Use the existing GEI logo, navy/blue theme, Cairo font and Arabic RTL navigation. Replace the admissions placeholder only; keep preview/sample data separate from authenticated database screens.

### 2.1 Admissions list — القبول والطلاب الجدد

- Page heading, selected intake/year, result count, and **إضافة طالب جديد** button.
- Quick search by student code or Arabic/English name. Separate authorized exact-match fields for national ID and passport number.
- Filters: academic year, semester, department and nationality. Add admission type/status only after its lookup and join are confirmed.
- Dependent semester choices follow the selected year; changing year clears an incompatible semester.
- Table columns: student code, Arabic full name, department, nationality, academic year/semester, and admission type/status where confirmed.
- Row actions: **عرض**, **تعديل**, **أرشفة**, and **استعادة** in the archived view, based on signed-in staff permissions and record eligibility.
- Server-side paging, sorting and filtering. Default page size 25, maximum 100; stable secondary sort by `StudentId`.
- Debounced name/code search with cancellation of stale requests; reset paging when filters change.
- Loading, no-results, lookup-unavailable, access-denied and connection-error states in Arabic.
- Preserve filters and paging when returning from details/edit. Keep sensitive identifiers out of route parameters and browser URLs.
- Preserve the legacy three-part Arabic-name filters as advanced search, plus a convenient full-name quick search.
- Include an authorized **طباعة بيانات الطالب** action, preserving the legacy printing capability.

### 2.2 Add student — إضافة طالب جديد

Use an Arabic five-step wizard matching the dedicated legacy entry page: personal information, prior education, contacts, family, and activities/hobbies; add a review/save step and sticky actions. The general legacy student page also supports military and admission maintenance sections, which the new detail/edit screen will include under permission. Group fields as follows:

| Form section | Existing main-table fields |
|---|---|
| Student identification | `StudentCode`; `StudentId` is generated by SQL Server |
| Arabic and English names | `ArFirstName`, `ArMiddleName`, `ArLastName`, `FirstName`, `MiddleName`, `LastName` |
| Personal information | `Gender`, `Religion`, `DateOfBirth`, `PlaceOfBirth`, `Nationality` |
| National identification | `NationalId`, `NationalIdReleaseDate`, `NationalIdReleaseZone` |
| Passport | `PassportId`, `PassportReleaseDate`, `PassportExpirationDate` |
| Parents/guardian information | Existing father/mother name and occupation fields, Arabic and English |
| Languages | `FirstForeignLanguage`, `SecondForeignLanguage` |
| Intake and academic assignment | Server-derived `YearId`/`SemesterId` from the confirmed active configuration; insertion semester is read-only. Default department is 1 |
| Admission and military details | `StudentsAcceptance` and `StudentsArmyStatus`; initial defaults explicitly configured and later maintenance permission-controlled |
| Contact details | `StudentsContacts`, including second mobile, addresses and parent contact fields |
| Prior education | `StudentsCertificate`: certificate, geographic location, year, seat number, scores, school name and educational district |
| Activities and hobbies | `StudentsActivity`, `StudentsHoppy` |
| How the student learned about the institute | `Studentsknowledge` referencing `InstituteStatments` |

Additional behavior:

- Required markers and field-level messages match database constraints and approved business rules.
- Validate before saving; focus the first invalid field and show an error summary.
- Prevent repeat submission while saving; a retry must not create a second student.
- On success, show the saved student's detail page and assigned student code.
- Warn before leaving a form with unsaved changes.
- Include student photo upload/replacement for legacy parity: staged files, JPEG/PNG content decoding, approved size/pixel limits, generated filenames, protected storage, safe rollback and cleanup. Preserve the old photo until the new save succeeds. Scanned-document upload remains outside this initial scope.
- Preserve the institutional email naming intent only after approval. Saving an email string does not create a Microsoft 365 account; account provisioning stays out of scope.

### 2.3 Details and update — ملف الطالب / تعديل البيانات

- Show readable lookup labels and grouped student information.
- Load the actual current record and related records; never synthesize missing required information.
- Edit only explicitly permitted admissions fields; computed/system/finance/graduation fields are not freely editable.
- Save only intended field changes and preserve unrelated existing data.
- Reject stale updates with a clear message and reload/compare option; never silently overwrite another user's changes.
- After approved enrollment/registration milestones, apply agreed restrictions to admission identity and intake fields.
- Keep the student code stable by default. Legacy SQL regenerates it on a semester change, despite the displayed code textbox not being passed to SQL; any recoding must become a separate approved action with dependent-data reconciliation.

### 2.4 Archive and restore — أرشفة / استعادة

**User decision: archive/restore only. Permanent deletion is excluded.**

1. Check archive/restore permission and current record version on the server.
2. Explain the action, show student name/code and require an archive reason.
3. Preserve the student and every related record; atomically update archive state and audit metadata.
4. Exclude archived students from normal admissions lists and provide an authorized archived view with restore.
5. Restore the same student identity/code, recording actor/time and checking concurrency/invariants.
6. Keep archived codes and identity identifiers reserved under the approved duplicate policy; archive is not permission to reuse them.

No SQL DELETE or legacy `Students_Delete` call is included. Archive must not silently cancel registrations, financial liabilities or academic history. Agree downstream visibility and handling of ongoing transactions, particularly if legacy remains writable before cutover. Archive storage requires a reviewed schema change; it is not a verified existing `Students` field.

## 3. Lookup tables without declared relationships

No foreign keys are required merely to display dropdowns or resolve labels. Use explicit, reviewed mappings in the API, parameterized joins and server-side validation. Do not create new database relationships automatically.

| Student/related field | Candidate lookup | Label / relationship | Confidence |
|---|---|---|---|
| `Students.Nationality` | `dbo.Nationalities` | `NationalityId` → `ArNationalityName` | Matching metadata; validate actual values |
| `Students.DepartmentId` | `dbo.Departments` | `DepartmentId` → `ArDepartmentName` | Matching metadata; validate actual values |
| `Students.YearId` | `dbo.Years` | `YearId` → `YearName` | Matching metadata; confirm intake semantics |
| `Students.SemesterId` | `dbo.Semesters` | `SemesterId` → `ArSemesterName`; `Semesters.YearId` filters by year | Matching metadata; validate actual values |
| First/second foreign language | `dbo.Languages` | `LanguageId` → `ArLanguageName` | Matching metadata; validate actual values |
| `Students.PlaceOfBirth` | `dbo.Locations` | `LocationId` → hierarchical `ArLocationName`; lookup mode 4 (Types 1/2) | Confirmed by legacy markup and SQL |
| `Students.NationalIdReleaseZone` | `dbo.Locations` | Lookup mode 5; all non-hidden locations | Confirmed by legacy markup and SQL |
| `StudentsContacts.StudentAddressLocation` | `dbo.Locations` | Lookup mode 5 | Confirmed by legacy markup and SQL |
| `StudentsCertificate.CertificateCountry` | `dbo.Locations` | Lookup mode 1, Type 1 locations | Confirmed by legacy markup and SQL |
| `Students.Gender` | Existing `bit` encoding | `1/true = ذكر`, `0/false = أنثى` | Confirmed in legacy radio controls |
| `Students.Religion` | Existing `tinyint` encoding | `1 = مسلم`, `2 = مسيحي` | Confirmed displayed options; preserve any unknown legacy values |
| `Students.IsTerms`, `TermsId` | Existing study-system/term configuration | `StudySystem` and `TermsLevelConfig` are candidates only | Unconfirmed; do not infer from names |
| `StudentsAcceptance.AcceptanceId` | `dbo.AcceptanceTypes` | `AcceptanceId` → `ArAcceptanceName` | Matching metadata; validate actual values |
| `StudentsAcceptance.EnrollmentId` | `dbo.Students_Enrollment_Status` | `Id` → `Student_Enrollment_Status_Name` | Candidate logical mapping; confirm |
| Certificate / activity / hobby | `Certificates`, `Activities`, `Hoppies` | Their ID and Arabic-name fields | Confirmed in legacy form and detail SQL |
| Certificate year | `Years.YearId` | Stored in a varchar column; procedure accepts int | Confirmed; preserve key semantics |
| School name | Free-text `StudentsCertificate.SchoolId` | Not a school lookup in these workflows | Confirmed in handler/detail SQL |
| Institute discovery source | `InstituteStatments` | `InstituteStatmentId` → `InstituteStatment` | Confirmed, stored in `Studentsknowledge` |
| Military status | `ArmyStatus` | `ArmyId` → `ArArmyStatusName` | Confirmed |

Lookup behavior:

- Validate keys, actual value ranges, duplicates and orphan references with aggregate checks; resolve ambiguous mappings with your team. Do not infer meaning from ID ranges.
- Verify whether `Hide` means hidden/inactive for each table before filtering on it.
- Use left joins so a missing lookup does not make a student disappear from search results.
- A duplicate lookup key must not multiply student rows. Treat ambiguous lookup data as a mapping error to resolve.
- For an unknown legacy value, display its original ID with **قيمة غير معرّفة**. Preserve unchanged values during unrelated edits, but require a valid selection when that field changes.
- Existing hidden values may be displayed on historical records; prevent selecting them for new assignments according to the approved rules.
- The server revalidates new/changed IDs and parent-child combinations on save. Client dropdowns are not an integrity boundary.
- Keep lookup endpoints staff-authenticated. No lookup-maintenance UI is included in the first release.

## 4. Database and validation rules

### Verified facts that affect implementation

- `Students.StudentId` is an identity primary key; clients cannot supply it on creation.
- `Students.FullName` is computed as Arabic first, middle and last names separated by spaces. Never insert or update it directly.
- `StudentCode` currently has non-unique indexes; a unique student-code constraint was not found in the inspected indexes.
- The name fields, gender, religion, birth date/place, nationality, father names and English father occupation have database `NOT NULL` requirements. These must be satisfied without silently inserting dummy values.
- `StudentDateInserted` and `StudentDateUpdated` are `date`, so they cannot provide a reliable concurrency token or precise audit timestamp.
- No trigger or check constraint on `dbo.Students` was returned by the targeted inspection. Related tables and stored procedures still need review.
- Database compatibility level is 100. Queries must be tested against that actual level without changing it automatically.

### Proposed validations

- Enforce lengths from SQL metadata; `nvarchar` metadata lengths are bytes, not character counts. Preserve Arabic spelling and use Unicode parameters for Unicode columns.
- Trim surrounding whitespace. Avoid destructive normalization of stored names; approved search normalization is separate from persisted values.
- Require date of birth to be a valid past date. Any minimum/maximum age limits need your admission policy.
- Egyptian students require an Egyptian national ID; international students require a passport, with no exceptions. Validate Egyptian format and at least its encoded birth date against the entered date of birth. Verify the exact official format rules before implementation; do not invent a checksum. Store identifiers as strings and preserve leading zeros.
- Check passport expiry is after issuance when both exist; distinguish date consistency from the institute's expiry acceptance policy.
- Student code uses `Years.ActualYear` + four-digit suffix, with the year taken from the approved active admission configuration. Preserve the format using an atomic year-prefix counter and approved uniqueness enforcement. The user confirms capacity will not exceed 9999; reject exhaustion rather than wrap or reuse. Do not use per-insert `MAX + 1`.
- Both legacy and new writers must share the allocator, or legacy creation must be disabled at cutover. Counter initialization from existing validated codes is a controlled one-time step, not the live allocation method.
- Replace legacy hard-coded academic defaults with the confirmed active configuration. Initial status labels are approved and verified: ArmyId 1 = `لم يصبه الدور`, AcceptanceId 1 = `مستجد`, EnrollmentId 1 = `مستجد`. Validate those lookup entries on save; do not confuse enrollment ID 3 `.مستجد` with ID 1.
- Agree duplicate rules for student code, national ID and passport, including blank/null values and legacy duplicates. Block confirmed duplicates on create and exclude the current student on update.
- Enforce approved uniqueness atomically; a separate pre-save duplicate lookup alone is insufficient. Propose an appropriate index/constraint only after profiling and explicit schema approval, or use a reviewed transactional strategy with known limitations for legacy writers.
- Prevent modifying finance (`ISpayment`) and graduation (`StudentGuraduated`) data through the admissions request payload.
- Write the student and the seven approved child-table groups in one transaction, rolling back the whole operation on failure. Confirm whether each child relationship is truly singular before editing; existing SQL can multiply reads or update multiple child rows by `StudentId`.

## 5. Backend design

Use the existing ASP.NET Core API and Microsoft Entra authentication. Add an admissions service, explicit request/response DTOs, validation, a reviewed lookup registry and a small SQL data-access layer.

**Proposed data access:** `Microsoft.Data.SqlClient` with parameterized SQL for this bounded legacy module. This allows explicit mappings and SQL compatible with the existing database without scaffolding all 309 tables. Core legacy procedure definitions and root DLL student methods have now been inspected read-only. Because of hard-coded values, partial-write behavior and destructive deletion, do not reuse those write procedures unchanged. No write procedure has been executed during discovery.

| Endpoint | Purpose |
|---|---|
| `POST /api/admissions/students/search` | Read-only paged search; body holds potentially sensitive search criteria |
| `GET /api/admissions/students/{id}` | Student detail plus approved related data and concurrency token |
| `POST /api/admissions/students` | Create student; return 201, ID and code |
| `PUT /api/admissions/students/{id}` | Update the approved editable fields with a required concurrency precondition |
| `POST /api/admissions/students/{id}/archive` | Archive with reason, audit and concurrency precondition; no physical deletion |
| `POST /api/admissions/students/{id}/restore` | Restore the same record with audit and concurrency precondition |
| `GET /api/admissions/lookups` | Approved dropdown values and their keys/labels |
| `GET /api/admissions/students/{id}/print` | Authorized print profile with approved fields |
| `POST /api/admissions/photo-uploads` | Stage an owner-bound, validated photo for later save |
| `GET /api/admissions/students/{id}/photo` | Authorized access to the active student photo |

Archive/restore are write operations with separate authorization and transactional revalidation. No permanent-delete endpoint is included.

- Allowlist sort columns; bound query length and page size; never concatenate client-supplied SQL identifiers.
- Use explicit column selection and parameter types; avoid exposing whole database entities or credentials.
- Return Arabic-friendly validation errors and appropriate 400/401/403/404/409/412 responses. Keep raw SQL errors and connection details in restricted server diagnostics.
- Keep sensitive search criteria and response bodies out of request logs. Retain the existing no-store API response policy.
- Concurrency proposal: add a `rowversion` to `Students` if approved, and define concurrency checks for editable child records. Without that approval, compare the exact originally read editable values atomically in SQL; a date-only timestamp or non-atomic application comparison is insufficient.
- Require an idempotency key for create and persist its outcome transactionally with the student, so retries after a lost response do not create duplicates. Its storage requires the schema approval below.

## 6. Permissions and auditing

Keep `SIS.Staff` and `access_as_user` as baseline requirements. Proposed additional operation permissions:

| Permission | Allowed actions |
|---|---|
| `Admissions.Read` | Search, details and lookups |
| `Admissions.Create` | Add new students |
| `Admissions.Update` | Edit eligible admissions records |
| `Admissions.Archive` | Archive eligible records |
| `Admissions.Restore` | Restore archived records |

Proposed enforcement: API app roles assigned through Entra staff groups, with corresponding UI capability flags. The API checks permissions on every endpoint. Archive/restore is supervisor-only as confirmed by the user; map the actual groups before enabling access. Student portal access is excluded.

For each successful mutation, store actor tenant/object ID, UTC timestamp, student ID, action, changed-field summary, correlation ID and archive reason where relevant. Keep archive and restore history, committing audit atomically with each mutation. Do not copy full national IDs, passport numbers or entire profiles into general logs. Any detailed before/after retention needs an approved restricted audit policy.

## 7. Proposed schema changes — separate approval required

No migration will run merely because the UI is being built. Prepare scripts for review after inspecting existing equivalent facilities.

| Proposal | Reason | Approval condition |
|---|---|---|
| Reuse a suitable existing audit facility, or add a dedicated admissions audit table | Trace creates, updates, archive and restore | Agree structure, access and retention |
| Add `rowversion` on `dbo.Students`, if chosen | Reliable detection of concurrent edits, including legacy writers | Verify legacy insert statements/mappings remain compatible |
| Persist create idempotency keys/results in an approved table | Safe create retries | Agree retention, user/tenant scoping and transactional behavior |
| Shared year-prefix code counter | Preserve legacy code format without duplicate allocation | Agree overflow, initialization and coexistence/cutover with legacy writers |
| Add an appropriate unique constraint/index only if needed | Race-safe code/identity uniqueness | Agree the uniqueness scope and resolve existing duplicates first |
| Archive state, actor/time/reason and restore history | Required for chosen archive/restore behavior | Review schema and downstream visibility; no physical deletion |

No automatic new foreign keys, table renames, compatibility-level upgrades, backup-table cleanup or changes to the existing student identity sequence are proposed.

## 8. Implementation sequence after approval

1. **Confirm remaining decisions and configuration.** Main table, lookup encodings, initial status IDs, required identity documents, archive/restore, department default and the admissions-semester column are established. Set a valid `AdmissionsSemester` consistent with `AdmissionYear` before creation. Resolve the exact new-student filter, related-record cardinality and cutover controls during the reviewed implementation.
2. **Complete data profiling.** Core insert/search/update/delete source review is complete and documented. Profile duplicates/orphans with aggregate queries; finish logical-dependency coverage and related-trigger review; reconcile legacy SQL signatures with current schema. No writes in this phase.
3. **Prepare persistence changes for review.** Produce any required migration scripts and a development restore/test plan. Approval is required before applying schema changes. If essential decisions remain unresolved, report the exact blocker instead of guessing.
4. **Implement read-only admissions.** Add database access, lookup resolution, protected search/details endpoints and Arabic list/details screens.
5. **Implement create/update.** Add validation, duplicate protection, transactions, idempotency, concurrency and auditing; connect the form and error states.
6. **Implement archive/restore.** Add the approved state design, authorization, reason/confirmation flow, audit and consistent active/archived filtering. Preserve all related records.
7. **Verify without changing real student records.** The user authorizes the current TeiDB as target; a separate test copy is optional. Use controlled synthetic fixtures and transaction rollback where feasible, with approved cleanup for any committed fixtures. Do not run destructive tests on real records. No permanent-delete feature is included.
8. **User acceptance and release.** Demonstrate the Arabic workflows with your staff, resolve feedback and confirm the target database before enabling writes there.

## 9. Acceptance criteria

- Search by approved fields returns correct, paginated records; orphan lookup values do not hide students or duplicate rows.
- The list includes only the confirmed new-student population and clearly identifies its intake/year.
- Invalid/hidden lookup selections are rejected appropriately; unchanged legacy values survive unrelated edits.
- New students are saved to the confirmed main table with the correct identity/code and a database-generated Arabic full name.
- Required names, dates and identifiers are validated without inventing business defaults.
- Duplicate and retried creates do not produce duplicate students.
- Updates preserve unrelated fields and reject stale edits, including conflicting child-record updates.
- Failure in any related write or mandatory audit write rolls back the operation.
- Missing/invalid tokens return 401; missing operation permissions return 403; hidden UI buttons alone are never relied on for enforcement.
- Archive and restore require permission and concurrency validation; archive requires a reason. No student, grade, registration or financial record is physically deleted; restore retains the original identity/code.
- Name/national-ID search input and sorting cannot inject SQL; sensitive values are excluded from URLs and routine logs.
- Arabic RTL screens work on desktop and narrow widths, including keyboard navigation, validation focus, dialogs and loading/error states.
- Legacy parity covers prior education, family, contacts, activities/hobbies, discovery source, photo and authorized printing; omitted legacy capabilities must be explicitly agreed.
- Concurrent searches cannot share result counts; filtering and count queries use identical semantics.
- Simultaneous creates through every enabled writer allocate different codes; initial-year, malformed-code and 9999-overflow cases are tested.
- Photo replacement failure leaves the previous photo intact; orphaned staged uploads expire safely.
- Existing legacy workflows continue to work after any approved schema change. Actual performance is measured against TeiDB's size; no invented response-time guarantee is assumed.

## 10. Approval checklist

Please answer the following in your approval or annotate this document:

- [x] **Main table established:** both reviewed legacy insertion paths write to `dbo.Students`. This records evidence, not implementation approval.
- [ ] **New student rule:** specify the fields/status/year rule defining the population and when admissions editing stops.
- [x] **Code source/capacity:** active `AdmissionYear` → `Years.ActualYear`; maximum 9999. Staff cannot change the insertion semester, sourced from `ActiveSemesters.AdmissionsSemester`.
- [x] **Parity scope:** user requested all reviewed legacy admissions sections and enhancements.
- [x] **Initial statuses:** military `لم يصبه الدور`, acceptance `مستجد`, enrollment `مستجد`; verified ID 1 in each lookup.
- [x] **Identification:** Egyptian national ID or international passport required without exceptions; Egyptian ID must match entered birth date.
- [x] **Removal behavior:** archive/restore, no permanent deletion. Physical schema still needs review/approval.
- [x] **Academic field mapping:** `ActiveSemesters.AdmissionYear` supplies the year; `ActiveSemesters.AdmissionsSemester` supplies the semester; department defaults to 1.
- [ ] **Operational configuration:** `AdmissionsSemester` is currently NULL. Configure a valid semester whose `Semesters.YearId` matches `AdmissionYear` before student creation is enabled.
- [x] **Database target:** user permits the current TeiDB; legacy stops after completion. Coordinate allocation while legacy remains writable.
- [x] **Permissions:** archive/restore is supervisor-only; configure actual group assignment before rollout.
- [x] **Supporting schema preparation:** user approved preparing scripts for review only. The [support-table proposal](../database/review/001-admissions-support-proposal.sql) is not executed; legacy uniqueness/concurrency changes need further review.
- [x] **Testing target:** current database permitted; TeiDB_SIS_Test is optional and has not been created. No real student records may be used for destructive tests.
- [ ] **Implementation:** approve this scope and sequence, subject to the decisions above.

**Approval boundary:** This document is a plan only. Implementation begins after you approve it; unresolved data meanings or destructive behavior will not be guessed.
