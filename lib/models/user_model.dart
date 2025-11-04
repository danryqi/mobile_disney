import 'package:hive/hive.dart';
import 'owned_character_model.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1)
  String email;

  @HiveField(2)
  String passwordHash;

  @HiveField(3)
  int coins;

  @HiveField(4)
  DateTime? lastClaimDate;

  @HiveField(5)
  List<OwnedCharacter> ownedCharacters;

  // 🆕 Preferensi tambahan (zona waktu & mata uang)
  @HiveField(6)
  String preferredCurrency;

  @HiveField(7)
  String preferredTimeZone;

  User({
    required this.username,
    required this.email,
    required this.passwordHash,
    this.coins = 0,
    this.lastClaimDate,
    List<OwnedCharacter>? ownedCharacters,
    this.preferredCurrency = 'IDR',
    this.preferredTimeZone = 'WIB',
  }) : ownedCharacters = ownedCharacters ?? [];
}
