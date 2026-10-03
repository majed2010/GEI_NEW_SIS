# Read-only integration checks for the existing TeiDB admissions tables.
param([string]$ConnectionString = 'Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=TeiDB;Integrated Security=True;Connect Timeout=15;Application Name=GEI SIS Admissions Read Smoke')
$ErrorActionPreference = 'Stop'
$connection = [System.Data.SqlClient.SqlConnection]::new($ConnectionString)
function Test-Query([string]$Name, [string]$Sql) {
    $command = $connection.CreateCommand()
    $command.CommandText = $Sql
    $command.CommandTimeout = 30
    try {
        $reader = $command.ExecuteReader()
        try { $count = 0; while ($reader.Read()) { $count++ }; "$Name : $count row(s)" }
        finally { $reader.Dispose() }
    } finally { $command.Dispose() }
}
try {
    $connection.Open()
    Test-Query 'Context' 'SELECT TOP (2) a.Id,a.AdmissionYear,y.YearName,y.ActualYear,a.AdmissionsSemester,s.ArSemesterName,s.YearId AS SemesterYearId,s.Hide AS SemesterHidden FROM dbo.ActiveSemesters a LEFT JOIN dbo.Years y ON y.YearId=a.AdmissionYear LEFT JOIN dbo.Semesters s ON s.SemesterId=a.AdmissionsSemester ORDER BY a.Id'
    Test-Query 'Locations' 'SELECT TOP (5) LocationId,dbo.GetArLocationName(LocationId) AS Label,Hide FROM dbo.Locations ORDER BY LocationId'
    Test-Query 'Enrollment' 'SELECT TOP (5) Id,Student_Enrollment_Status_Name FROM dbo.Students_Enrollment_Status ORDER BY Id'
    Test-Query 'Search' "WITH Results AS (SELECT s.StudentId,s.StudentCode,s.FullName,ROW_NUMBER() OVER (ORDER BY StudentId DESC) AS RowNumber FROM dbo.Students s OUTER APPLY (SELECT TOP (1) a.AcceptanceId,a.EnrollmentId FROM dbo.StudentsAcceptance a WHERE a.StudentId=s.StudentId ORDER BY a.Id DESC) acc LEFT JOIN dbo.AcceptanceTypes at ON at.AcceptanceId=acc.AcceptanceId LEFT JOIN dbo.Students_Enrollment_Status es ON es.Id=acc.EnrollmentId) SELECT TOP (2) * FROM Results ORDER BY RowNumber"
    'All read-only admissions checks passed.'
} finally { $connection.Dispose() }
