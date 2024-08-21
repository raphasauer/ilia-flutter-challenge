import 'package:hive/hive.dart';

part 'genre_model.g.dart';  

@HiveType(typeId: 0)
class Genre {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
