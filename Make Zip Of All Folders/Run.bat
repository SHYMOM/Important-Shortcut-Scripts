@echo off
setlocal enabledelayedexpansion

echo Starting folder processing...
echo -----------------------------------

rem Loop through all directories (folders) in the current location
for /d %%D in (*) do (
    echo Processing folder: "%%D"

    rem 1. Rename the contents inside the folder to match the folder name
    set /a count=1
    for %%F in ("%%D\*.*") do (
        rem Extract the file extension
        set "ext=%%~xF"
        
        rem Rename the file to FolderName_Counter.extension
        ren "%%F" "%%~nxD_!count!!ext!"
        set /a count+=1
    )

    rem 2. Copy the newly renamed images to the script's root directory
    echo Copying images from "%%D" to root directory...
    copy "%%D\%%~nxD_*.jpg" "%~dp0" >nul 2>&1
    copy "%%D\%%~nxD_*.jpeg" "%~dp0" >nul 2>&1
    copy "%%D\%%~nxD_*.png" "%~dp0" >nul 2>&1
    copy "%%D\%%~nxD_*.gif" "%~dp0" >nul 2>&1

    rem 3. Zip the folder individually using PowerShell
    echo Zipping "%%D" into "%%D.zip"...
    powershell -NoProfile -Command "Compress-Archive -Path '.\%%D' -DestinationPath '.\%%D.zip' -Force"
    
    echo -----------------------------------
)

echo All tasks completed successfully!
pause