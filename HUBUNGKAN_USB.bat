@echo off
title Hubungkan USB Tunnel ABSAR
echo ========================================================
echo       HUBUNGKAN PORT USB (ADB REVERSE TUNNEL)
echo ========================================================
set ADB_BIN=adb
if exist "C:\Program Files\ASUS\GlideX\adb.exe" set ADB_BIN="C:\Program Files\ASUS\GlideX\adb.exe"
if exist "%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe" set ADB_BIN="%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe"

%ADB_BIN% reverse tcp:8000 tcp:8000
echo.
echo [BERHASIL] Port USB reverse tcp:8000 telah terhubung!
echo Di HP Anda: Buka Pengaturan Server -> Gunakan http://127.0.0.1:8000
echo ========================================================
pause
