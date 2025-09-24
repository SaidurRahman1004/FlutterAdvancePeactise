// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_app_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class noteModleAdapter extends TypeAdapter<noteModle> {
  @override
  final int typeId = 0;

  @override
  noteModle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return noteModle(
      title: fields[0] as String,
      content: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, noteModle obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.content);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is noteModleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
