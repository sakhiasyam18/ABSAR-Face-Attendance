@echo off
title Pasang ABSAR ke HP
cd /d "%~dp0"

echo ========================================================
echo        PASANG ABSAR FACE ATTENDANCE KE HP
echo        "Satu Jepretan Kelas Tanpa Titip Absen"
echo ========================================================
echo.

set ADB_BIN=adb
if exist "C:\Program Files\ASUS\GlideX\adb.exe" set ADB_BIN="C:\Program Files\ASUS\GlideX\adb.exe"
if exist "%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe" set ADB_BIN="%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe"

echo 1. Memeriksa koneksi HP...
%ADB_BIN% devices
echo.

echo 2. Memastikan file APK resmi terbaru...
if exist "%~dp0mobile\build\app\outputs\flutter-apk\app-release.apk" (
    copy /Y "%~dp0mobile\build\app\outputs\flutter-apk\app-release.apk" "%~dp0ABSAR-Face-Attendance.apk" >nul
)

set TARGET_APK="%~dp0ABSAR-Face-Attendance.apk"
if not exist %TARGET_APK% (
    if exist "%~dp0SnapAttend-v3.2.6.apk" (
        set TARGET_APK="%~dp0SnapAttend-v3.2.6.apk"
    )
)

echo 3. Menginstall APK ke HP Anda...
%ADB_BIN% install -r %TARGET_APK%
if %errorlevel% neq 0 (
    echo.
    echo [INFO] Jika install gagal, mencoba uninstall versi lama terlebih dahulu...
    %ADB_BIN% uninstall com.example.mobile
    %ADB_BIN% install %TARGET_APK%
)

echo.
echo 4. Mengaktifkan Mode USB (Port 8000)...
%ADB_BIN% reverse tcp:8000 tcp:8000

echo 5. Membuka ABSAR di HP...
%ADB_BIN% shell monkey -p com.example.mobile -c android.intent.category.LAUNCHER 1

echo.
echo ========================================================
echo [BERHASIL] ABSAR Face Attendance sudah terpasang dan terbuka di HP Anda!
echo ========================================================
pause
