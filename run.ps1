$ErrorActionPreference = 'Stop'

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
  Write-Host 'Flutter tidak ditemukan di PATH.' -ForegroundColor Red
  Write-Host 'Pastikan Flutter sudah terpasang dan perintah flutter bisa dijalankan.'
  exit 1
}

if (-not (Test-Path 'android') -or -not (Test-Path 'web')) {
  Write-Host 'Melengkapi platform Flutter (Android, Web, Windows)...' -ForegroundColor Cyan
  flutter create . --platforms android,web,windows
}

flutter pub get
flutter run
