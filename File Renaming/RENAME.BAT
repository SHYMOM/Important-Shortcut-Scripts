@echo off
setlocal enabledelayedexpansion

:: 1. Find the highest existing number in the folder
set /a max_num=0
for /f "tokens=1 delims=_" %%a in ('dir /b *.mp4 *.mkv *.avi *.mov *.wmv') do (
    set "val=%%a"
    :: Check if the prefix is actually a number
    for /f "delims=0123456789" %%b in ("!val!") do set "val=notnum"
    if not "!val!"=="notnum" (
        if !val! GTR !max_num! set /a max_num=!val!
    )
)

:: 2. Set starting count to max_num + 1
set /a count=max_num+1

echo Starting rename from serial number: !count!

:: 3. Loop and rename ONLY files that don't have a number prefix yet
for %%f in (*.mp4 *.mkv *.avi *.mov *.wmv) do (
    set "filename=%%f"
    
    :: Check if the file already starts with a number and underscore
    echo !filename! | findstr /R "^[0-9]*_" >nul
    
    if errorlevel 1 (
        echo Renaming "%%f" to "!count!_%%f"
        ren "%%f" "!count!_%%f"
        set /a count+=1
    ) else (
        echo Skipping "%%f" (Already has a serial number)
    )
)

echo.
echo Process Complete.
pause