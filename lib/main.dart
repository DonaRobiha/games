import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'pages/login_page.dart';
import 'pages/main_page.dart';
import 'services/auth_service.dart';
import 'services/library_service.dart';

// Titik awal aplikasi. Dibuat async karena ada proses yang harus
// selesai dulu sebelum UI tampil (init Hive & cek status login).
Future<void> main() async {
  // Wajib dipanggil kalau ada proses async/plugin sebelum runApp()
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive (menentukan folder penyimpanan di perangkat)
  await Hive.initFlutter();

  // Buka box Hive "library" supaya bisa dipakai secara sinkron di semua page
  await LibraryService.init();

  // Cek di SharedPreferences: apakah user sudah login sebelumnya?
  final loggedIn = await AuthService.isLoggedIn();

  runApp(MyApp(loggedIn: loggedIn));
}

class MyApp extends StatelessWidget {
  final bool loggedIn;
  const MyApp({super.key, required this.loggedIn});

  // Warna utama aplikasi (biru)
  static const Color primary = Color(0xFF2D8CFF);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hydra Games',
      debugShowCheckedModeBanner: false,
      // Tema gelap global, jadi semua page otomatis memakai gaya ini
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(primary: primary),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: primary,
          unselectedItemColor: Colors.white70,
        ),
      ),
      // Auto-login: kalau sudah login langsung ke MainPage, kalau belum ke LoginPage
      home: loggedIn ? const MainPage() : const LoginPage(),
    );
  }
}
