/* GEI SIS Offering cutover. Run only against the verified TeiDB after backup.
   This script is intentionally one-time: rerunning fails instead of reseeding counters. */
SET NOCOUNT ON;
SET XACT_ABORT ON;
IF DB_NAME() <> N'TeiDB' THROW 52000, 'Expected TeiDB.', 1;
IF (SELECT COUNT(*) FROM dbo.ActiveSemesters) <> 1 THROW 52001, 'Expected one ActiveSemesters row.', 1;
IF NOT EXISTS (SELECT 1 FROM dbo.Semesters WHERE SemesterId=66 AND ISNULL(Hide,0)=0)
    THROW 52002, 'Semester 66 is not a visible semester.', 1;
IF OBJECT_ID(N'sis.OfferingLectureCounter',N'U') IS NOT NULL
 OR OBJECT_ID(N'sis.OfferingChildCounter',N'U') IS NOT NULL
 OR OBJECT_ID(N'sis.OfferingAudit',N'U') IS NOT NULL
 OR COL_LENGTH(N'Offering.OfferedCourses',N'SisVersion') IS NOT NULL
 OR COL_LENGTH(N'Offering.Section',N'SisVersion') IS NOT NULL
    THROW 52003, 'Offering support already exists; inspect rather than reseed.', 1;

BEGIN TRY
 BEGIN TRANSACTION;
 ALTER TABLE Offering.OfferedCourses ADD SisVersion rowversion NOT NULL;
 ALTER TABLE Offering.Section ADD SisVersion rowversion NOT NULL;

 CREATE TABLE sis.OfferingLectureCounter (
   Prefix nvarchar(50) NOT NULL CONSTRAINT PK_OfferingLectureCounter PRIMARY KEY,
   LastAllocated int NOT NULL CONSTRAINT CK_OfferingLectureCounter_Positive CHECK (LastAllocated >= 0)
 );
 CREATE TABLE sis.OfferingChildCounter (
   ParentSectionId int NOT NULL CONSTRAINT PK_OfferingChildCounter PRIMARY KEY,
   LastAllocated int NOT NULL CONSTRAINT CK_OfferingChildCounter_Positive CHECK (LastAllocated >= 0)
 );
 CREATE TABLE sis.OfferingAudit (
   AuditId bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_OfferingAudit PRIMARY KEY,
   EntityType varchar(20) NOT NULL,
   EntityId int NOT NULL,
   ActionName varchar(20) NOT NULL,
   OccurredAtUtc datetime2(7) NOT NULL CONSTRAINT DF_OfferingAudit_Time DEFAULT SYSUTCDATETIME(),
   ActorTenantId uniqueidentifier NOT NULL,
   ActorObjectId uniqueidentifier NOT NULL,
   PreviousVersion varbinary(8) NULL,
   NewVersion varbinary(8) NULL,
   CONSTRAINT CK_OfferingAudit_Entity CHECK (EntityType IN ('Offering','Section')),
   CONSTRAINT CK_OfferingAudit_Action CHECK (ActionName IN ('Create','Update','Deactivate'))
 );
 CREATE INDEX IX_OfferingAudit_Entity ON sis.OfferingAudit(EntityType,EntityId,OccurredAtUtc);
 CREATE INDEX IX_OfferedCourses_TermDepartmentCourse ON Offering.OfferedCourses(SemesterId,DepartmentId,CourseId) INCLUDE (Active);
 CREATE INDEX IX_OfferingSection_TermCourse ON Offering.Section(SemesterId,CourseId,ParentId) INCLUDE (SectionCode,IsActive,Capacity);

 /* Seed from every parseable historical lecture/child code while writes are stopped.
    Non-numeric anomalies are reported separately; final allocation checks collisions. */
 ;WITH LectureCodes AS (
   SELECT LEFT(SectionCode,LEN(SectionCode)-CHARINDEX(N'-',REVERSE(SectionCode))) AS Prefix,
          RIGHT(SectionCode,CHARINDEX(N'-',REVERSE(SectionCode))-1) AS Suffix
   FROM Offering.Section
   WHERE ParentId=SectionId AND SectionCode IS NOT NULL AND CHARINDEX(N'-',SectionCode)>0
 )
 INSERT sis.OfferingLectureCounter(Prefix,LastAllocated)
 SELECT Prefix,MAX(CAST(Suffix AS int)) FROM LectureCodes
 WHERE Prefix<>N'' AND LEN(Prefix)<=50 AND LEN(Suffix) BETWEEN 1 AND 9
   AND Suffix COLLATE Latin1_General_BIN2 NOT LIKE N'%[^0-9]%'
 GROUP BY Prefix;

 ;WITH ChildCodes AS (
   SELECT ParentId, RIGHT(SectionCode,CHARINDEX(N'-',REVERSE(SectionCode))-1) AS Suffix
   FROM Offering.Section
   WHERE ParentId IS NOT NULL AND ParentId<>SectionId AND SectionCode IS NOT NULL
     AND CHARINDEX(N'-',SectionCode)>0
 )
 INSERT sis.OfferingChildCounter(ParentSectionId,LastAllocated)
 SELECT ParentId,MAX(CAST(Suffix AS int)) FROM ChildCodes
 WHERE LEN(Suffix) BETWEEN 1 AND 9
   AND Suffix COLLATE Latin1_General_BIN2 NOT LIKE N'%[^0-9]%'
 GROUP BY ParentId;

 UPDATE dbo.ActiveSemesters SET OfferingSemester=66 WHERE OfferingSemester IS NULL;
 IF (SELECT OfferingSemester FROM dbo.ActiveSemesters)<>66
    THROW 52004, 'OfferingSemester was already set to another term.', 1;
 COMMIT TRANSACTION;
END TRY
BEGIN CATCH
 IF XACT_STATE()<>0 ROLLBACK TRANSACTION;
 THROW;
END CATCH;

SELECT (SELECT COUNT(*) FROM sis.OfferingLectureCounter) AS LectureCounterPrefixes,
       (SELECT COUNT(*) FROM sis.OfferingChildCounter) AS ChildCounterParents,
       (SELECT OfferingSemester FROM dbo.ActiveSemesters) AS ActiveOfferingSemester;
