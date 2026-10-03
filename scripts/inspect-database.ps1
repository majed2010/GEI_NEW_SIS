param(
    [string]$ConnectionString = 'Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=TeiDB;Integrated Security=True;Persist Security Info=False;Connect Timeout=15;Application Name=GEI SIS Schema Inspection'
)
$ErrorActionPreference = 'Stop'
$connection = New-Object System.Data.SqlClient.SqlConnection $ConnectionString
function Read-Metadata([string]$Sql) {
    $command = $connection.CreateCommand()
    $command.CommandTimeout = 30
    $command.CommandText = $Sql
    $reader = $command.ExecuteReader()
    try {
        while ($reader.Read()) {
            $row = [ordered]@{}
            for ($i = 0; $i -lt $reader.FieldCount; $i++) {
                $row[$reader.GetName($i)] = if ($reader.IsDBNull($i)) { $null } else { $reader.GetValue($i) }
            }
            [pscustomobject]$row
        }
    } finally { $reader.Dispose(); $command.Dispose() }
}
try {
    $connection.Open()
    # Catalog metadata only: no application records, credentials or procedure bodies.
    $inventory = [ordered]@{
        InspectedAt = [DateTime]::UtcNow.ToString('o')
        Database = @(Read-Metadata "SELECT name, compatibility_level, collation_name, state_desc, is_read_only FROM sys.databases WHERE database_id = DB_ID()")
        Tables = @(Read-Metadata "SELECT s.name AS SchemaName, t.name AS TableName, (SELECT COUNT(*) FROM sys.columns c WHERE c.object_id = t.object_id) AS ColumnCount, CAST(CASE WHEN EXISTS (SELECT 1 FROM sys.indexes i WHERE i.object_id=t.object_id AND i.is_primary_key=1) THEN 1 ELSE 0 END AS bit) AS HasPrimaryKey FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id WHERE t.is_ms_shipped=0 ORDER BY s.name,t.name")
        Columns = @(Read-Metadata "SELECT s.name AS SchemaName, t.name AS TableName, c.column_id AS Ordinal, c.name AS ColumnName, ty.name AS DataType, c.max_length AS MaxLengthBytes, c.precision AS NumericPrecision, c.scale AS NumericScale, c.is_nullable AS IsNullable, c.is_identity AS IsIdentity, c.is_computed AS IsComputed FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id JOIN sys.columns c ON c.object_id=t.object_id JOIN sys.types ty ON ty.user_type_id=c.user_type_id WHERE t.is_ms_shipped=0 ORDER BY s.name,t.name,c.column_id")
        PrimaryKeys = @(Read-Metadata "SELECT s.name AS SchemaName, t.name AS TableName, i.name AS KeyName, c.name AS ColumnName, ic.key_ordinal AS KeyOrdinal FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id JOIN sys.indexes i ON i.object_id=t.object_id AND i.is_primary_key=1 JOIN sys.index_columns ic ON ic.object_id=i.object_id AND ic.index_id=i.index_id JOIN sys.columns c ON c.object_id=ic.object_id AND c.column_id=ic.column_id ORDER BY s.name,t.name,ic.key_ordinal")
        ForeignKeys = @(Read-Metadata "SELECT fk.name AS KeyName, OBJECT_SCHEMA_NAME(fk.parent_object_id) AS SourceSchema, OBJECT_NAME(fk.parent_object_id) AS SourceTable, pc.name AS SourceColumn, OBJECT_SCHEMA_NAME(fk.referenced_object_id) AS TargetSchema, OBJECT_NAME(fk.referenced_object_id) AS TargetTable, rc.name AS TargetColumn, fkc.constraint_column_id AS KeyOrdinal, fk.is_disabled AS IsDisabled, fk.is_not_trusted AS IsNotTrusted FROM sys.foreign_keys fk JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id=fk.object_id JOIN sys.columns pc ON pc.object_id=fkc.parent_object_id AND pc.column_id=fkc.parent_column_id JOIN sys.columns rc ON rc.object_id=fkc.referenced_object_id AND rc.column_id=fkc.referenced_column_id ORDER BY SourceSchema,SourceTable,KeyName,KeyOrdinal")
        OtherObjects = @(Read-Metadata "SELECT SCHEMA_NAME(schema_id) AS SchemaName, name AS ObjectName, type_desc AS ObjectType FROM sys.objects WHERE is_ms_shipped=0 AND type IN ('V','P','FN','IF','TF','TR') ORDER BY type_desc,SchemaName,ObjectName")
    }
    $root = Split-Path $PSScriptRoot -Parent
    $outputDirectory = Join-Path $root '.reference'
    [void](New-Item -ItemType Directory -Force $outputDirectory)
    $outputPath = Join-Path $outputDirectory 'teidb-schema.json'
    $inventory | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 $outputPath
    $inventory.Database | Format-Table -AutoSize | Out-String | Write-Output
    $inventory.Tables | Group-Object SchemaName | Select-Object Name,Count | Format-Table -AutoSize | Out-String | Write-Output
    Write-Output ('Tables: ' + $inventory.Tables.Count)
    Write-Output ('Tables without primary keys: ' + @($inventory.Tables | Where-Object { -not $_.HasPrimaryKey }).Count)
    Write-Output ('Foreign keys: ' + @($inventory.ForeignKeys | Select-Object SourceSchema,SourceTable,KeyName -Unique).Count)
    Write-Output ('Disabled or untrusted foreign keys: ' + @($inventory.ForeignKeys | Where-Object { $_.IsDisabled -or $_.IsNotTrusted } | Select-Object SourceSchema,SourceTable,KeyName -Unique).Count)
    $inventory.OtherObjects | Group-Object ObjectType | Select-Object Name,Count | Format-Table -AutoSize | Out-String | Write-Output
    Write-Output ('Metadata saved to: ' + $outputPath)
} finally { $connection.Dispose() }
