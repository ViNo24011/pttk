param(
    [string]$MySql = 'C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe',
    [switch]$Seed
)
$ErrorActionPreference = 'Stop'
$projectDir = Split-Path -Parent $PSScriptRoot
$config = @{}
foreach ($line in Get-Content -LiteralPath (Join-Path $projectDir 'config\database.properties') -Encoding UTF8) {
    if ($line -match '^db\.[^=]+=') { $pair = $line.Split('=', 2); $config[$pair[0]] = $pair[1] }
}
$url = [uri]($config['db.url'] -replace '^jdbc:', '')
if ($url.AbsolutePath -ne '/qlst_dienmay') { throw 'SQL scripts target qlst_dienmay. Check db.url before running.' }
$oldPassword = $env:MYSQL_PWD
try {
    $env:MYSQL_PWD = $config['db.password']
    $baseArgs = @('--default-character-set=utf8mb4', '--connect-timeout=5', '-h', $url.Host, '-P', $url.Port, '-u', $config['db.user'])
    $schemaPath = (Join-Path $projectDir 'docs\01_create_database.sql').Replace('\','/')
    & $MySql @baseArgs --execute="source $schemaPath"
    if ($LASTEXITCODE -ne 0) { throw 'Could not create database schema.' }
    if ($Seed) {
        $seedPath = (Join-Path $projectDir 'docs\02_seed_data.sql').Replace('\','/')
        & $MySql @baseArgs --execute="source $seedPath"
        if ($LASTEXITCODE -ne 0) { throw 'Could not seed data. Existing data was not overwritten.' }
    }
    & $MySql @baseArgs --execute="SELECT COUNT(*) AS table_count FROM information_schema.tables WHERE table_schema='qlst_dienmay'; SELECT COUNT(*) AS customers FROM qlst_dienmay.tblCustomer;"
    if ($LASTEXITCODE -ne 0) { throw 'Database verification failed.' }
} finally { $env:MYSQL_PWD = $oldPassword }
