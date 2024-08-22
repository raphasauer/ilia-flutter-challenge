import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ilia_flutter_challenge/features/now_playing/api/cache_service.dart';
import 'package:ilia_flutter_challenge/features/now_playing/api/movie_service.dart';
import 'package:ilia_flutter_challenge/features/now_playing/providers/cache_service_provider.dart';

import '../../data/models/cached_movie_detail.dart';
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
  final CacheService cacheService;

  MovieDetailViewModel(this.movieService, this.cacheService)
      : super(MovieDetailState(isLoading: true));

  Future<void> loadMovieDetail(String movieId) async {
    const cacheDuration = Duration(hours: 24);

    final cachedData = cacheService.getCachedData(movieId);
    if (cachedData != null &&
        DateTime.now().difference(cachedData.timestamp) < cacheDuration) {
      log('[loadMovieDetail] Cached timestamp within tolerance, using cached information');
      state =
          state.copyWith(isLoading: false, movieDetail: cachedData.movieDetail);
      return;
    }

    final result = await movieService.fetchMovieDetail(movieId);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erro ao carregar detalhes do filme',
      ),
      (movieDetail) {
        final cachedMovieDetail = CachedMovieDetail(
          movieDetail: movieDetail,
          timestamp: DateTime.now(),
        );
        log('[loadMovieDetail] Caching data...');
        cacheService.putCachedData(movieId, cachedMovieDetail);

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
  final cacheService = ref.watch(cacheServiceProvider);
  return MovieDetailViewModel(movieService, cacheService)
    ..loadMovieDetail(movieId);
});
