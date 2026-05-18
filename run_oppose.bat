@echo off
setlocal

cd /d "%~dp0"
set "LOG_FILE=%~dp0run_oppose.log"
echo [%date% %time%] Starting Oppose launcher > "%LOG_FILE%"

where flutter >nul 2>nul
if errorlevel 1 (
  echo Flutter was not found on PATH.
  echo Install Flutter or open this shortcut from a terminal where Flutter works.
  echo Flutter was not found on PATH. >> "%LOG_FILE%"
  pause
  exit /b 1
)

if not exist "web\index.html" (
  echo Flutter web platform files are missing. Creating them now...
  call flutter create --platforms=web . >> "%LOG_FILE%" 2>&1
  if errorlevel 1 (
    echo Failed to create Flutter web platform files.
    echo Failed to create Flutter web platform files. See %LOG_FILE%
    pause
    exit /b 1
  )
)

echo Getting Flutter dependencies...
call flutter pub get >> "%LOG_FILE%" 2>&1
if errorlevel 1 (
  echo Failed to get Flutter dependencies.
  echo Failed to get Flutter dependencies. See %LOG_FILE%
  pause
  exit /b 1
)

echo Starting Oppose in Chrome...
echo [%date% %time%] Running flutter run -d chrome >> "%LOG_FILE%"
call flutter run -d chrome
if errorlevel 1 (
  echo Flutter run failed.
  echo Flutter run failed. See %LOG_FILE%
  pause
  exit /b 1
)

echo Oppose stopped. You can close this window.
pause
endlocal
