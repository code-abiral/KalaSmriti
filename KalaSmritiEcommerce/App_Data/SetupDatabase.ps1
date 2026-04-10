# KalaSmriti E-Commerce MDF setup script
Write-Host "=== KalaSmriti E-Commerce MDF Setup ===" -ForegroundColor Cyan
Write-Host ""

$skipPause = $false
if ($env:SKIP_PAUSE -eq '1' -or $env:SKIP_PAUSE -eq 'true') {
    $skipPause = $true
}

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $scriptPath
$webConfigPath = Join-Path $projectRoot "Web.config"
$mdfPath = Join-Path $scriptPath "KalaSmriti.mdf"
$connectionString = 'Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\KalaSmriti.mdf;Integrated Security=True;Connect Timeout=30;MultipleActiveResultSets=True'

[AppDomain]::CurrentDomain.SetData('DataDirectory', $scriptPath)

function Pause-IfNeeded {
    if (-not $skipPause) {
        pause
    }
}

if (-not (Get-Command sqllocaldb -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: sqllocaldb was not found. Install SQL Server LocalDB first." -ForegroundColor Red
    Pause-IfNeeded
    exit 1
}

if (-not (Get-Command sqlcmd -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: sqlcmd was not found. Install SQL Server command-line tools first." -ForegroundColor Red
    Pause-IfNeeded
    exit 1
}

Write-Host "Checking LocalDB..." -ForegroundColor Yellow
$instanceInfo = & sqllocaldb info MSSQLLocalDB 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: MSSQLLocalDB is not available." -ForegroundColor Red
    Write-Host $instanceInfo
    Pause-IfNeeded
    exit 1
}

if ($instanceInfo -notmatch 'State:\s+Running') {
    Write-Host "Starting MSSQLLocalDB..." -ForegroundColor Yellow
    & sqllocaldb start MSSQLLocalDB | Out-Null
}

if (-not (Test-Path $mdfPath)) {
    Write-Host "ERROR: KalaSmriti.mdf was not found in App_Data." -ForegroundColor Red
    Pause-IfNeeded
    exit 1
}

try {
    [xml]$cfg = Get-Content $webConfigPath -Raw
    $conn = $cfg.configuration.connectionStrings.add | Where-Object { $_.name -eq 'KalaSmritiConnectionString' }
    if ($null -ne $conn) {
        $conn.connectionString = $connectionString
        $cfg.Save($webConfigPath)
        Write-Host "Updated Web.config connection string." -ForegroundColor Green
    }
}
catch {
    Write-Host "Warning: failed to update Web.config - $($_.Exception.Message)" -ForegroundColor Yellow
}

$mdfFull = (Resolve-Path $mdfPath).Path
$attachSql = @"
IF DB_ID('KalaSmritiDB') IS NULL
BEGIN
    CREATE DATABASE [KalaSmritiDB] ON (FILENAME = N'$mdfFull') FOR ATTACH;
END
"@

Write-Host "Attaching MDF if needed..." -ForegroundColor Yellow
& sqlcmd -S "(LocalDB)\MSSQLLocalDB" -E -Q $attachSql 2>&1 | ForEach-Object { Write-Host $_ }
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to attach the MDF file." -ForegroundColor Red
    Pause-IfNeeded
    exit 1
}

try {
    $conn = New-Object System.Data.SqlClient.SqlConnection($connectionString)
    $conn.Open()
    $cmd = New-Object System.Data.SqlClient.SqlCommand('SELECT COUNT(*) FROM Product', $conn)
    $productCount = $cmd.ExecuteScalar()
    $conn.Close()

    Write-Host ""
    Write-Host "=== Complete ===" -ForegroundColor Cyan
    Write-Host "MDF attached successfully." -ForegroundColor Green
    Write-Host "Products available: $productCount" -ForegroundColor White
    Write-Host ""
    Write-Host "Connection string:" -ForegroundColor Yellow
    Write-Host $connectionString -ForegroundColor White
    Write-Host ""
    Write-Host "Login credentials:" -ForegroundColor Yellow
    Write-Host "Admin: admin@kalasmriti.com / Admin@123" -ForegroundColor White
    Write-Host "User:  bibhab@gmail.com / User@123" -ForegroundColor White
}
catch {
    Write-Host "ERROR: The MDF attached, but the product query failed." -ForegroundColor Red
    Write-Host $_.Exception.Message
    Pause-IfNeeded
    exit 1
}

Write-Host ""
Pause-IfNeeded
