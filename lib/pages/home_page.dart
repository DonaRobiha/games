import 'package:flutter/material.dart';

import '../models/game.dart';
import '../services/api_service.dart';
import '../widgets/game_tile.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// Halaman Home: menampilkan daftar game dari API dalam ListView.
class _HomePageState extends State<HomePage> {
  // Future disimpan sebagai variabel (diisi di initState) supaya request API
  // hanya jalan sekali, bukan setiap build() dipanggil ulang.
  late Future<List<Game>> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.fetchGames();
  }

  // Dipanggil tombol "Coba lagi" untuk mengulang request saat gagal
  void _reload() => setState(() => _future = ApiService.fetchGames());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Browse Games')),
      // FutureBuilder membangun UI sesuai status request: loading / error / sukses
      body: FutureBuilder<List<Game>>(
        future: _future,
        builder: (context, snapshot) {
          // 1) Sedang loading -> tampilkan loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 2) Gagal (tidak ada internet, server error, dll) -> pesan + tombol ulang
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off, size: 40, color: Colors.white54),
                  const SizedBox(height: 8),
                  const Text('Gagal memuat data'),
                  TextButton(onPressed: _reload, child: const Text('Coba lagi')),
                ],
              ),
            );
          }
          // 3) Sukses -> tampilkan list. ListView.builder hanya membangun item
          //    yang terlihat di layar, jadi tetap ringan walau datanya ribuan.
          final games = snapshot.data ?? [];
          return ListView.builder(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            itemCount: games.length,
            itemBuilder: (context, i) {
              final game = games[i];
              return GameTile(
                game: game,
                // Klik item -> buka Detail dengan mengirim id game
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => DetailPage(gameId: game.id)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
