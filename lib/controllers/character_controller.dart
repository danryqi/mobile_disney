import '../models/character_model.dart';
import '../models/owned_character_model.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/hive_service.dart';

class CharacterController {
  final ApiService apiService;
  final HiveService hiveService;

  CharacterController(this.apiService, this.hiveService);

  /// Mengambil data karakter dari Disney API dan memberikan fallback data
  Future<List<Character>> getCharacters() async {
    final characters = await apiService.fetchCharacters();

    // Fallback data aman (null-safe)
    return characters.map((c) {
      return Character(
        id: c.id,
        name: (c.name != null && c.name.isNotEmpty)
            ? c.name
            : 'Unknown Character',
        imageUrl: (c.imageUrl != null && c.imageUrl.isNotEmpty)
            ? c.imageUrl
            : 'https://via.placeholder.com/150',
        films: (c.films != null && c.films.isNotEmpty)
            ? c.films
            : ['Unknown Film'],
        tvShows: (c.tvShows != null && c.tvShows.isNotEmpty)
            ? c.tvShows
            : ['Unknown Show'],
        videoGames: (c.videoGames != null && c.videoGames.isNotEmpty)
            ? c.videoGames
            : ['Unknown Game'],
        price: (c.price > 0) ? c.price : 10,
        priceInCoins: (c.priceInCoins > 0) ? c.priceInCoins : 10,
      );
    }).toList();
  }

  /// Menambahkan karakter yang dibeli ke koleksi user di Hive
  Future<bool> buyCharacter(User user, Character character) async {
    final alreadyOwned =
        user.ownedCharacters.any((c) => c.id == character.id);
    if (alreadyOwned) return false;

    final newOwned = OwnedCharacter(
      id: character.id,
      name: character.name,
      imageUrl: character.imageUrl,
      acquiredAt: DateTime.now(),
    );

    user.ownedCharacters.add(newOwned);
    await hiveService.updateUser(user);
    return true;
  }
}
