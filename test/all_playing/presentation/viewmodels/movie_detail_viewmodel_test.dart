import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ilia_flutter_challenge/common/entities/failures.dart';
import 'package:ilia_flutter_challenge/features/now_playing/api/cache_service.dart';
import 'package:ilia_flutter_challenge/features/now_playing/api/movie_service.dart';
import 'package:ilia_flutter_challenge/features/now_playing/data/models/cached_movie_detail.dart';
import 'package:ilia_flutter_challenge/features/now_playing/data/models/movie_detail_model.dart';
import 'package:ilia_flutter_challenge/features/now_playing/presentation/viewmodels/movie_detail_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<MovieService>()])
@GenerateNiceMocks([MockSpec<CacheService>()])
import 'movie_detail_viewmodel_test.mocks.dart';

void main() {
  late MockMovieService mockMovieService;
  late MockCacheService mockCacheService;
  late MovieDetailViewModel viewModel;

  setUp(() {
    mockMovieService = MockMovieService();
    mockCacheService = MockCacheService();
    viewModel = MovieDetailViewModel(mockMovieService, mockCacheService);
  });

  group('MovieDetailViewModel', () {
    test('Should load cached movie details if available and fresh', () async {
      final movieDetail = MovieDetail(
        id: 1,
        title: 'Star Wars: Episode VI - Return of the Jedi',
        overview: 'A longe time ago in a galaxy far away...',
        posterPath: '/rlJ2gf5xG9S6JRf0aXYT1W4f9n9.jpg',
        backdropPath: '/mGyfTtujSihVn9xi8cFDzwKtFGP.jpg',
        releaseDate: '1983-05-25',
        runtime: 131,
        budget: 32000000,
        genres: [],
        homepage: '',
        originalLanguage: 'en',
        voteAverage: 8.0,
        videos: [],
      );

      final cachedMovieDetail = CachedMovieDetail(
        movieDetail: movieDetail,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      );

      when(mockCacheService.getCachedData(any)).thenReturn(cachedMovieDetail);

      await viewModel.loadMovieDetail('1');

      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.movieDetail, movieDetail);
      verify(mockCacheService.getCachedData('1')).called(1);
      verifyNever(mockMovieService.fetchMovieDetail(any));
    });

    test('Should fetch new movie details if cache is stale', () async {
      final movieDetail = MovieDetail(
        id: 1,
        title: 'Star Wars: Episode VI - Return of the Jedi',
        overview: 'A longe time ago in a galaxy far away...',
        posterPath: '/rlJ2gf5xG9S6JRf0aXYT1W4f9n9.jpg',
        backdropPath: '/mGyfTtujSihVn9xi8cFDzwKtFGP.jpg',
        releaseDate: '1983-05-25',
        runtime: 131,
        budget: 32000000,
        genres: [],
        homepage: '',
        originalLanguage: 'en',
        voteAverage: 8.0,
        videos: [],
      );

      final staleCache = CachedMovieDetail(
        movieDetail: movieDetail,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      );

      when(mockCacheService.getCachedData(any)).thenReturn(staleCache);

      when(mockMovieService.fetchMovieDetail(any))
          .thenAnswer((_) async => Right(movieDetail));

      await viewModel.loadMovieDetail('1');

      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.movieDetail, movieDetail);
      verify(mockCacheService.getCachedData('1')).called(1);
      verify(mockMovieService.fetchMovieDetail('1')).called(1);
      verify(mockCacheService.putCachedData('1', any)).called(1);
    });

    test('Should handle error when fetching movie details', () async {
      when(mockCacheService.getCachedData(any)).thenReturn(null);

      when(mockMovieService.fetchMovieDetail(any)).thenAnswer((_) async =>
          const Left(FetchFailure(message: 'Failed to load movie details')));

      await viewModel.loadMovieDetail('1');

      expect(viewModel.state.isLoading, false);
      expect(
          viewModel.state.errorMessage, 'Erro ao carregar detalhes do filme');
      verify(mockCacheService.getCachedData('1')).called(1);
      verify(mockMovieService.fetchMovieDetail('1')).called(1);
      verifyNever(mockCacheService.putCachedData(any, any));
    });
  });
}
