@echo off
setlocal

cd /d "%~dp0"

where flutter >nul 2>nul
if errorlevel 1 (
  echo Flutter was not found on PATH.
  echo Install Flutter or open this shortcut from a terminal where Flutter works.
  pause
  exit /b 1
)

if not exist "web\index.html" (
  echo Flutter web platform files are missing. Creating them now...
  flutter create --platforms=web .
  if errorlevel 1 (
    echo Failed to create Flutter web platform files.
    pause
    exit /b 1
  )
)

echo Getting Flutter dependencies...
flutter pub get
if errorlevel 1 (
  echo Failed to get Flutter dependencies.
  pause
  exit /b 1
)

echo Starting Oppose in Chrome...
flutter run -d chrome
if errorlevel 1 (
  echo Flutter run failed.
  pause
  exit /b 1
)

endlocal
