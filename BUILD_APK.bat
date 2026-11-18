@echo off
title ABSAR - Build dan Deploy (PC dan HP)
cd /d "%~dp0"

echo ========================================================
echo        ABSAR - NEXT-GEN AI VISION ATTENDANCE
echo        "Satu Jepretan Kelas Tanpa Titip Absen"
echo ========================================================
echo.

set FLUTTER_BIN=E:\flutter_windows_3.47.2-stable\flutter\bin\flutter.bat

if not exist "%FLUTTER_BIN%" (
    echo Mencari flutter di PATH sistem...
    set FLUTTER_BIN=flutter
)

echo [LANGKAH 1/3] Membangun APK Rilis Mobile (Android)...
echo Menjalankan Flutter Build Release APK...
echo.

:: Hapus APK build lama jika ada agar benar-benar fresh
if exist "%~dp0mobile\build\app\outputs\flutter-apk\app-release.apk" (
    del /f /q "%~dp0mobile\build\app\outputs\flutter-apk\app-release.apk"
)

cd /d "%~dp0mobile"
call "%FLUTTER_BIN%" build apk --release

if %errorlevel% neq 0 (
    echo.
    echo ========================================================
    echo [GAGAL] Kompilasi APK gagal. Periksa error di atas.
    echo ========================================================
    pause
    exit /b %errorlevel%
)

if not exist "%~dp0mobile\build\app\outputs\flutter-apk\app-release.apk" (
    echo.
    echo ========================================================
    echo [GAGAL] Kompilasi APK belum menghasilkan file app-release.apk.
    echo ========================================================
    pause
    exit /b 1
)

cd /d "%~dp0"
copy /Y "%~dp0mobile\build\app\outputs\flutter-apk\app-release.apk" "%~dp0ABSAR-Face-Attendance.apk"
copy /Y "%~dp0mobile\build\app\outputs\flutter-apk\app-release.apk" "%~dp0SnapAttend-v3.2.6.apk" >nul

echo.
echo ========================================================
echo [BERHASIL] File APK Resmi Siap:
echo Lokasi File: %~dp0ABSAR-Face-Attendance.apk
echo ========================================================
echo.

echo [LANGKAH 2/3] Memeriksa koneksi HP (Android USB via ADB)...
set ADB_BIN=adb
if exist "C:\Program Files\ASUS\GlideX\adb.exe" set ADB_BIN="C:\Program Files\ASUS\GlideX\adb.exe"
if exist "%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe" set ADB_BIN="%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe"

%ADB_BIN% devices

echo.
echo Terdeteksi HP di atas, menginstall APK otomatis...
echo Menginstall APK terbaru ke HP Anda...
%ADB_BIN% install -r "%~dp0ABSAR-Face-Attendance.apk"
if %errorlevel% neq 0 (
    echo.
    echo [INFO] Mencoba install ulang...
    %ADB_BIN% uninstall com.example.mobile
    %ADB_BIN% install "%~dp0ABSAR-Face-Attendance.apk"
)

echo Mengaktifkan jalur USB Port 8000 (Mode USB)...
%ADB_BIN% reverse tcp:8000 tcp:8000

echo Membuka aplikasi ABSAR di HP...
%ADB_BIN% shell monkey -p com.example.mobile -c android.intent.category.LAUNCHER 1
echo.
echo [SUKSES HP] ABSAR Face Attendance berhasil terpasang dan dibuka di HP Anda!

echo.
echo ========================================================
echo [LANGKAH 3/3] Menjalankan Server Backend Laptop (PC)...
echo ========================================================
echo.
echo Membuka Server Backend di jendela terpisah...
start "Server Backend ABSAR" cmd /k "%~dp0JALANKAN_SERVER.bat"

echo.
echo ========================================================
echo SELESAI! PC (Server Backend) dan HP (Aplikasi) SIAP!
echo ========================================================
pause
