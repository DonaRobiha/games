import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/library_service.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Logout: hapus data login, lalu kembali ke Login Page
  Future<void> _logout(BuildContext context) async {
    await AuthService.logout();
    if (!context.mounted) return;
    // pushAndRemoveUntil dengan `(route) => false` menghapus SEMUA halaman
    // sebelumnya, jadi user tidak bisa menekan back untuk masuk lagi tanpa login.
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  // Baris info: label di kiri, nilai di kanan
  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 12, color: Colors.white70)),
            Text(value, style: const TextStyle(fontSize: 12)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 60),
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, size: 44, color: Colors.white),
            ),
            const SizedBox(height: 40),
            // Email diambil dari SharedPreferences (async, jadi pakai FutureBuilder)
            FutureBuilder<String>(
              future: AuthService.getEmail(),
              builder: (_, snap) => _row('Email', snap.data ?? '-'),
            ),
            // Jumlah game diambil dari Hive dan ikut berubah otomatis
            ValueListenableBuilder(
              valueListenable: LibraryService.listenable,
              builder: (_, __, ___) =>
                  _row('Games Dimiliki', '${LibraryService.count}'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () => _logout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF44336),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
