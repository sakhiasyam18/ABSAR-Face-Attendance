@echo off
title Build APK ABSAR
cd /d "%~dp0"

echo ========================================================
echo        ABSAR - BUILD APK RELEASE
echo        Package ID: com.absar.attendance
echo ========================================================
echo.

set FLUTTER_BIN=E:\flutter_windows_3.47.2-stable\flutter\bin\flutter.bat
if not exist "%FLUTTER_BIN%" set FLUTTER_BIN=flutter

echo Membangun APK Release ABSAR...
call "%FLUTTER_BIN%" build apk --release

if %errorlevel% neq 0 (
    echo.
    echo ========================================================
    echo [GAGAL] Build APK ABSAR gagal.
    echo ========================================================
    pause
    exit /b %errorlevel%
)

echo.
echo ========================================================
echo [BERHASIL] APK ABSAR berhasil dibuat:
echo Lokasi: %~dp0build\app\outputs\flutter-apk\app-release.apk
echo ========================================================
pause
