import 'package:hive/hive.dart';
import 'movie_detail_model.dart';

part 'cached_movie_detail.g.dart';

@HiveType(typeId: 3)
class CachedMovieDetail {
  @HiveField(0)
  final MovieDetail movieDetail;

  @HiveField(1)
  final DateTime timestamp;

  CachedMovieDetail({
    required this.movieDetail,
    required this.timestamp,
  });
}
