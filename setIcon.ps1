# Script to create and customize folders with icons
# Author: Oonie11
# Date: January 4, 2025

# Define paths dynamically based on script location
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$basePath = $scriptPath  # Changed to create folders where the script is
$iconsPath = Join-Path $scriptPath "all_icons"

# Folder configuration
$folders = @(
    "Icons",
    "Virtual Machines",
    "Scripts", 
    "Desktop Folders",
    "Portable Apps",
    "Games"
)

# Ensure icons directory exists
if (-not (Test-Path $iconsPath)) {
    Write-Host "Error: Icons folder not found at: $iconsPath" -ForegroundColor Red
    Write-Host "Please ensure 'all_icons' folder exists in the same directory as this script" -ForegroundColor Yellow
    exit
}

foreach ($folder in $folders) {
    $folderPath = Join-Path $basePath $folder
    $iconPath = Join-Path $iconsPath "$folder.ico"
    
    Write-Host "`nProcessing folder: $folder" -ForegroundColor Cyan
    
    # Validate icon existence
    if (-not (Test-Path $iconPath)) {
        Write-Host "Warning: Icon not found for $folder at: $iconPath" -ForegroundColor Yellow
        Write-Host "Skipping icon assignment for this folder" -ForegroundColor Yellow
        continue
    }
    
    # Create folder with error handling
    try {
        if (-not (Test-Path $folderPath)) {
            New-Item -Path $folderPath -ItemType Directory -ErrorAction Stop
            Write-Host "Created folder: $folder" -ForegroundColor Green
        } else {
            Write-Host "Folder already exists: $folder" -ForegroundColor Gray
        }
    } catch {
        Write-Host "Error creating folder $folder : $_" -ForegroundColor Red
        continue
    }
    
    # Set attributes with error handling
    try {
        Set-ItemProperty -Path $folderPath -Name Attributes -Value ([System.IO.FileAttributes]::System + [System.IO.FileAttributes]::ReadOnly)
        Write-Host "Set system and read-only attributes for: $folder" -ForegroundColor Green
    } catch {
        Write-Host "Error setting attributes for $folder : $_" -ForegroundColor Red
    }

    # Create desktop.ini with error handling
    $iniContent = @"
[.ShellClassInfo]
IconResource=$iconPath,0
[ViewState]
Mode=
Vid=
FolderType=Generic
"@

    try {
        $iniPath = Join-Path $folderPath "desktop.ini"
        $iniContent | Out-File $iniPath -Encoding Unicode -Force
        
        # Set attributes for desktop.ini
        Set-ItemProperty -Path $iniPath -Name Attributes -Value ([System.IO.FileAttributes]::System + [System.IO.FileAttributes]::Hidden)
        Write-Host "Applied icon configuration to: $folder" -ForegroundColor Green
    } catch {
        Write-Host "Error creating desktop.ini for $folder : $_" -ForegroundColor Red
    }
}

# Refresh icon cache
Write-Host "`nRefreshing icon cache..." -ForegroundColor Cyan
try {
    Start-Process "ie4uinit.exe" -ArgumentList "-show" -Wait
    Write-Host "Icon cache refreshed successfully" -ForegroundColor Green
} catch {
    Write-Host "Error refreshing icon cache: $_" -ForegroundColor Red
}

Write-Host "`nScript completed. Please refresh Explorer to see the changes." -ForegroundColor Green