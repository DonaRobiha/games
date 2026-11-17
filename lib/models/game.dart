// Model untuk game di daftar (endpoint /games).
// Hanya berisi data yang dibutuhkan untuk list di Home & Library.
class Game {
  final int id;
  final String title;
  final String thumbnail;
  final String genre;
  final String platform;

  Game({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.genre,
    required this.platform,
  });

  // Mengubah JSON dari API menjadi object Game.
  // Key harus sama persis dengan response API (id, title, thumbnail, ...).
  // Operator `??` dipakai sebagai nilai cadangan kalau data null,
  // supaya aplikasi tidak crash.
  factory Game.fromJson(Map<String, dynamic> json) => Game(
        id: json['id'] ?? 0,
        title: json['title'] ?? '-',
        thumbnail: json['thumbnail'] ?? '',
        genre: json['genre'] ?? '-',
        platform: json['platform'] ?? '-',
      );

  // Kebalikan fromJson: object -> Map, dipakai untuk menyimpan ke Hive.
  // Hive bisa menyimpan Map biasa, jadi tidak perlu TypeAdapter / build_runner.
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'thumbnail': thumbnail,
        'genre': genre,
        'platform': platform,
      };

  // Membaca kembali Map dari Hive menjadi object Game
  factory Game.fromMap(Map<String, dynamic> map) => Game.fromJson(map);
}

// Model untuk detail game (endpoint /game?id=...).
// `extends Game` supaya semua field dasar (id, title, dll) diwarisi,
// jadi GameDetail juga bisa langsung disimpan ke library sebagai Game.
class GameDetail extends Game {
  final String description;
  final String publisher;
  final String developer;
  final String releaseDate;
  final List<String> screenshots; // list URL gambar

  GameDetail({
    // `super.xxx` meneruskan parameter ke constructor Game
    required super.id,
    required super.title,
    required super.thumbnail,
    required super.genre,
    required super.platform,
    required this.description,
    required this.publisher,
    required this.developer,
    required this.releaseDate,
    required this.screenshots,
  });

  factory GameDetail.fromJson(Map<String, dynamic> json) {
    // Di API, screenshots berbentuk list of object: [{"id":1,"image":"url"}, ...]
    // Kita ambil key "image" saja dan jadikan List<String>.
    final shots = (json['screenshots'] as List? ?? [])
        .map((e) => (e as Map)['image'].toString())
        .toList();

    return GameDetail(
      id: json['id'] ?? 0,
      title: json['title'] ?? '-',
      thumbnail: json['thumbnail'] ?? '',
      genre: json['genre'] ?? '-',
      platform: json['platform'] ?? '-',
      description: json['description'] ?? '-',
      publisher: json['publisher'] ?? '-',
      developer: json['developer'] ?? '-',
      // Di API key-nya "release_date" (snake_case), bukan releaseDate
      releaseDate: json['release_date'] ?? '-',
      screenshots: shots,
    );
  }
}
