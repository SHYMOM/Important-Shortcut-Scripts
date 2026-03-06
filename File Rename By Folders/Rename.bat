@echo off
chcp 65001 >nul
echo Starting File Organizer...
powershell -ExecutionPolicy Bypass -NoProfile -File "%~dp0FileOrganizer.ps1"
pause