class Character {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> films;
  final List<String> tvShows;
  final List<String> videoGames;
  final double price;
  final double priceInCoins;

  Character({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.films,
    required this.tvShows,
    required this.videoGames,
    required this.price,
    required this.priceInCoins,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      // Aman dari null dan tipe data campuran
      id: (json['_id'] is int)
          ? json['_id']
          : int.tryParse('${json['_id']}') ?? 0,
      name: (json['name'] ?? 'Unknown Character').toString(),
      imageUrl: (json['imageUrl'] ?? 'https://via.placeholder.com/150')
          .toString(),
      films: (json['films'] is List)
          ? List<String>.from(json['films'])
          : [],
      tvShows: (json['tvShows'] is List)
          ? List<String>.from(json['tvShows'])
          : [],
      videoGames: (json['videoGames'] is List)
          ? List<String>.from(json['videoGames'])
          : [],
      // Harga dan coin berdasarkan ID (deterministik)
      price: ((json['_id'] ?? 1) % 50 + 10).toDouble(),
      priceInCoins: ((json['_id'] ?? 1) % 50 + 10).toDouble(),
    );
  }
}
