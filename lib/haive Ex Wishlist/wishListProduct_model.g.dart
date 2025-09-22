// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishListProduct_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class wishProductAdapter extends TypeAdapter<wishProduct> {
  @override
  final int typeId = 0;

  @override
  wishProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return wishProduct(
      name: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, wishProduct obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is wishProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
