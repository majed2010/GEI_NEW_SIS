param(
    [string]$ConnectionString = 'Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=TeiDB;Integrated Security=True;Persist Security Info=False;Connect Timeout=30;Application Name=GEI SIS Offering Cutover'
)
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$backupDirectory = Join-Path $root 'database\backups'
$backupPath = Join-Path $backupDirectory ('TeiDB-before-offering-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '.bak')
if (-not (Test-Path -LiteralPath $backupDirectory)) { [void](New-Item -ItemType Directory -Path $backupDirectory) }
$connection = New-Object System.Data.SqlClient.SqlConnection $ConnectionString
try {
    $connection.Open()
    $command = $connection.CreateCommand()
    $command.CommandTimeout = 0
    $command.CommandText = "BACKUP DATABASE [TeiDB] TO DISK = @path WITH COPY_ONLY, INIT, CHECKSUM"
    [void]$command.Parameters.Add('@path',[System.Data.SqlDbType]::NVarChar,4000)
    $command.Parameters['@path'].Value = $backupPath
    [void]$command.ExecuteNonQuery()
    $command.Parameters.Clear()
    $command.CommandText = 'RESTORE VERIFYONLY FROM DISK = @path WITH CHECKSUM'
    [void]$command.Parameters.Add('@path',[System.Data.SqlDbType]::NVarChar,4000)
    $command.Parameters['@path'].Value = $backupPath
    [void]$command.ExecuteNonQuery()
    Write-Output "Verified backup: $backupPath"
    $command.Parameters.Clear()
    $command.CommandText = [IO.File]::ReadAllText((Join-Path $root 'database\003-offering-support.sql'),[Text.Encoding]::UTF8)
    [void]$command.ExecuteNonQuery()
    $command.CommandText = "SELECT OfferingSemester FROM dbo.ActiveSemesters"
    Write-Output ('OfferingSemester: ' + $command.ExecuteScalar())
    Write-Output 'Offering support migration completed.'
} finally { if ($command) { $command.Dispose() }; $connection.Dispose() }
