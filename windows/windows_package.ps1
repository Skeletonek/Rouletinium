# Builds the Windows release and packages it with Inno Setup.
#
# Requirements:
#   - Flutter SDK on PATH (or run from a Flutter-enabled shell).
#   - Inno Setup installed; `iscc` on PATH, or set $env:ISCC to its path.
#
# Usage:
#   powershell -File windows\windows_package.ps1 [-Version 0.5.0]

param(
    [string]$Version
)

$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$root = Resolve-Path (Join-Path $scriptDir '..')

# Auto-detect base version (X.Y.Z) from pubspec.yaml, dropping build number / prerelease.
if (-not $Version) {
    $line = (Get-Content (Join-Path $root 'pubspec.yaml')) -match '^version:' | Select-Object -First 1
    if ($line -match 'version:\s*(\d+\.\d+\.\d+)') {
        $Version = $Matches[1]
    } else {
        $Version = '0.5.0'
    }
}

Write-Host "Packaging Windows build with version: $Version"

Set-Location $root
flutter build windows --release

$iscc = if ($env:ISCC) { $env:ISCC } else { 'iscc' }
& $iscc (Join-Path $root 'windows/rouletinium.iss') "/DMyAppVersion=$Version"
if ($LASTEXITCODE -ne 0) {
    Write-Error "Inno Setup (iscc) failed with exit code $LASTEXITCODE"
    exit $LASTEXITCODE
}

Write-Host "Created build/Rouletinium-$Version-Win_x64.exe"
