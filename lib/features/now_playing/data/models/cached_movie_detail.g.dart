// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_movie_detail.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CachedMovieDetailAdapter extends TypeAdapter<CachedMovieDetail> {
  @override
  final int typeId = 3;

  @override
  CachedMovieDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CachedMovieDetail(
      movieDetail: fields[0] as MovieDetail,
      timestamp: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CachedMovieDetail obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.movieDetail)
      ..writeByte(1)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedMovieDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
