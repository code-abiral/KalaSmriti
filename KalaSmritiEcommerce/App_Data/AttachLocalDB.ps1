<#
AttachLocalDB.ps1
Helper script to ensure LocalDB instance is running and attach the KalaSmriti.mdf
#>
Write-Host "Ensuring LocalDB MSSQLLocalDB instance is running..." -ForegroundColor Cyan

function Run-LocalDBCommand {
    param([string]$args)
    & sqllocaldb $args 2>&1
}

try {
    $instances = Run-LocalDBCommand "i"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "sqllocaldb not found or failed: $instances" -ForegroundColor Red
        exit 1
    }

    # Start MSSQLLocalDB if not running
    $info = Run-LocalDBCommand "info MSSQLLocalDB"
    if ($info -match "Running") {
        Write-Host "MSSQLLocalDB is already running" -ForegroundColor Green
    }
    else {
        Write-Host "Starting MSSQLLocalDB..." -ForegroundColor Yellow
        Run-LocalDBCommand "s MSSQLLocalDB" | Out-Null
        Start-Sleep -Seconds 1
    }

    # Build attach command using sqlcmd
    $dataDir = Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) ""
    $mdfPath = Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "KalaSmriti.mdf"
    $mdfFull = Resolve-Path $mdfPath -ErrorAction Stop

    $attachSql = "IF DB_ID('KalaSmritiDB') IS NULL BEGIN CREATE DATABASE [KalaSmritiDB] ON (FILENAME = N'$($mdfFull)') FOR ATTACH; END"

    Write-Host "Attaching database using sqlcmd..." -ForegroundColor Yellow
    & sqlcmd -S ("(localdb)\\MSSQLLocalDB") -Q $attachSql 2>&1 | ForEach-Object { Write-Host $_ }

    Write-Host "Done." -ForegroundColor Green
}
catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
