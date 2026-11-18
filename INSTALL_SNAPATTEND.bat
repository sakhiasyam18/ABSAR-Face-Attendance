@echo off
title Pasang SnapAttend v3.2.6 ke HP
cd /d "%~dp0"

echo ========================================================
echo        PASANG SNAPATTEND v3.2.6 LANGSUNG KE HP
echo        Package ID: com.um.snapattend
echo ========================================================
echo.

set ADB_BIN=adb
if exist "C:\Program Files\ASUS\GlideX\adb.exe" set ADB_BIN="C:\Program Files\ASUS\GlideX\adb.exe"
if exist "%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe" set ADB_BIN="%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe"

echo 1. Memeriksa koneksi HP...
%ADB_BIN% devices
echo.

if not exist "%~dp0SnapAttend-v3.2.6.apk" (
    echo [ERROR] File SnapAttend-v3.2.6.apk belum ditemukan.
    echo Silakan jalankan BUILD_SNAPATTEND.bat terlebih dahulu untuk membuat file APK rilis.
    pause
    exit /b 1
)

echo 2. Menginstall SnapAttend ke HP Anda (com.um.snapattend)...
%ADB_BIN% install -r "%~dp0SnapAttend-v3.2.6.apk"
if %errorlevel% neq 0 (
    echo.
    echo [INFO] Mencoba install ulang...
    %ADB_BIN% uninstall com.um.snapattend
    %ADB_BIN% install "%~dp0SnapAttend-v3.2.6.apk"
)

echo.
echo 3. Mengaktifkan Mode USB (Port 8000)...
%ADB_BIN% reverse tcp:8000 tcp:8000

echo 4. Membuka SnapAttend di HP...
%ADB_BIN% shell am start -n com.um.snapattend/com.example.mobile.MainActivity

echo.
echo ========================================================
echo [BERHASIL] SnapAttend v3.2.6 sudah terpasang dan terbuka di HP Anda!
echo ========================================================
pause
