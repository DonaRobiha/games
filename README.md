# Hydra Games - Responsi Mobile

Project Flutter responsi dengan fitur login, daftar game, detail game, library lokal, dan profil.

## Menjalankan

### Cara paling mudah di Windows
```powershell
cd path\ke\124240026_Responsi_Mobile
.\run.ps1
```

Script akan melengkapi folder platform Flutter yang belum ada, menjalankan `flutter pub get`, lalu menjalankan aplikasi.

### Manual
```powershell
flutter pub get
flutter run
```

Jika project baru saja menerima ZIP ini dan folder `android/` atau `web/` belum ada, jalankan sekali:
```powershell
flutter create . --platforms android,web,windows
```
Kemudian:
```powershell
flutter pub get
flutter run
```

## API

Aplikasi mengambil data game dari FreeToGame API:
`https://www.freetogame.com/api`

Internet diperlukan untuk daftar dan detail game.

## Penyimpanan lokal

- SharedPreferences: status login dan email.
- Hive: library game yang disimpan pengguna.
