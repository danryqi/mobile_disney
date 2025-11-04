// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      username: fields[0] as String,
      email: fields[1] as String,
      passwordHash: fields[2] as String,
      coins: fields[3] as int,
      lastClaimDate: fields[4] as DateTime?,
      ownedCharacters: (fields[5] as List?)?.cast<OwnedCharacter>(),
      preferredCurrency: fields[6] as String,
      preferredTimeZone: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.passwordHash)
      ..writeByte(3)
      ..write(obj.coins)
      ..writeByte(4)
      ..write(obj.lastClaimDate)
      ..writeByte(5)
      ..write(obj.ownedCharacters)
      ..writeByte(6)
      ..write(obj.preferredCurrency)
      ..writeByte(7)
      ..write(obj.preferredTimeZone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
