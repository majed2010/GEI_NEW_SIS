/*
GEI SIS admissions support schema — DRAFT FOR REVIEW ONLY.
Not executed. Preparation approval is not execution approval.

This proposes support tables and a rowversion on Students. It does not
change existing records, academic configuration, or seed numbering counters.

Outstanding before writes can be enabled:
- ActiveSemesters.AdmissionsSemester is the authoritative insertion field;
  configure a valid value linked to AdmissionYear before enabling creation.
- Profile student-code duplicates and approve global unique enforcement.
- Review child-table concurrency with other writers during cutover.
- Coordinate numbering with every enabled legacy writer.
- Validate archive filtering across downstream workflows.
- Review audit/idempotency retention and access permissions.
*/
SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @ApplyReviewedProposal bit = 0;
IF @ApplyReviewedProposal = 0
BEGIN
    PRINT 'REVIEW ONLY: no schema changes made. Execution requires separate approval.';
    RETURN;
END;

IF DB_NAME() <> N'TeiDB'
    THROW 51000, 'This proposal targets TeiDB. Review the database target before execution.', 1;
IF OBJECT_ID(N'dbo.Students', N'U') IS NULL
    THROW 51001, 'Expected dbo.Students table is missing.', 1;
IF COL_LENGTH(N'dbo.Students', N'SisVersion') IS NOT NULL
    THROW 51003, 'Students.SisVersion already exists. Inspect before execution.', 1;
IF OBJECT_ID(N'sis.StudentLifecycle') IS NOT NULL
   OR OBJECT_ID(N'sis.AdmissionsAudit') IS NOT NULL
   OR OBJECT_ID(N'sis.StudentCodeCounter') IS NOT NULL
   OR OBJECT_ID(N'sis.AdmissionsCreateRequest') IS NOT NULL
    THROW 51002, 'A proposed object already exists. Inspect it; do not overwrite or assume equivalence.', 1;

BEGIN TRY
    BEGIN TRANSACTION;
    IF SCHEMA_ID(N'sis') IS NULL EXEC(N'CREATE SCHEMA sis AUTHORIZATION dbo;');

    -- Optimistic concurrency token for edits to the main student record.
    ALTER TABLE dbo.Students ADD SisVersion rowversion NOT NULL;

    -- Absence of a lifecycle row means active for legacy students.
    -- RowVersion here protects archive state, not Students/child-table edits.
    CREATE TABLE sis.StudentLifecycle (
        StudentId int NOT NULL CONSTRAINT PK_SisStudentLifecycle PRIMARY KEY,
        IsArchived bit NOT NULL,
        ChangedAtUtc datetime2(7) NOT NULL,
        ChangedByTenantId uniqueidentifier NOT NULL,
        ChangedByObjectId uniqueidentifier NOT NULL,
        Reason nvarchar(1000) NOT NULL,
        Version rowversion NOT NULL,
        CONSTRAINT FK_SisStudentLifecycle_Students FOREIGN KEY (StudentId)
            REFERENCES dbo.Students(StudentId)
    );

    -- No student FK: historical audit must survive changes to legacy records.
    -- Do not log raw national IDs/passports or full profile snapshots here.
    CREATE TABLE sis.AdmissionsAudit (
        AuditId bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_SisAdmissionsAudit PRIMARY KEY,
        StudentId int NOT NULL,
        ActionName varchar(20) NOT NULL,
        OccurredAtUtc datetime2(7) NOT NULL,
        ActorTenantId uniqueidentifier NOT NULL,
        ActorObjectId uniqueidentifier NOT NULL,
        CorrelationId uniqueidentifier NOT NULL,
        Reason nvarchar(1000) NULL,
        ChangedFieldNames nvarchar(2000) NULL,
        CONSTRAINT CK_SisAdmissionsAudit_Action CHECK (ActionName IN ('Create','Update','Archive','Restore'))
    );
    CREATE INDEX IX_SisAdmissionsAudit_StudentTime
        ON sis.AdmissionsAudit(StudentId, OccurredAtUtc);

    -- No automatic seed: validate legacy codes and initialize under a controlled
    -- cutover lock. Allocations must update this row atomically, not read MAX.
    CREATE TABLE sis.StudentCodeCounter (
        YearPrefix varchar(4) NOT NULL CONSTRAINT PK_SisStudentCodeCounter PRIMARY KEY,
        LastAllocated int NOT NULL,
        CONSTRAINT CK_SisStudentCodeCounter_Range CHECK (LastAllocated BETWEEN 0 AND 9999),
        CONSTRAINT CK_SisStudentCodeCounter_Prefix CHECK
            (DATALENGTH(YearPrefix) = 4 AND YearPrefix COLLATE Latin1_General_BIN2 NOT LIKE '%[^0-9]%')
    );

    -- Insert/reserve and complete within the same transaction as student/audit.
    -- Compare RequestHash on retries; never persist student payloads here.
    CREATE TABLE sis.AdmissionsCreateRequest (
        TenantId uniqueidentifier NOT NULL,
        ActorObjectId uniqueidentifier NOT NULL,
        RequestKey uniqueidentifier NOT NULL,
        RequestHash binary(32) NOT NULL,
        StudentId int NULL,
        CreatedAtUtc datetime2(7) NOT NULL,
        CompletedAtUtc datetime2(7) NULL,
        CONSTRAINT PK_SisAdmissionsCreateRequest PRIMARY KEY (TenantId, ActorObjectId, RequestKey),
        CONSTRAINT CK_SisAdmissionsCreateRequest_Completion CHECK
            ((StudentId IS NULL AND CompletedAtUtc IS NULL) OR
             (StudentId IS NOT NULL AND CompletedAtUtc IS NOT NULL))
    );

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
