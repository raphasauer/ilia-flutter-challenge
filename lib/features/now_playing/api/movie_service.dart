import 'package:dartz/dartz.dart';
import 'package:ilia_flutter_challenge/common/entities/failures.dart';
import 'package:ilia_flutter_challenge/features/now_playing/api/api_client.dart';
import 'package:ilia_flutter_challenge/features/now_playing/data/models/movie_detail_model.dart';
import 'package:ilia_flutter_challenge/features/now_playing/data/models/movie_model.dart';

class MovieService {
  final ApiClient client;

  MovieService({required this.client});

  Future<Either<FetchFailure, List<MovieModel>>> fetchPlayingMovies(
      [int page = 1]) async {
    final result = await client
        .fetch('/movie/now_playing', {'language': 'pt-BR', 'page': page});

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

  Future<Either<FetchFailure, MovieDetail>> fetchMovieDetail(
      String movieId) async {
    final result = await client.fetch('/movie/$movieId', {'language': 'pt-BR', 'append_to_response': 'videos'});

    return result.fold(
      (failure) => Left(failure),
      (data) {
        try {
          MovieDetail movieDetail = MovieDetail.fromJson(data);
          return Right(movieDetail);
        } catch (e) {
          return Left(FetchFailure.parsingError(e.toString()));
        }
      },
    );
  }
}
