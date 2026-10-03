# TeiDB initial access and schema assessment

Inspected 26 September 2026 using Windows integrated authentication. Connection succeeded under the Windows account owning LocalDB; the isolated sandbox account could not reach that user's instance.

```text
Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=TeiDB;Integrated Security=True;Persist Security Info=False;
```

This connection string is saved as `ConnectionStrings:TeiDB` in the gitignored backend `appsettings.Local.json`. This prepares configuration only: API data access and dashboard database integration are not implemented yet.

## Verified metadata

| Property | Result |
|---|---|
| Instance | `(localdb)\MSSQLLocalDB` |
| Database | `TeiDB`, ONLINE |
| Server product version | `17.0.4025.3` |
| Database compatibility level | `100` |
| Collation | `Arabic_CI_AS` |
| User tables | 309 |
| Tables without a declared primary key | 115 |
| Declared foreign keys | 56 |
| Disabled or untrusted foreign keys | 0 |
| Views | 144 |
| Stored procedures | 715 |
| Scalar / inline table-valued functions | 35 / 1 |
| SQL triggers | 4 |

Schemas: `dbo` (264 tables), `Acccounting` (21; spelling as stored), `Offering` (16), and `Survey` (8).

## Initial module mapping candidates

These are candidates based on table/column metadata and declared keys; current business usage has not been confirmed.

| SIS area | Existing candidate tables |
|---|---|
| Admissions | `dbo.NewStudents`, `dbo.StudentsAcceptance`, `dbo.AcceptanceTypes`, `dbo.StudentsDocuments` |
| Student records | `dbo.Students`, `dbo.StudentsContacts`, `dbo.Students_Enrollment_Status` |
| Registration | `dbo.StudentsAdvising`, `dbo.StudentAdvising_Terms`, `dbo.StudentSection` |
| Course catalog | `dbo.Courses`, `dbo.Departments` |
| Curriculum configuration | `Offering.Template`, `Offering.CoursesTemplate`, `dbo.EducationConfig`, `dbo.MainCoursesGuide` |
| Academic periods / course offerings | `dbo.Years`, `dbo.Semesters`, `Offering.OfferedCourses` |

Verified relationships include `StudentsAdvising` to `Courses`, `Semesters`, and `Years`; `StudentSection` to `StudentsAdvising`; `StudentAdvising_Terms` to `Students`; and `CoursesTemplate` to `Template`, `Courses`, and `Semesters`.

## Implications for the integration phase

- There are many dated, backup-style and spreadsheet-style table names. Confirm the active sources before creating entity mappings or counts.
- Some relationships may exist only in application logic; this inspection does not prove that the 56 declared foreign keys describe every relationship.
- `dbo.Employees` and `dbo.MainCoursesGuide` are among the tables without declared primary keys. Determine intended keys and duplicates before enabling updates; do not invent keys from naming alone.
- Review the relevant stored procedures and triggers before writing new workflows, because they may contain existing validation and calculation rules. Their bodies were not read or executed during this inspection.
- Account for compatibility level 100 when selecting/configuring a SQL data provider. No compatibility or schema changes were made.
- The backend must run under an account with access to this LocalDB instance. A hosted deployment will need its own confirmed SQL Server endpoint and service identity.
- Legacy identity tables are present. Their contents were not accessed. Staff authentication remains Microsoft Entra SSO.

## Reproduce the inspection

Run `scripts/inspect-database.ps1` under the Windows account owning the LocalDB instance. It only executes catalog metadata queries and writes `.reference/teidb-schema.json`, which is excluded from source control. The export contains table/column types, primary keys, foreign keys and object names; no student records, user credentials or procedure bodies.

No database records, objects, permissions, compatibility settings or schema definitions were changed. No application-row samples were retrieved.
