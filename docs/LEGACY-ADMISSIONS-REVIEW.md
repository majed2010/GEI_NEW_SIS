# Legacy admissions review and proposed improvements

**Status:** Read-only analysis; implementation still requires approval.  
**Sources:** supplied TEIADMIN source, its root `Bin/TeiLib.dll`, and current TeiDB procedure/function definitions.  
**Review scope:** detailed source tracing of `Insert_students.aspx`, `students.aspx`, their code-behind, student DAL methods, related SQL, and student printing. A separate [site inventory](LEGACY-SITE-INVENTORY.md) lists the broader application surface; unrelated modules are not claimed to be fully audited.

**Subsequent user decisions:** This document preserves the legacy findings and proposals at review time. [ADMISSIONS-DECISIONS.md](ADMISSIONS-DECISIONS.md) supersedes its open questions and delete proposals: archive/restore is selected, initial statuses are confirmed, and academic context must come from ActiveSemesters. No implementation approval has been given.

The website was not executed, no student records were sampled, and no write procedure was executed. Source behavior is distinguished below from changes proposed for approval. Other DLL copies under `old`/`new` were not treated as the deployed version. Confirm the root DLL and supplied TeiDB definitions match your running legacy installation before cutover.

## 1. Confirmed execution paths

| Entry point | Data-access method | Current SQL | Main record |
|---|---|---|---|
| `Insert_students.aspx` insert | `StudentsDAL.Insert_Terms(Student)` | `dbo.Student_Insert_Terms` | `dbo.Students` |
| `students.aspx` insert | `StudentsDAL.Insert(Student)` | `dbo.Student_Insert` | `dbo.Students` |
| Both pages: list | `StudentsDAL.GetByPage` / `GetRowsCount` | `dbo.Students_GetByPage` | `dbo.Students` |
| Both pages: detail | `StudentsDAL.GetById` | `dbo.Students_GetById` | Student with joined child records |
| Both pages: edit | `StudentsDAL.Update(Student)` | `dbo.Students_Update` | Student and child records |
| Both pages: delete | `StudentsDAL.Delete` | `dbo.Students_Delete` | Student and multiple dependent tables |
| Entry wizard's duplicate-ID check | `StudentsDAL.IsValidNationalId(string)` | `dbo.check_nationalId` | Exact national-ID existence check |
| Print student details | `StudentInfo.aspx` → `StudentsDAL.GetById` | `dbo.Students_GetById` | `Reports/StudentInfo.rdlc` report |

`TeiLib.Student` is a C# model name. Neither reviewed insert path writes to `dbo.NewStudents`. This resolves the physical main-table ambiguity in the first plan: use **`dbo.Students`**.

## 2. Functionality comparison

| Capability | Legacy behavior | New SIS proposal |
|---|---|---|
| Staff access | `Students_insert` section for the dedicated insert page; `Students Data` for the general page; legacy role `1` bypasses these page checks | Entra `SIS.Staff` plus operation permissions enforced at API endpoints |
| Entry experience | Five visible wizard tabs on dedicated insert; next/previous controls | Five Arabic steps plus a review/save step, responsive layout, preserved values and field-level errors |
| Personal data | Arabic/English names, gender, religion, nationality, birth details, national ID, passport, photo | Preserve these fields and approved encodings; consistent required-field and date/identifier validation |
| Prior education | Certificate type, location, certificate year, seat number, total score, percentage, school name, educational district, two languages | Include in first delivery; treat certificate year separately from intake year; decimal validation and confirmed percentage rules |
| Contact data | Arabic/English address, geographic location, landline, two mobile fields, email, Facebook/Twitter and parent contacts | Include; validate contact formats; avoid silently dropping existing optional/social fields |
| Family | Father/mother names and occupations, with parent phone/email fields | Preserve existing Arabic/English fields; explain required fields without fabricated filler values |
| Activities/hobbies | Activity, place, championship/date, hobby/place | Include in first delivery, with nullable/optional behavior reconciled against actual table constraints |
| Institute discovery source | `InstituteStatmentsDAL`, saved via `Studentsknowledge` | Preserve as “how the student learned about the institute”; confirm final Arabic label |
| Military/admission tabs | Hidden on dedicated insert; corresponding handler assignments commented out there. Present in general student maintenance and edit/detail templates | Keep editable maintenance sections under permission; explicit approved defaults at creation instead of exposing unnecessary steps |
| Academic assignment | Dedicated insert does not submit academic dropdowns; general insert submits department/year/semester | Configured intake context, validated against lookups; distinguish intake from later semester assignment |
| Code generation | Generated in SQL, despite a code textbox on edit | Read-only generated code, approved safe allocation preserving format; controlled correction/recode if explicitly required |
| List search | Code + three Arabic name parts + year + department; `students.aspx` also supplies semester | Retain separate advanced name fields; add full-name quick search and authorized exact ID/passport search |
| List results | Paging; code link opens detail; name, department, year and semester columns; edit/delete/print actions | Server paging with correct per-request count, actual allowlisted sorting, saved filters, responsive table |
| New-student population | Reviewed SQL has no new-student-only predicate | Business rule still needs confirmation; do not infer newness from the page name or `IsTerms=1` |
| Printing | StudentInfo RDLC opens from list | Add an authorized Arabic print-friendly student profile with an agreed field set; browser print/PDF is sufficient initially |
| Updates | One wide update across student and child tables, with file replacement | Transactional aggregate updates, child-record identity checks, stale-edit detection and audit |
| Delete | Deletes academic/expense records as well as the student | Do not reuse; restricted unreferenced-new-student deletion or approved archive policy |
| Errors | Some handlers expose inner exception text; DAL update/delete swallow exceptions | Consistent failure responses, safe Arabic messages, rollback and internal correlation IDs |

## 3. Confirmed lookup mappings

These are now source-backed mappings, replacing the tentative mappings in the first plan. Data quality and row cardinality still need profiling before writes.

| Field | Lookup / encoding | Detail |
|---|---|---|
| Birthplace | `Locations.LocationId` | `Locations_GetAll` mode **4**, combining location Types 1 and 2 |
| National-ID release zone | `Locations.LocationId` | Mode **5**, all non-hidden locations, hierarchical display |
| Address location | `Locations.LocationId` | Mode **5** |
| Certificate country/location | `Locations.LocationId` | Mode **1**, location Type 1 |
| Nationality | `Nationalities.NationalityId` | Arabic label `ArNationalityName` |
| Gender | `true/1 = ذكر`, `false/0 = أنثى` | Confirmed radio values |
| Religion | `1 = مسلم`, `2 = مسيحي` | Confirmed displayed choices; do not collapse unknown existing values to 2 |
| Certificate | `Certificates.CertificateId` | `ArCertificateName` |
| Certificate year | `Years.YearId` | UI submits the key, not display text. `StudentsCertificate.CertificateYear` is varchar while procedure parameter is int: handle deliberately |
| School | `StudentsCertificate.SchoolId` | **Free-text school name**, despite “Id” suffix; school lookup join is commented out in detail SQL |
| Educational district | `StudentsCertificate.educationalPlace` | Free text |
| Languages | `Languages.LanguageId` | First and second language |
| Activity | `Activities.ActivityId` | `ArActivityName` |
| Hobby | `Hoppies.HoppyId` | `ArHoppyName`; preserve physical misspelling in mapping only |
| Institute discovery source | `InstituteStatments.InstituteStatmentId` | `InstituteStatment` label; stored in `Studentsknowledge` |
| Army status | `ArmyStatus.ArmyId` | `ArArmyStatusName` |
| Acceptance type | `AcceptanceTypes.AcceptanceId` | `ArAcceptanceName` |
| Department/year/semester | `Departments`, `Years`, `Semesters` | Explicit joins; keep year/semester consistency |

Locations have `Type`, `ParentId` and `Hide`; preserve hierarchical labels from the legacy location functions or an equivalent cycle-safe resolver. Do not map these fields to `States` or `Countries` merely because those tables exist. Missing/hidden legacy lookup values must remain visible on existing records and must not erase students from search results.

## 4. Exact numbering behavior and proposed replacement

`dbo.GenerateStudentCode(@SemesterId)`:

1. Resolves `Years.ActualYear` through the supplied semester.
2. Finds the maximum rightmost four characters of existing student codes matching that year prefix, then adds one.
3. Pads the suffix to four digits; falls back to `0001` when the generated code is null.
4. Returns the year prefix followed by the suffix, for example `20260001` as a format illustration, not an observed student code.

This establishes **generated year-prefixed numbering**, not manual numbering. It still leaves collision enforcement, malformed-code handling and the policy beyond 9,999 students unresolved. The current inspected indexes do not enforce unique `StudentCode`.

**Proposed change:** preserve the format and year partition but use an atomic counter keyed by the approved code-year prefix, plus an approved global unique constraint on the complete code after duplicate profiling. Initialize counters once from validated existing codes under controlled cutover; do not use an ordinary `MAX + 1` on each insert. Specify overflow behavior before enabling writes.

If both systems will create students, both must use the same allocation boundary. A new counter used only by the SIS cannot prevent the legacy function from allocating a conflicting code. Approve a coordinated legacy change or disable legacy creation at cutover; do not claim new-only locking solves coexistence.

### Hard-coded values found

The dedicated `Student_Insert_Terms` procedure generates a code using semester **63**, but saves **DepartmentId=1**, **YearId=27**, **SemesterId=66**, **IsTerms=1**, **ArmyId=1**, **AcceptanceId=1**, **EnrollmentId=1**.

These are verified numeric literals, not confirmed current business defaults. Code-year derivation and saved semester can therefore disagree. Replace them with approved configuration and validated input. The general insert also sets `IsTerms=1`, so this field alone does not distinguish these two admission paths.

Both inserts form `StudentEmailInstitute` from trimmed `FirstName + '.' + StudentCode + '@gei.edu.eg'`. This only stores text: it does not provision a Microsoft 365 account. Preserve the intended format only after naming/duplicate rules are approved; provisioning remains outside this admissions scope.

## 5. Actual write footprint

Both insert procedures write the same aggregate:

1. `Students`
2. `StudentsActivity`
3. `StudentsArmyStatus`
4. `StudentsCertificate`
5. `StudentsContacts`
6. `StudentsHoppy`
7. `StudentsAcceptance`
8. `Studentsknowledge`

The dedicated procedure uses defaults for army/acceptance data. The general procedure accepts their form values. Document-upload table inserts are commented out and are not active functionality in these paths.

`Students_GetById` joins these child tables and related lookups without choosing a single child row. `Students_Update` updates child rows by `StudentId`, not by child primary key. If a child table has multiple matching rows, reads may multiply and updates may change all matches; if a child row is missing, the update does not create it. Profile this before defining singular form sections. If multiple rows are legitimate, design a collection editor or explicit current-record selection rather than picking the first row silently.

The inspected create/update/delete SQL has transaction statements commented out; inspected DAL methods do not begin a transaction. An intermediate failure can leave partial changes. New writes must be atomic and must include audit/idempotency effects.

## 6. Defects and behavior changes requiring attention

| Finding and evidence | Impact | Proposed treatment |
|---|---|---|
| `GenerateStudentCode` uses `MAX` suffix + 1 | Simultaneous inserts can allocate the same code; deleting highest code can allow reuse | Atomic allocation shared by all writers, uniqueness enforcement and overflow handling |
| `Student_Insert_Terms` uses semester 63 for code and 66 for stored assignment | Code and academic context may diverge | One approved intake configuration, no hard-coded academic IDs |
| `Students_Update` regenerates code when semester changes | Routine academic edit can change the student's identifier; stored institutional email is not updated there | Keep code stable by default; separately approve any recoding workflow and dependent reconciliation |
| Page reads edit `StudentCode`, but DAL update does not pass it | Editable UI implies a change that is not persisted directly | Display code read-only unless explicit recode feature is approved |
| `check_nationalId` checks existence only; wizard runs it on Next | It is not format validation and is not atomic duplicate protection on save | Preserve early feedback plus transactional server checks on create/update, with agreed foreign-student exceptions |
| DAL `Update` catches and discards exceptions | Page can present successful update although SQL failed or only partially completed | Propagate typed failures; commit only on full success |
| DAL `Delete` catches errors and reports -1 | Details lost; earlier deletes may already have committed | Transactional validated command with explicit failure reporting |
| `Students_Delete` deletes `StudentGrades`, `StudentsGrade_Terms`, advising, sections and `Students_Expenses` | Potential loss of academic and financial history | Never call it from new admissions; block deletion where protected dependencies exist |
| That delete procedure omits `StudentsAcceptance` and `Studentsknowledge`, among other possible references | Potential orphan data; no complete dependency registry | Explicit reviewed ownership/dependency map, no inferred broad cascade |
| DAL `_count` is static shared state | Concurrent searches can use another request's count | Return rows/count from the same request/query contract |
| Search SQL uses an inner department join, while count query does not | Orphan/missing department can hide rows and cause count mismatch | Left join/diagnostic display and identical filter/count semantics |
| Grid declares sorting, but DAL/SQL exposes no sort argument | Sorting is not established end-to-end by the reviewed code | Implement explicit allowlisted sorting, test actual result order |
| Update/insert fields use inconsistent date conversion and nullable handling | Optional blank values may fail conversion or behave inconsistently | Typed nullable date contracts, server validation, Arabic display with unambiguous transport |
| Photo validation trusts MIME text and excludes only TIFF | File type/size/content controls are insufficient | Decode and allowlist JPEG/PNG, size/pixel limits, generated names, protected storage and access |
| Update failure cleanup deletes `e.NewValues["Image"]` even when it is the unchanged old filename | Existing photo can be lost on a reported failure | Track staged new assets separately; never remove the active asset on failed save |
| Delete visibility hard-codes user IDs: dedicated page 1; general page 1/9/174 | Permission differences hidden in UI | Explicit Entra operation roles checked at service boundary |
| `StudentInfo.aspx.cs` uses a query-string ID and has no local role check | Print authorization depends on unreviewed global configuration | Require the same read authorization for print/photo/detail endpoints |

These are source findings, not evidence that a specific production student record has been damaged. Existing global controls may affect runtime exposure; the legacy site was not penetration-tested.

## 7. Proposed revised delivery scope

The first plan omitted photos/printing and treated related records as optional. For legacy parity, now propose:

- Search/list/detail, five-step entry, editing, and approved deletion policy.
- Prior education, contacts, family, activities/hobbies and discovery-source data included in the core aggregate.
- Photos included with safe replacement and staged-upload cleanup; scanned-document management remains deferred.
- Military and acceptance maintenance included, with approved defaults on initial entry.
- Staff-authorized print profile included. RDLC layout/field list will be compared during implementation before print acceptance.
- Concurrency, transactions, idempotency, audit and role checks retained from the original enhancement plan.
- Draft-in-progress persistence, admissions decision approvals, document workflows, bulk imports/exports, and Microsoft account provisioning are not silently added.

## 8. Decisions still needed

1. What exactly defines the “new students” list and editing cutoff? The legacy search returns the general population subject to filters.
2. Which current intake/year/semester/department defaults replace 63/27/66/1, and should staff override them?
3. Approve preserving year + four-digit suffix with a shared atomic counter; decide 9,999 overflow and whether codes remain stable on semester changes.
4. Confirm initial military/acceptance/enrollment defaults and nationality-specific ID/passport requirements.
5. Approve the expanded parity scope including photos and printing.
6. Confirm restricted deletion versus archive, staff permissions, schema proposals and isolated test database.
7. Will the old and new systems accept writes concurrently? This determines allocation, uniqueness and deletion cutover controls.

## 9. Evidence pointers

- [Dedicated insert markup](../TEIADMIN/Insert_students.aspx) and [handlers](../TEIADMIN/Insert_students.aspx.cs): wizard, lookup modes, hidden tabs, insert binding, file behavior and ID check.
- [General student markup](../TEIADMIN/students.aspx) and [handlers](../TEIADMIN/students.aspx.cs): search, academic fields, CRUD and print links.
- [Print handler](../TEIADMIN/StudentInfo.aspx.cs) and [RDLC layout](../TEIADMIN/Reports/StudentInfo.rdlc).
- Root [TeiLib DLL](../TEIADMIN/Bin/TeiLib.dll) inspected statically; recovered `StudentsDAL` text is in `.reference/StudentsDAL.cs` (ignored).
- Read-only SQL definition snapshots are under `.reference/legacy-procedures/` (ignored): `Student_Insert`, `Student_Insert_Terms`, `Students_GetByPage`, `Students_GetById`, `Students_Update`, `Students_Delete`, `GenerateStudentCode`, `check_nationalId`, `Locations_GetAll`, `GetArLocationName`.

**No implementation or database modifications have been made.** See the [updated approval plan](ADMISSIONS-IMPLEMENTATION-PLAN.md).
