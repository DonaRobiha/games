@echo off
setlocal
where flutter >nul 2>nul
if errorlevel 1 (
  echo Flutter tidak ditemukan di PATH.
  pause
  exit /b 1
)
if not exist android (
  echo Melengkapi platform Flutter...
  flutter create . --platforms android,web,windows
)
if not exist web (
  echo Melengkapi platform Flutter...
  flutter create . --platforms android,web,windows
)
flutter pub get
flutter run
pause
