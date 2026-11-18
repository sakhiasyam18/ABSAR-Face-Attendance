@echo off
title Pasang ABSAR ke HP
cd /d "%~dp0"

echo ========================================================
echo        PASANG ABSAR FACE ATTENDANCE KE HP
echo        "Satu Jepretan Kelas Tanpa Titip Absen"
echo        Package ID: com.absar.attendance
echo ========================================================
echo.

set ADB_BIN=adb
if exist "C:\Program Files\ASUS\GlideX\adb.exe" set ADB_BIN="C:\Program Files\ASUS\GlideX\adb.exe"
if exist "%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe" set ADB_BIN="%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe"

echo 1. Memeriksa koneksi HP...
%ADB_BIN% devices
echo.

if not exist "%~dp0ABSAR-Face-Attendance.apk" (
    echo [ERROR] File ABSAR-Face-Attendance.apk belum ditemukan.
    echo Silakan jalankan BUILD_ABSAR.bat terlebih dahulu untuk membuat file APK rilis.
    pause
    exit /b 1
)

echo 2. Menginstall ABSAR ke HP Anda (com.absar.attendance)...
%ADB_BIN% install -r "%~dp0ABSAR-Face-Attendance.apk"
if %errorlevel% neq 0 (
    echo.
    echo [INFO] Mencoba install ulang...
    %ADB_BIN% uninstall com.absar.attendance
    %ADB_BIN% install "%~dp0ABSAR-Face-Attendance.apk"
)

echo.
echo 3. Mengaktifkan Mode USB (Port 8000)...
%ADB_BIN% reverse tcp:8000 tcp:8000

echo 4. Membuka ABSAR di HP...
%ADB_BIN% shell monkey -p com.absar.attendance -c android.intent.category.LAUNCHER 1

echo.
echo ========================================================
echo [BERHASIL] ABSAR Face Attendance sudah terpasang dan terbuka di HP Anda!
echo ========================================================
pause
