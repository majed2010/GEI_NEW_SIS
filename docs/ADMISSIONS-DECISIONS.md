# Admissions decisions — application implementation authorized

This record captures the user's latest decisions. It overrides conflicting proposals in the earlier legacy comparison. The user authorized application implementation on 1 October 2026. Schema scripts remain review-only and have not been applied.

**Later configuration update:** The table below records the earlier inspection. During the latest read-only check, the active setting had changed to `AdmissionYear = 27` (`ActualYear = 2026`) and `AdmissionsSemester = 66`, with `Semesters.YearId = 27` and `Hide = false`. The support schema is still unapplied. See [implementation status](ADMISSIONS-IMPLEMENTATION-STATUS.md) for the current activation state.

## Confirmed decisions

| Area | Agreed requirement |
|---|---|
| Main record | `dbo.Students`; internal `StudentId` remains the SQL identity. The generated institute identifier is `StudentCode`. |
| Admission context | Derive `Students.YearId` from `dbo.ActiveSemesters.AdmissionYear` and `Students.SemesterId` from the new `dbo.ActiveSemesters.AdmissionsSemester` column. Resolve `Years.ActualYear` through `AdmissionYear` for the student-code prefix. |
| Staff control | Admissions staff cannot choose or change the semester of insertion. Derive/validate academic context on the server, not only in disabled UI controls. |
| Capacity | Fewer than or equal to 9,999 codes per code year; retain four-digit numbering. Reject any exhausted range rather than wrap or reuse codes. |
| Legacy lifecycle | TEIADMIN will stop after the new system is finished. Exact timing of legacy/new writes during rollout still needs clarification. |
| Initial military status | `لم يصبه الدور` from `ArmyStatus` |
| Initial acceptance type | `مستجد` from `AcceptanceTypes` |
| Initial enrollment status | `مستجد` from `Students_Enrollment_Status` |
| Identification | Egyptian students must have an Egyptian national ID; international students must have a passport, with no exceptions. Validate Egyptian ID format and at least consistency with entered date of birth. |
| Removal | Archive and restore; no permanent deletion in admissions. Keep student and related academic/financial records intact. |
| Scope | Include all reviewed legacy admissions features and proposed functionality, including photo and print. This does not add student portal/account provisioning. |
| Department | Default `DepartmentId = 1`. |
| Permissions | Archive and restore are supervisor-only. Actual Entra group assignments will be configured before access is enabled. |
| Database target | The user permits using the current `TeiDB`; a test copy is not a prerequisite. Read-only integration checks are permitted. |
| Schema preparation | Prepare scripts for review, without applying them. `TeiDB_SIS_Test` may be used optionally; do not create it automatically. |

## Read-only verification of current TeiDB settings

The user added `ActiveSemesters.AdmissionsSemester` (plural **Admissions**). A read-only check on 1 October 2026 verified that it exists as a nullable `int`. It is the authoritative source for the new student's insertion semester.

| Setting | Current value |
|---|---|
| Active configuration row | `Id = 1` |
| AdmissionYear | `21` |
| Linked Years.YearName | `2019/2020` |
| Linked Years.ActualYear | `2020` |
| BillingYear | NULL |
| AdmissionsSemester | NULL |
| AdvisingSemester | NULL |
| OfferingSemester | NULL |

These values are observations. The application will use the configured admission year rather than substitute the calendar year. If unchanged, the observed admission year produces a **2020** code prefix. **AdmissionsSemester is currently NULL, so student creation must remain unavailable until it is configured to a valid `Semesters.SemesterId`.** Validate that the selected semester exists, is usable, and belongs to `AdmissionYear` through `Semesters.YearId`. Do not fall back to `AdvisingSemester`, `OfferingSemester`, the computer's current year, or a hard-coded legacy ID. No settings were changed.

Verified lookup IDs:

| Table / key | Approved label | Verified ID |
|---|---|---|
| ArmyStatus.ArmyId | لم يصبه الدور | 1 (`Hide = false`) |
| AcceptanceTypes.AcceptanceId | مستجد | 1 (`Hide = false`) |
| Students_Enrollment_Status.Id | مستجد | 1 |

Enrollment lookup also contains `.مستجد` at ID 3. The requested exact label resolves to ID 1; do not treat ID 3 as equivalent silently.

## Updated design consequences

1. Show the admission year, insertion semester and eventual code as read-only context. Search filters can remain selectable; they must not change insertion context. Read the insertion semester specifically from `AdmissionsSemester`.
2. Read the authoritative settings again at save. If the intake changed while the form was open, reject stale context and ask the user to review; do not silently move the application to a different intake.
3. Never hard-code current academic IDs or copy legacy semester 63/66. If `AdmissionYear` or `AdmissionsSemester` is missing or inconsistent, block creation with an actionable configuration message.
4. Use the verified default status keys after validating their existence/enabled state; include student, military and acceptance/enrollment records in one transaction.
5. Egyptian-ID validation must happen server-side as well as in the UI. Define the exact accepted structure, date parsing, nationality lookup and any official code lists before implementation. Validate real dates and ID/date-of-birth consistency; do not invent a checksum. Foreign passports require their own presence/format rules, not Egyptian-ID rules.
6. Replace delete actions with **أرشفة** and **استعادة**. Default lists exclude archived students; an authorized archived view permits restore. Archive preserves the student code and does not release identifiers for reuse.
7. Add approved archive state, actor, UTC timestamp and reason, with audit and concurrency protection. Restoration records its actor/time and revalidates invariants. No cascade deletes or calls to `Students_Delete`.
8. Archive does not imply cancellation of fees, registration or academic history. Agree how records with ongoing transactions are handled and ensure downstream screens consistently honor archive state after cutover.
9. Keep code-generation locking and duplicate protection. The user allows the current database; restrict automated write tests to isolated fixtures with controlled rollback/cleanup and no alteration of real students. Stopping the legacy app at final completion does not eliminate collisions while both applications accept writes; a coordinated allocation/cutover control remains part of implementation planning.

## Remaining decisions

- `AdmissionsSemester` is confirmed as the field for `Students.SemesterId`; its **value is still NULL**. A valid semester must be configured and its `Semesters.YearId` must match `AdmissionYear` before actual student creation can proceed. Selecting or writing that value is an operational configuration change, not part of this planning update.
- Working list proposal: non-archived students in the active admission year, with explicit acceptance/enrollment filters available. Do not silently treat the source of the code year as approval of a new-student status predicate; include this in the final screen review.
- Application implementation is authorized. Execution of schema scripts still requires separate review and approval. Supervisor role assignment and legacy-write cutover must be resolved before enabling writes.

## Prepared review artifact

[Schema proposal](../database/review/001-admissions-support-proposal.sql) defines proposed archive/audit/counter/idempotency storage. It defaults to review-only and has not been executed. It deliberately omits automatic counter seeding, unique-index changes on legacy data, and new foreign keys on legacy lookup columns. Student concurrency and complete-code uniqueness remain documented follow-up decisions before enabling writes.

See [the implementation plan](ADMISSIONS-IMPLEMENTATION-PLAN.md) for the technical scope and acceptance criteria.
