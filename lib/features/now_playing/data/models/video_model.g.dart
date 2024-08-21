// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VideoAdapter extends TypeAdapter<Video> {
  @override
  final int typeId = 1;

  @override
  Video read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Video(
      iso6391: fields[0] as String,
      iso31661: fields[1] as String,
      name: fields[2] as String,
      key: fields[3] as String,
      site: fields[4] as String,
      size: fields[5] as int,
      type: fields[6] as String,
      official: fields[7] as bool,
      publishedAt: fields[8] as String,
      id: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Video obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.iso6391)
      ..writeByte(1)
      ..write(obj.iso31661)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.key)
      ..writeByte(4)
      ..write(obj.site)
      ..writeByte(5)
      ..write(obj.size)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.official)
      ..writeByte(8)
      ..write(obj.publishedAt)
      ..writeByte(9)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
