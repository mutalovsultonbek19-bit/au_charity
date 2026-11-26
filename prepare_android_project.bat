@echo off
REM Run this from the mobile folder after installing Flutter SDK.
flutter create --platforms=android --org uz.angrenuniversity .
if errorlevel 1 exit /b %errorlevel%
echo Android platform files are ready.
