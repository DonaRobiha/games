import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/game.dart';

// Pengelola library game memakai Hive (database lokal NoSQL).
// Semua method static supaya bisa dipanggil dari mana saja tanpa membuat object.
class LibraryService {
  static const String _boxName = 'library';

  // `late` = diisi nanti, tepatnya saat init() dipanggil di main()
  static late Box _box;

  // Membuka box (mirip "tabel") bernama library
  static Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  // PENTING: listenable memberi tahu UI setiap isi box berubah
  // (tambah/hapus). Dipakai bersama ValueListenableBuilder di Library,
  // Detail (tombol Get) dan Profile (jumlah game), jadi semuanya
  // otomatis update tanpa setState / refresh manual.
  static ValueListenable<Box> get listenable => _box.listenable();

  // Cek apakah game sudah dimiliki. Key box = id game.
  static bool has(int id) => _box.containsKey(id);

  // Tambah game ke library. id dipakai sebagai key sehingga tidak bisa dobel.
  static Future<void> add(Game game) => _box.put(game.id, game.toMap());

  // Hapus game dari library
  static Future<void> remove(int id) => _box.delete(id);

  // Jumlah game di library (untuk Profile Page)
  static int get count => _box.length;

  // Ambil semua game. Data dari Hive bertipe Map<dynamic, dynamic>,
  // jadi harus di-convert dulu ke Map<String, dynamic> sebelum fromMap.
  static List<Game> getAll() => _box.values
      .map((e) => Game.fromMap(Map<String, dynamic>.from(e as Map)))
      .toList();
}
