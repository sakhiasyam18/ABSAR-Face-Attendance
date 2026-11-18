@echo off
title SnapAttend v3.2.6 - Build dan Deploy ke HP
cd /d "%~dp0"

echo ========================================================
echo        SNAPATTEND v3.2.6 - BUILD DAN DEPLOY
echo        Universitas Negeri Malang - Face Attendance
echo        Package ID: com.um.snapattend
echo ========================================================
echo.

set FLUTTER_BIN=E:\flutter_windows_3.47.2-stable\flutter\bin\flutter.bat
if not exist "%FLUTTER_BIN%" (
    echo Mencari flutter di PATH sistem...
    set FLUTTER_BIN=flutter
)

echo [LANGKAH 1/3] Membangun APK Rilis SnapAttend (Android)...
echo Menjalankan Flutter Build Release APK...
echo.

if exist "%~dp0mobile_snapattend\build\app\outputs\flutter-apk\app-release.apk" (
    del /f /q "%~dp0mobile_snapattend\build\app\outputs\flutter-apk\app-release.apk"
)

cd /d "%~dp0mobile_snapattend"
call "%FLUTTER_BIN%" build apk --release

if %errorlevel% neq 0 (
    echo.
    echo ========================================================
    echo [GAGAL] Kompilasi APK SnapAttend gagal. Periksa error di atas.
    echo ========================================================
    pause
    exit /b %errorlevel%
)

if not exist "%~dp0mobile_snapattend\build\app\outputs\flutter-apk\app-release.apk" (
    echo.
    echo ========================================================
    echo [GAGAL] Kompilasi APK belum menghasilkan file app-release.apk.
    echo ========================================================
    pause
    exit /b 1
)

cd /d "%~dp0"
copy /Y "%~dp0mobile_snapattend\build\app\outputs\flutter-apk\app-release.apk" "%~dp0SnapAttend-v3.2.6.apk"

echo.
echo ========================================================
echo [BERHASIL] File APK Resmi Siap:
echo Lokasi File: %~dp0SnapAttend-v3.2.6.apk
echo ========================================================
echo.

echo [LANGKAH 2/3] Memeriksa koneksi HP (Android USB via ADB)...
set ADB_BIN=adb
if exist "C:\Program Files\ASUS\GlideX\adb.exe" set ADB_BIN="C:\Program Files\ASUS\GlideX\adb.exe"
if exist "%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe" set ADB_BIN="%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe"

%ADB_BIN% devices

echo.
echo Menginstall SnapAttend ke HP Anda (com.um.snapattend)...
%ADB_BIN% install -r "%~dp0SnapAttend-v3.2.6.apk"
if %errorlevel% neq 0 (
    echo.
    echo [INFO] Mencoba install ulang...
    %ADB_BIN% uninstall com.um.snapattend
    %ADB_BIN% install "%~dp0SnapAttend-v3.2.6.apk"
)

echo Mengaktifkan jalur USB Port 8000 (Mode USB)...
%ADB_BIN% reverse tcp:8000 tcp:8000

echo Membuka aplikasi SnapAttend di HP...
%ADB_BIN% shell am start -n com.um.snapattend/com.example.mobile.MainActivity
echo.
echo [SUKSES HP] SnapAttend v3.2.6 berhasil terpasang dan dibuka di HP Anda!

echo.
echo ========================================================
echo [LANGKAH 3/3] Menjalankan Server Backend Laptop (PC)...
echo ========================================================
echo.
echo Membuka Server Backend di jendela terpisah...
start "Server Backend Presensi" cmd /k "%~dp0JALANKAN_SERVER.bat"

echo.
echo ========================================================
echo SELESAI! SnapAttend (Aplikasi & Server) SIAP!
echo ========================================================
pause
