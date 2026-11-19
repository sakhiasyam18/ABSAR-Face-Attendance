@echo off
title ABSAR - Status Registrasi dan Presensi Wajah Santri
cd /d "%~dp0"

echo ========================================================
echo        ABSAR - NEXT-GEN AI VISION ATTENDANCE
echo        "Satu Jepretan Kelas Tanpa Titip Absen"
echo ========================================================
echo.
echo Memuat data santri dari database presensi.db...
echo.

set PYTHON_BIN="%~dp0backend\.venv\Scripts\python.exe"
if not exist %PYTHON_BIN% (
    set PYTHON_BIN=python
)

call %PYTHON_BIN% "%~dp0tools\lihat_data.py"

echo.
echo ========================================================
echo Dashboard Visual interaktif telah dibuka di browser!
echo File Dashboard: %~dp0DASHBOARD_SANTRI.html
echo ========================================================
echo.
pause
