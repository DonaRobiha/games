import 'package:flutter/material.dart';

import 'home_page.dart';
import 'library_page.dart';
import 'profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

// Halaman utama yang menampung BottomNavigationBar untuk 3 tab.
class _MainPageState extends State<MainPage> {
  int _index = 0; // tab yang sedang aktif (0=Beranda, 1=Library, 2=Profil)

  final _pages = const [HomePage(), LibraryPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack menampilkan satu page saja tapi semua page tetap hidup,
      // jadi daftar game di Home tidak di-load ulang tiap pindah tab
      // dan posisi scroll-nya tetap tersimpan.
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        // Saat tab ditekan, ubah index lalu build ulang
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle), label: 'Library'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
