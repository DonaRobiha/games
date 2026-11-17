import 'package:flutter/material.dart';

import '../services/library_service.dart';
import '../widgets/game_tile.dart';
import 'detail_page.dart';

// Halaman library. StatelessWidget saja cukup karena pembaruan tampilan
// ditangani ValueListenableBuilder yang "mendengarkan" perubahan Hive.
class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Library Anda')),
      body: ValueListenableBuilder(
        valueListenable: LibraryService.listenable,
        builder: (context, _, __) {
          // Dibaca ulang dari Hive setiap ada perubahan (tambah/hapus)
          final games = LibraryService.getAll();
          // Tampilkan pesan kalau library masih kosong
          if (games.isEmpty) {
            return const Center(
              child: Text('Library masih kosong',
                  style: TextStyle(color: Colors.white54)),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            itemCount: games.length,
            itemBuilder: (context, i) {
              final game = games[i];
              return GameTile(
                game: game,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => DetailPage(gameId: game.id)),
                ),
                // Tombol hapus: setelah dihapus dari Hive, list otomatis ter-update
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => LibraryService.remove(game.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
