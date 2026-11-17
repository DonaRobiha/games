import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/game.dart';

// Semua urusan request ke API dikumpulkan di sini
// (sesuai syarat soal: fetch & parse dipisah di file tersendiri).
class ApiService {
  static const String _baseUrl = 'https://www.freetogame.com/api';

  // GET /games -> daftar semua game
  static Future<List<Game>> fetchGames() async {
    final res = await http
        .get(Uri.parse('$_baseUrl/games'))
        // timeout supaya loading tidak menggantung selamanya kalau koneksi buruk
        .timeout(const Duration(seconds: 30));

    // 200 = sukses. Selain itu dianggap gagal dan dilempar sebagai error,
    // nanti ditangkap FutureBuilder (snapshot.hasError) di UI.
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat daftar game (${res.statusCode})');
    }

    // Response berupa JSON array -> decode jadi List, lalu tiap elemen
    // diubah menjadi object Game lewat Game.fromJson
    final List data = jsonDecode(res.body);
    return data.map((e) => Game.fromJson(e as Map<String, dynamic>)).toList();
  }

  // GET /game?id=... -> detail satu game
  static Future<GameDetail> fetchGameDetail(int id) async {
    final res = await http
        .get(Uri.parse('$_baseUrl/game?id=$id'))
        .timeout(const Duration(seconds: 30));

    if (res.statusCode != 200) {
      throw Exception('Gagal memuat detail game (${res.statusCode})');
    }

    // Response detail berupa satu JSON object (bukan array)
    return GameDetail.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }
}
