/*
GEI SIS admissions cutover — DRAFT FOR REVIEW ONLY. Do not execute yet.

Prerequisites: TEIADMIN student writes are stopped; proposal 001 has been
reviewed/applied; one ActiveSemesters row has a valid AdmissionsSemester
belonging to AdmissionYear; supervisor access has been assigned in Entra.

The operator must set the observed ActualYear prefix and the last already
used four-digit suffix just before cutover. This one-time seed is not a
student-code allocator. New allocations use an atomic counter UPDATE.

Read-only observation on 1 October 2026: 4,687 Students codes were unique.
The active year changed during review to prefix 2026; no existing code
matched the 2026 + four-digit pattern at the latest check. Recheck at
cutover. No sequence value is assumed by this draft.
*/
SET NOCOUNT ON;
SET XACT_ABORT ON;
DECLARE @ApplyReviewedCutover bit = 0;
DECLARE @ExpectedPrefix varchar(4) = NULL;  -- Set after fresh review
DECLARE @LastAllocated int = NULL;           -- Set after fresh review
IF @ApplyReviewedCutover = 0
BEGIN
    PRINT 'REVIEW ONLY: no schema or data changes made.';
    RETURN;
END;
IF DB_NAME() <> N'TeiDB' THROW 51100, 'Expected TeiDB.', 1;
IF @ExpectedPrefix IS NULL OR @ExpectedPrefix NOT LIKE '[0-9][0-9][0-9][0-9]'
    THROW 51101, 'Set a reviewed four-digit ActualYear prefix.', 1;
IF @LastAllocated IS NULL OR @LastAllocated NOT BETWEEN 0 AND 9999
    THROW 51102, 'Set a reviewed last allocated suffix.', 1;
IF OBJECT_ID(N'sis.StudentCodeCounter',N'U') IS NULL OR COL_LENGTH(N'dbo.Students',N'SisVersion') IS NULL
    THROW 51103, 'Apply and verify reviewed support schema first.', 1;
IF EXISTS (SELECT StudentCode FROM dbo.Students GROUP BY StudentCode HAVING COUNT_BIG(1)>1)
    THROW 51104, 'Duplicate student codes exist; resolve before global uniqueness.', 1;
IF EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID(N'dbo.Students') AND name=N'UX_SisStudents_StudentCode')
    THROW 51105, 'Student code index already exists; inspect before retry.', 1;

BEGIN TRY
    BEGIN TRANSACTION;
    DECLARE @ActualPrefix varchar(4), @ObservedLast int;
    SELECT TOP (1) @ActualPrefix=y.ActualYear
      FROM dbo.ActiveSemesters a WITH (UPDLOCK,HOLDLOCK)
      JOIN dbo.Years y ON y.YearId=a.AdmissionYear;
    IF (SELECT COUNT_BIG(1) FROM dbo.ActiveSemesters)<>1 OR @ActualPrefix<>@ExpectedPrefix
        THROW 51106, 'Active admission year differs from reviewed prefix.', 1;
    IF NOT EXISTS (SELECT 1 FROM dbo.ActiveSemesters a JOIN dbo.Semesters s
        ON s.SemesterId=a.AdmissionsSemester AND s.YearId=a.AdmissionYear AND s.Hide=0)
        THROW 51107, 'Valid admissions semester is not configured.', 1;

    SELECT @ObservedLast=MAX(CONVERT(int,RIGHT(StudentCode,4)))
      FROM dbo.Students WITH (TABLOCKX,HOLDLOCK)
      WHERE StudentCode LIKE @ExpectedPrefix+'[0-9][0-9][0-9][0-9]';
    IF @LastAllocated < ISNULL(@ObservedLast,0)
        THROW 51108, 'Seed is lower than an existing student code.', 1;
    IF EXISTS (SELECT 1 FROM sis.StudentCodeCounter WHERE YearPrefix=@ExpectedPrefix)
        THROW 51109, 'Counter for this year already exists; inspect before retry.', 1;

    CREATE UNIQUE INDEX UX_SisStudents_StudentCode ON dbo.Students(StudentCode);
    INSERT sis.StudentCodeCounter(YearPrefix,LastAllocated) VALUES(@ExpectedPrefix,@LastAllocated);
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE()<>0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
