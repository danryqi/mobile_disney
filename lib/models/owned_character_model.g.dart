// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owned_character_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OwnedCharacterAdapter extends TypeAdapter<OwnedCharacter> {
  @override
  final int typeId = 1;

  @override
  OwnedCharacter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OwnedCharacter(
      id: fields[0] as int,
      name: fields[1] as String,
      imageUrl: fields[2] as String,
      acquiredAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, OwnedCharacter obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.acquiredAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OwnedCharacterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
