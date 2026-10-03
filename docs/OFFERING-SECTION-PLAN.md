# Offering section plan — for review

**Implementation update, 3 October 2026:** The approved first release has been implemented. See [Offering operations](OFFERING-OPERATIONS.md) for deployment and validation status. The historical planning text below is retained as the decision record.

**3 October 2026. Planning only; no offering data or schema has been changed.**

## Agreed first-release scope

- Manage course offerings and their lecture/child sections in the existing `TeiDB`.
- Use an administrator-set `dbo.ActiveSemesters.OfferingSemester` as the only writable term. For this release, the administrator changes it directly in the database through a reviewed runbook; there will be no SIS term-setting screen. Staff may inspect other terms, but may not choose a different insertion term.
- Leave timetable editing, rooms, time slots, and instructor assignments for a later release. Show existing assignments and enrollment counts as read-only context where useful.
- Arabic-first, right-to-left screens using the existing SIS design and staff Microsoft 365 sign-in. Offering managers may create/edit; only administrators may deactivate unused offerings or sections.

## What the current schema says

| Area | Tables and current use |
| --- | --- |
| Term and course catalog | `dbo.ActiveSemesters.OfferingSemester` is **NULL** today. `dbo.Semesters` has several rows marked active, so its `Active` flag cannot select a unique offering term. Existing courses come from `dbo.Courses`; departments from `dbo.Departments`. Course level points to a department through `dbo.Levels`, but that is not an absolute offering rule in current data. |
| Course offerings | `Offering.OfferedCourses` has 5,928 rows. Each row has `Id`, nullable `CourseId`, `SemesterId`, `DepartmentId`, `AddedDate`, and nullable `Active`. The three lookup columns have foreign keys, but there is no unique `(CourseId, SemesterId, DepartmentId)` index, rowversion, or audit trail. |
| Sections | `Offering.Section` has 7,530 rows with type, name/code, parent, course, term, department, capacity, reserved capacity, schedule capacity, and nullable `IsActive`. In the 2026 terms, lectures (`SectionTypeId=1`) point `ParentId` to themselves and carry `DepartmentId`; child sections (`SectionTypeId=3`) point to a lecture and have `DepartmentId=NULL`. `ParentId` has no foreign key. |
| Optional templates | `Offering.Template` has four definitions; `Offering.CoursesTemplate` has 708 course/term links. Template coverage is partial (39 links in term 66, seven in term 68), so a template cannot be required for every offering. `Offering.SharedCourse` has 12 mappings but does not explain every current cross-department offering. |
| Existing dependencies | `dbo.StudentSection` links students to `Offering.Section`; `Offering.SummerizeScheduale` and `dbo.ScheduleGroupsTerms` also reference sections. The supplied `TEIADMIN` includes an [open-courses report](../TEIADMIN/GetOpenCoursesBySemester.aspx.cs), while advising and grading pages consume offered courses. I did not find an offering-management page in the supplied ASPX source; its exact write workflow needs business confirmation. |

### Data that the new section must handle

The current 2026 terms contain 292 offered rows / 187 sections in semester 66, 257 / 193 in semester 68, and 3 / 3 in semester 69. Term 66 has six duplicate course-term-department groups (seven extra rows); term 68 has five. There are also 117 offered rows without any section in term 66 and 97 in term 68. Conversely, seven sections in term 66 and six in term 68 have no matching offered course by course and term. These should appear as review warnings, not be silently removed.

`Offering.Section.IsActive` is NULL in 7,511 of 7,530 rows, including every section in the three 2026 terms. Per the agreed temporary rule, the SIS will display NULL as active; a later release may revise that interpretation. Historical data includes 11 section rows whose parent does not exist, two whose parent belongs to another course or term, and 66 timetable rows whose semester differs from their section. Also, 28 term-66 offered rows use a department different from the course level's department without a `SharedCourse` mapping. This is allowed and will not be blocked by the new SIS.

`ReservedCapacity` and `ScheduleCapacity` participate in existing registration/advising calculations. They are outside this release's UI and API editing scope and must be left unchanged by offering/section edits. New-section compatibility with those calculations must be verified before writes are opened to staff.

### Agreed section-code generation

Keep the legacy-style display: a lecture code is the course's Arabic code plus a running number (for example, `همد 407-22`); a child code adds a number to its parent lecture code (for example, `همد 407-22-1`). The new SIS assigns the final code inside the create transaction; staff cannot enter or override it. Lecture `SectionName` will follow the generated code, while child sections retain the current convention of displaying `SectionCode` with `SectionName=NULL` unless a later review changes that rule.

Introduce reviewed counters keyed by the Arabic course-code prefix for lectures and by parent `SectionId` for children. Seed them once from all relevant legacy codes while writes are stopped, record the reviewed seed values, then allocate each number with an atomic counter update in the same transaction as the section insert. Do not calculate a new code with `MAX + 1` during normal requests. Validate the final code against other sections in the term and retry allocation within a bounded transaction if it collides. Reject new section creation when the course has no usable Arabic code or the generated value exceeds the existing 50-character `SectionCode` limit.

The seed must be reviewed rather than inferred blindly: 4,230 of 4,249 self-parent lecture codes have a numeric trailing suffix, while 19 do not. All 3,281 child codes have a numeric suffix, but 11 do not start with the exact current parent code (some parents are missing). Exact `SectionCode` values repeat across historical terms, and 77 Arabic course-code values are shared by multiple course records. Historical codes remain unchanged; the migration should report exceptions and avoid imposing a unique index until those records are resolved.

## Proposed staff experience

1. **Offering overview.** Show the administrator-set term prominently, with a clear setup message and disabled create actions while `OfferingSemester` is unset. Search by course code/Arabic name; filter by department, active state, section coverage, and records needing review. Display course, department, section count, ordinary `Capacity`, actual student registrations from `dbo.StudentSection`, and warnings. Permit read-only browsing of historical terms.
2. **Add an offering.** Choose an existing course and any department, including one outside the course level's department; show course code, name, credit hours, level, and existing offerings before save. The term is read-only and comes from `OfferingSemester`. New records use `Active=1`. Reject a new duplicate course-term-department combination even though historical duplicates remain visible for review. Do not edit the course catalog here.
3. **Offering detail.** Show the offering and sections as a hierarchy: lectures first, child sections beneath their parent. Display section type, generated code/name, ordinary `Capacity`, actual registrations, and whether schedule data exists. Treat legacy `IsActive=NULL` as active for display. Show template information as guidance only; do not generate sections automatically in the first iteration.
4. **Add/edit sections.** Create a lecture first, then optionally create child sections under a lecture of the same course and term. Preserve the existing parent convention in one database transaction. The SIS generates the legacy-style section code on save; staff cannot edit it, and any pre-save preview is only illustrative. Validate positive ordinary `Capacity`, no new code collision in the term, and parent consistency. Do not expose or change `ReservedCapacity` or `ScheduleCapacity`. Changing a section's course/term/parent after registrations or schedules exist should be blocked. New rows use `IsActive=1`; existing NULL values remain unchanged.
5. **Deactivate instead of delete by default.** Only an administrator may deactivate an unused offering or section after checking registrations, timetable rows, and other references. An offering with sections must have those sections safely deactivated first or be rejected. Deactivation sets `Active`/`IsActive` to `0`; it never physically removes dependent records. Existing duplicate rows should be reviewed individually before any cleanup.

## Proposed implementation sequence after plan approval

1. **Read-only API and page:** join the existing tables, expose term context and lookup lists, build overview/detail pages, and show data-quality warnings. Interpret legacy `IsActive=NULL` as active in this release without rewriting old rows.
2. **Reviewed database changes:** prepare migration scripts and a backup plan. Add optimistic concurrency tokens to offering and section rows, an audit table for create/update/deactivate operations, reviewed lecture/child code counters, and query indexes for term/department/course. New offering writes must be serialized against the course-term-department key; do **not** add a global unique index or parent foreign key until historical duplicates and invalid parents are reviewed. Keep existing names and IDs used by advising and grading. An administrator sets `OfferingSemester` directly in `dbo.ActiveSemesters` after checking that exactly one active-settings row and a valid visible semester exist.
3. **Write API and forms:** transactional create/edit/deactivate with server-side validation, authenticated actor and audit entry, concurrency checks, generated section codes, and a separate `Offering:WritesEnabled` gate. Proposed roles: `SIS.Staff` can read; `Offering.Manager` can create/edit; an administrator role can deactivate. Map these to Entra app roles/groups before write rollout. No fallback to `AdmissionsSemester`.
4. **Verification:** test term gating, duplicate prevention under simultaneous requests, generated-code uniqueness, lecture-child creation, concurrent edits, dependency blocks, historical read-only browsing, Arabic RTL layout, and unchanged advising/report reads. Confirm that new sections remain compatible with registration/advising calculations without this module editing `ReservedCapacity` or `ScheduleCapacity`. Test write paths on controlled records before general staff use.
5. **Later phase:** timetable, rooms, time segments, instructor assignments, collision checks, and template-driven bulk generation after those workflows are specified.

## Remaining rollout details

1. **Initial active term:** The administrator must choose a valid `SemesterId` and place it in `OfferingSemester` before write rollout. It is NULL today; no term has been assumed or changed.
2. **Child department storage:** The current child-section convention is `DepartmentId=NULL`, inherited for display from the parent lecture. The proposed writes preserve that convention and will be checked against advising behavior before rollout.
3. **Entra authorization:** Map the agreed administrator-only deactivation policy to an actual Entra app role or group, and assign offering-manager access for create/edit.

**Historical note:** this plan originally required implementation approval. Approval was given afterward; the implementation and database cutover status are documented in [Offering operations](OFFERING-OPERATIONS.md).
