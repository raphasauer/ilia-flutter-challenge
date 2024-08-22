import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ilia_flutter_challenge/features/now_playing/api/movie_service.dart';

import '../../data/models/movie_model.dart';
import '../../providers/movie_service_provider.dart';

class MovieListState {
  final bool isLoading;
  final bool isLoadingMore;
  final List<MovieModel> movies;
  final List<MovieModel> filteredMovies;
  final String? errorMessage;
  final String searchQuery;
  final int nextPage;
  final bool hasMoreMovies;

  MovieListState({
    required this.isLoading,
    required this.isLoadingMore,
    required this.movies,
    required this.filteredMovies,
    this.errorMessage,
    this.searchQuery = '',
    this.nextPage = 1,
    this.hasMoreMovies = true,
  });

  MovieListState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<MovieModel>? movies,
    List<MovieModel>? filteredMovies,
    String? errorMessage,
    String? searchQuery,
    int? nextPage,
    bool? hasMoreMovies,
  }) {
    return MovieListState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      movies: movies ?? this.movies,
      filteredMovies: filteredMovies ?? this.filteredMovies,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      nextPage: nextPage ?? this.nextPage,
      hasMoreMovies: hasMoreMovies ?? this.hasMoreMovies,
    );
  }
}

class MovieListViewModel extends StateNotifier<MovieListState> {
  final MovieService movieService;

  MovieListViewModel(this.movieService)
      : super(MovieListState(
          isLoading: true,
          isLoadingMore: false,
          movies: [],
          filteredMovies: [],
        )) {
    loadMovies();
  }

  Future<void> loadMovies() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await movieService.fetchPlayingMovies(state.nextPage);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: "Falha ao carregar filmes.",
      ),
      (movies) => state = state.copyWith(
        isLoading: false,
        movies: movies,
        filteredMovies: _applySearch(movies, state.searchQuery),
        nextPage: state.nextPage + 1,
      ),
    );
  }

  Future<void> loadMoreMovies() async {
    if (!state.hasMoreMovies || state.isLoadingMore) return;

    state = state.copyWith(isLoadingMore: true, errorMessage: null);
    final result = await movieService.fetchPlayingMovies(state.nextPage);

    result.fold(
      (failure) => state = state.copyWith(
        isLoadingMore: false,
        errorMessage: "Falha ao carregar mais filmes.",
      ),
      (movies) {
        final allMovies = List<MovieModel>.from(state.movies)..addAll(movies);
        state = state.copyWith(
          isLoadingMore: false,
          movies: allMovies,
          filteredMovies: _applySearch(allMovies, state.searchQuery),
          nextPage: state.nextPage + 1,
          hasMoreMovies: movies.isNotEmpty,
        );
      },
    );
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(
      searchQuery: query,
      filteredMovies: _applySearch(state.movies, query),
    );
  }

  void updateSortBy(String sortBy) {
    state = state.copyWith(
      filteredMovies: _applySearch(state.movies, state.searchQuery),
    );
  }

  List<MovieModel> _applySearch(List<MovieModel> movies, String searchQuery) {
    var newFilteredMovies = movies.where((movie) {
      return movie.title.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return newFilteredMovies;
  }
}

final movieListViewModelProvider =
    StateNotifierProvider<MovieListViewModel, MovieListState>((ref) {
  final movieService = ref.watch(movieServiceProvider);
  return MovieListViewModel(movieService);
});
