import 'package:flutter/material.dart';

import '../models/game.dart';
import 'game_network_image.dart';

// Widget item list yang dipakai bersama oleh Home dan Library,
// supaya tampilannya konsisten dan kodenya tidak ditulis dua kali.
class GameTile extends StatelessWidget {
  final Game game;
  final VoidCallback onTap;

  // Widget di sisi kanan. Home memakai panah (default),
  // Library mengisi dengan tombol delete.
  final Widget? trailing;

  const GameTile({
    super.key,
    required this.game,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1C1C1E),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      // antiAlias memotong gambar mengikuti sudut Card yang membulat
      clipBehavior: Clip.antiAlias,
      // InkWell = area bisa diklik + efek ripple
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 78,
          child: Row(
            children: [
              // Thumbnail (kiri). CachedNetworkImage menyimpan gambar di cache
              // sehingga scroll list tidak mengunduh ulang terus-menerus.
              SizedBox(
                width: 100,
                height: double.infinity,
                child: GameNetworkImage(
                  url: game.thumbnail,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorIconSize: 40,
                ),
              ),
              const SizedBox(width: 10),
              // Expanded: teks mengisi sisa lebar agar tidak overflow
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis, // judul panjang jadi "..."
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    // Label genre
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(game.genre,
                          style: const TextStyle(
                              fontSize: 9, color: Colors.white70)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      game.platform,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(fontSize: 10, color: Colors.white54),
                    ),
                  ],
                ),
              ),
              // Kalau trailing tidak diisi, pakai panah default
              trailing ??
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(Icons.chevron_right, color: Colors.white70),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
