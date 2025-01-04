# Folder Icon Setup Script

A PowerShell script that creates organized folders with custom icons.

## Features
- Creates preset folders with custom icons
- Automatically sets folder attributes
- Configures custom icons using desktop.ini
- Refreshes icon cache automatically
- Error handling and colored status messages

## Setup
1. Clone this repository
2. Create an `all_icons` folder in the script directory
3. Add your `.ico` files to the `all_icons` folder
   - Icon files should match folder names (e.g., "Scripts.ico" for "Scripts" folder)
4. Run the script with administrator privileges

## Folder Structure
The script creates the following folders you can change it as you wish:
- ICONS
- Virtual Machines
- Scripts
- Desktop Folders
- Portable Apps
- Games

## Requirements
- Windows OS
- PowerShell
- Administrator privileges
- .ico files for each folder

## Usage
```powershell
.\SetupFolders.ps1
