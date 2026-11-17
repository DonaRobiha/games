import 'package:flutter/material.dart';

import '../models/game.dart';
import '../services/api_service.dart';
import '../services/library_service.dart';
import '../widgets/game_network_image.dart';

class DetailPage extends StatefulWidget {
  final int gameId;
  const DetailPage({super.key, required this.gameId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

// Halaman detail. Hanya menerima id game, lalu mengambil data lengkapnya
// dari API. Dengan begitu halaman yang sama bisa dibuka dari Home maupun Library.
class _DetailPageState extends State<DetailPage> {
  late Future<GameDetail> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.fetchGameDetail(widget.gameId);
  }

  // Kotak kecil berbingkai untuk genre & platform
  Widget _tag(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white38),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(text, style: const TextStyle(fontSize: 10)),
      );

  // Satu kolom info (label kecil + nilai), dipakai untuk tanggal rilis, publisher, developer
  Widget _info(String label, String value) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 10, color: Colors.white54)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontSize: 12)),
          ],
        ),
      );

  // Helper gambar jaringan dengan fallback yang sesuai untuk web dan mobile
  Widget _image(String url, {double? height, double? width}) =>
      GameNetworkImage(
        url: url,
        height: height,
        width: width,
        fit: BoxFit.cover,
      );

  // Tombol "Get". Tampilannya berbeda tergantung game sudah dimiliki atau belum.
  // Dibungkus ValueListenableBuilder agar berubah otomatis begitu isi Hive berubah.
  Widget _getButton(GameDetail game) {
    return ValueListenableBuilder(
      valueListenable: LibraryService.listenable,
      builder: (context, _, __) {
        // Cek ke Hive: apakah game ini sudah ada di library?
        final owned = LibraryService.has(game.id);
        return SizedBox(
          width: double.infinity,
          height: 42,
          child: ElevatedButton.icon(
            // Sudah dimiliki -> tombol nonaktif (abu-abu, "In Library").
            // Belum -> tombol biru "Get" yang menyimpan game ke Hive.
            onPressed: owned ? null : () => LibraryService.add(game),
            icon: Icon(owned ? Icons.check : Icons.add, size: 18),
            label: Text(owned ? 'In Library' : 'Get'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2D8CFF),
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey[800],
              disabledForegroundColor: Colors.white70,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      // Pola sama seperti Home: loading -> error -> tampilkan data
      body: FutureBuilder<GameDetail>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Gagal memuat detail game'));
          }
          final game = snapshot.data!;
          return ListView(
            children: [
              // Hero image: thumbnail besar di paling atas
              _image(game.thumbnail, height: 210, width: double.infinity),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      _tag(game.genre),
                      const SizedBox(width: 6),
                      _tag(game.platform),
                    ]),
                    const SizedBox(height: 10),
                    Text(game.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Row(children: [
                      _info('Release Date', game.releaseDate),
                      _info('Publisher', game.publisher),
                      _info('Developer', game.developer),
                    ]),
                    const SizedBox(height: 16),
                    _getButton(game),
                    const SizedBox(height: 18),
                    const Text('Screenshots',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    // Screenshots: ListView horizontal yang bisa digeser ke samping
                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: game.screenshots.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (_, i) => ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: _image(game.screenshots[i],
                              height: 80, width: 125),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text('Overview',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(game.description,
                        style: const TextStyle(
                            fontSize: 12, height: 1.4, color: Colors.white70)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
