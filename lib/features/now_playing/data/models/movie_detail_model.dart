import 'package:hive/hive.dart';
import 'package:ilia_flutter_challenge/features/now_playing/data/models/video_model.dart';
import 'genre_model.dart';

part 'movie_detail_model.g.dart'; 

@HiveType(typeId: 2)
class MovieDetail {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String overview;

  @HiveField(3)
  final String posterPath;

  @HiveField(4)
  final String backdropPath;

  @HiveField(5)
  final String releaseDate;

  @HiveField(6)
  final int runtime;

  @HiveField(7)
  final int budget;

  @HiveField(8)
  final List<Genre> genres;

  @HiveField(9)
  final String homepage;

  @HiveField(10)
  final String originalLanguage;

  @HiveField(11)
  final double voteAverage;

  @HiveField(12)
  final List<Video> videos;

  MovieDetail({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.runtime,
    required this.budget,
    required this.genres,
    required this.homepage,
    required this.originalLanguage,
    required this.voteAverage,
    required this.videos,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      releaseDate: json['release_date'],
      runtime: json['runtime'],
      budget: json['budget'],
      genres: (json['genres'] as List)
          .map((genre) => Genre.fromJson(genre))
          .toList(),
      homepage: json['homepage'],
      originalLanguage: json['original_language'],
      voteAverage: json['vote_average'].toDouble(),
      videos: (json['videos']['results'] as List)
          .map((video) => Video.fromJson(video))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'release_date': releaseDate,
      'runtime': runtime,
      'budget': budget,
      'genres': genres.map((genre) => genre.toJson()).toList(),
      'homepage': homepage,
      'original_language': originalLanguage,
      'vote_average': voteAverage,
      'videos': videos.map((video) => video.toJson()).toList(),
    };
  }
}
