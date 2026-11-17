import 'package:shared_preferences/shared_preferences.dart';

// Mengelola data login memakai SharedPreferences (penyimpanan key-value
// sederhana yang tetap ada walaupun aplikasi ditutup).
class AuthService {
  // Nama key dikumpulkan sebagai konstanta agar tidak salah ketik
  static const _kLoggedIn = 'is_logged_in';
  static const _kEmail = 'email';

  // Simpan kredensial & tandai user sudah login
  static Future<void> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kEmail, email);
    await prefs.setString('password', password);
    await prefs.setBool(_kLoggedIn, true);
  }

  // Dipanggil di main() untuk menentukan halaman awal.
  // `?? false` = kalau belum pernah ada data, anggap belum login.
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kLoggedIn) ?? false;
  }

  // Dipakai Profile Page untuk menampilkan email
  static Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kEmail) ?? '-';
  }

  // Logout: hapus status login & data akun.
  // Library (Hive) sengaja tidak dihapus.
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedIn, false);
    await prefs.remove(_kEmail);
    await prefs.remove('password');
  }
}
