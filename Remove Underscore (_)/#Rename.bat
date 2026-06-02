@echo off
setlocal enabledelayedexpansion

echo Renaming files by replacing underscores with spaces...
echo.

for %%f in (*_*) do (
    set "filename=%%~nf"
    set "extension=%%~xf"
    set "newname=!filename:_= !"
    
    if not "!filename!"=="!newname!" (
        echo Renaming: "%%f" -^> "!newname!!extension!"
        ren "%%f" "!newname!!extension!" 2>nul
        if errorlevel 1 (
            echo   ERROR: Could not rename "%%f"
        )
    )
)

echo.
echo Done!
pause