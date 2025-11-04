import 'package:hive/hive.dart';

part 'owned_character_model.g.dart';

@HiveType(typeId: 1)
class OwnedCharacter {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String imageUrl;

  @HiveField(3)
  DateTime acquiredAt;

  OwnedCharacter({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.acquiredAt,
  });
}
