import 'package:dartz/dartz.dart';
import 'package:ilia_flutter_challenge/common/entities/failures.dart';
import 'package:ilia_flutter_challenge/features/now_playing/api/api_client.dart';
import 'package:ilia_flutter_challenge/features/now_playing/models/movie_model.dart';

class MovieService {
  final ApiClient client;

  MovieService({required this.client});

  Future<Either<FetchFailure, List<MovieModel>>> fetchPlayingMovies() async {
    final result = await client.fetch('/movie/now_playing');

    return result.fold(
      (failure) => Left(failure),
      (data) {
        try {
          List<MovieModel> movies = (data['results'] as List)
              .map((movie) => MovieModel.fromJson(movie))
              .toList();
          return Right(movies);
        } catch (e) {
          return Left(FetchFailure.parsingError(e.toString()));
        }
      },
    );
  }
}
