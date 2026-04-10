# KalaSmriti E-Commerce Database Setup Script
Write-Host "=== KalaSmriti E-Commerce Database Setup ===" -ForegroundColor Cyan
Write-Host ""

# Allow non-interactive runs by setting environment variable SKIP_PAUSE=1
$SkipPause = $false
if ($env:SKIP_PAUSE -eq '1' -or $env:SKIP_PAUSE -eq 'true') { $SkipPause = $true }

# Function to test SQL Server connection
function Test-SQLConnection {
    param([string]$ServerName)
    try {
        $connStr = "Server=$ServerName;Database=master;Integrated Security=True;Connect Timeout=5;Encrypt=False"
        $conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
        $conn.Open()
        $conn.Close()
        return $true
    }
    catch {
        return $false
    }
}

# Check for available SQL Server instances
Write-Host "Checking for SQL Server instances..." -ForegroundColor Yellow
$sqlInstances = @("(LocalDB)\MSSQLLocalDB", ".\SQLEXPRESS", ".")
$availableInstance = $null

foreach ($instance in $sqlInstances) {
    Write-Host "Testing: $instance" -ForegroundColor Gray
    if (Test-SQLConnection -ServerName $instance) {
        $availableInstance = $instance
        Write-Host "Connected to: $instance" -ForegroundColor Green
        break
    }
}

if ($null -eq $availableInstance) {
    Write-Host ""
    Write-Host "ERROR: No SQL Server instance found!" -ForegroundColor Red
    Write-Host "Please install SQL Server Express from:" -ForegroundColor Yellow
    Write-Host "https://www.microsoft.com/sql-server/sql-server-downloads" -ForegroundColor White
    Write-Host ""
    if (-not $SkipPause) { pause }
    exit 1
}

Write-Host ""
Write-Host "Using: $availableInstance" -ForegroundColor Green

# Determine script/project paths early (used by the Web.config update and later steps)
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$sqlFile = Join-Path $scriptPath "CreateDatabase.sql"


# Update Web.config connection string to match the detected SQL Server instance so
# Visual Studio Server Explorer can refresh the connection without manual edits.
try {
    # Project root is the parent of the App_Data folder (scriptPath)
    $projectRoot = Split-Path -Parent $scriptPath
    $webConfigPath = Join-Path $projectRoot "Web.config"
    if (Test-Path $webConfigPath) {
        [xml]$cfg = Get-Content $webConfigPath -Raw
        $conn = $cfg.configuration.connectionStrings.add | Where-Object { $_.name -eq 'KalaSmritiConnectionString' }
        if ($null -ne $conn) {
            if ($availableInstance -eq "(LocalDB)\MSSQLLocalDB") {
                $conn.connectionString = 'Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\\KalaSmriti.mdf;Integrated Security=True;Connect Timeout=30;MultipleActiveResultSets=True'
            }
            elseif ($availableInstance -eq ".\\SQLEXPRESS") {
                $conn.connectionString = 'Data Source=.\\SQLEXPRESS;Initial Catalog=KalaSmritiDB;Integrated Security=True;Encrypt=False'
            }
            else {
                $conn.connectionString = 'Data Source=.;Initial Catalog=KalaSmritiDB;Integrated Security=True;Encrypt=False'
            }

            # Save changes back to Web.config (preserve encoding)
            $cfg.Save($webConfigPath)
            Write-Host "Updated Web.config connection string to match server instance: $availableInstance" -ForegroundColor Green
        }
    }
}
catch {
    Write-Host "Warning: failed to update Web.config - $($_.Exception.Message)" -ForegroundColor Yellow
}

# Get SQL script path
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$sqlFile = Join-Path $scriptPath "CreateDatabase.sql"

if (-not (Test-Path $sqlFile)) {
    Write-Host "ERROR: CreateDatabase.sql not found" -ForegroundColor Red
    if (-not $SkipPause) { pause }
    exit 1
}

$sqlScript = Get-Content $sqlFile -Raw

# Create database (prefer attaching existing MDF if present)
Write-Host "Creating database..." -ForegroundColor Yellow
try {
    $mdfPath = Join-Path $scriptPath "KalaSmriti.mdf"
    $mdfFull = $null
    if (Test-Path $mdfPath) {
        try { $mdfFull = (Resolve-Path $mdfPath -ErrorAction Stop).Path } catch { $mdfFull = $null }
    }

    if ($mdfFull) {
        $createDB = @"
IF DB_ID('KalaSmritiDB') IS NULL
BEGIN
    CREATE DATABASE [KalaSmritiDB] ON (FILENAME = N'$mdfFull') FOR ATTACH;
    PRINT 'Database attached';
END
"@
    }
    else {
        $createDB = @'
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'KalaSmritiDB')
BEGIN
    CREATE DATABASE KalaSmritiDB;
    PRINT 'Database created';
END
'@
    }

    $connStr = "Server=$availableInstance;Database=master;Integrated Security=True;Encrypt=False"
    $conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
    $conn.Open()
    $cmd = New-Object System.Data.SqlClient.SqlCommand($createDB, $conn)
    $cmd.ExecuteNonQuery() | Out-Null
    $conn.Close()
    Write-Host "Database ready" -ForegroundColor Green
}
catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    if (-not $SkipPause) { pause }
    exit 1
}

# Create tables and data
Write-Host "Creating tables..." -ForegroundColor Yellow
try {
    # Use sqlcmd for reliable batch execution
    $sqlcmdOutput = & sqlcmd -S $availableInstance -d KalaSmritiDB -i $sqlFile -b 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Setup completed!" -ForegroundColor Green
    }
    else {
        Write-Host "Warning: Some commands may have failed" -ForegroundColor Yellow
        Write-Host "Verifying tables..." -ForegroundColor Gray
        
        $connStr = "Server=$availableInstance;Database=KalaSmritiDB;Integrated Security=True;Encrypt=False"
        $conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
        $conn.Open()
        $cmd = New-Object System.Data.SqlClient.SqlCommand("SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE'", $conn)
        $tableCount = $cmd.ExecuteScalar()
        $conn.Close()
        
        if ($tableCount -ge 8) {
            Write-Host "Database setup verified - $tableCount tables created" -ForegroundColor Green
        }
        else {
            Write-Host "Error: Only $tableCount tables created" -ForegroundColor Red
            pause
            exit 1
        }
    }
}
catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    if (-not $SkipPause) { pause }
    exit 1
}

Write-Host ""
Write-Host "=== Complete ===" -ForegroundColor Cyan
Write-Host "Server: $availableInstance" -ForegroundColor White
Write-Host "Database: KalaSmritiDB" -ForegroundColor White
Write-Host ""
Write-Host "Login credentials:" -ForegroundColor Yellow
Write-Host "Admin: admin@kalasmriti.com / Admin@123" -ForegroundColor White
Write-Host "User:  bibhab@gmail.com / User@123" -ForegroundColor White
Write-Host ""

if ($availableInstance -eq ".\SQLEXPRESS") {
    Write-Host "Connection string:" -ForegroundColor Yellow
    Write-Host "Data Source=.\SQLEXPRESS;Initial Catalog=KalaSmritiDB;Integrated Security=True;Encrypt=False" -ForegroundColor White
}
elseif ($availableInstance -eq "(LocalDB)\MSSQLLocalDB") {
    Write-Host "Connection string:" -ForegroundColor Yellow
    Write-Host "Data Source=(LocalDB)\MSSQLLocalDB;Initial Catalog=KalaSmritiDB;Integrated Security=True;Encrypt=False" -ForegroundColor White
}
else {
    Write-Host "Connection string:" -ForegroundColor Yellow
    Write-Host "Data Source=.;Initial Catalog=KalaSmritiDB;Integrated Security=True;Encrypt=False" -ForegroundColor White
}

Write-Host ""
pause
