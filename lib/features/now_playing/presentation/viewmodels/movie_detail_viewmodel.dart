import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:ilia_flutter_challenge/features/now_playing/api/movie_service.dart';

import '../../data/models/movie_detail_model.dart';
import '../../providers/movie_service_provider.dart';

class MovieDetailState {
  final bool isLoading;
  final MovieDetail? movieDetail;
  final String? errorMessage;

  MovieDetailState({
    required this.isLoading,
    this.movieDetail,
    this.errorMessage,
  });

  MovieDetailState copyWith({
    bool? isLoading,
    MovieDetail? movieDetail,
    String? errorMessage,
  }) {
    return MovieDetailState(
      isLoading: isLoading ?? this.isLoading,
      movieDetail: movieDetail ?? this.movieDetail,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class MovieDetailViewModel extends StateNotifier<MovieDetailState> {
  final MovieService movieService;
  final Box box = Hive.box('movieDetails');

  MovieDetailViewModel(this.movieService)
      : super(MovieDetailState(isLoading: true));

  Future<void> loadMovieDetail(String movieId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final cachedMovie = box.get(movieId);
    if (cachedMovie != null) {
      log('[loadMovieDetail] Cache hit, using stored information...');
      state = state.copyWith(isLoading: false, movieDetail: cachedMovie);
      return;
    }

    final result = await movieService.fetchMovieDetail(movieId);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erro ao carregar detalhes do filme',
      ),
      (movieDetail) {
        log('[loadMovieDetail] Caching movie details...');
        box.put(movieId, movieDetail);
        state = state.copyWith(
          isLoading: false,
          movieDetail: movieDetail,
        );
      },
    );
  }
}

final movieDetailViewModelProvider = StateNotifierProvider.family<
    MovieDetailViewModel, MovieDetailState, String>((ref, movieId) {
  final movieService = ref.watch(movieServiceProvider);
  return MovieDetailViewModel(movieService)..loadMovieDetail(movieId);
});
