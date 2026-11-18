@echo off
title Build APK SnapAttend
cd /d "%~dp0"

echo ========================================================
echo        SNAPATTEND - BUILD APK RELEASE
echo        Package ID: com.um.snapattend
echo ========================================================
echo.

set FLUTTER_BIN=E:\flutter_windows_3.47.2-stable\flutter\bin\flutter.bat
if not exist "%FLUTTER_BIN%" set FLUTTER_BIN=flutter

echo Membangun APK Release SnapAttend...
call "%FLUTTER_BIN%" build apk --release

if %errorlevel% neq 0 (
    echo.
    echo ========================================================
    echo [GAGAL] Build APK SnapAttend gagal.
    echo ========================================================
    pause
    exit /b %errorlevel%
)

echo.
echo ========================================================
echo [BERHASIL] APK SnapAttend berhasil dibuat:
echo Lokasi: %~dp0build\app\outputs\flutter-apk\app-release.apk
echo ========================================================
pause
