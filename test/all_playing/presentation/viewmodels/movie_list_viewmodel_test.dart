import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ilia_flutter_challenge/common/entities/failures.dart';
import 'package:ilia_flutter_challenge/features/now_playing/api/movie_service.dart';
import 'package:ilia_flutter_challenge/features/now_playing/data/models/movie_model.dart';
import 'package:ilia_flutter_challenge/features/now_playing/presentation/viewmodels/movie_list_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<MovieService>()])
import 'movie_list_viewmodel_test.mocks.dart';

void main() {
  var mockMovieService = MockMovieService();

  test('Should initialize a MovieListViewModel correctly', () {
    when(mockMovieService.fetchPlayingMovies()).thenAnswer(
      (_) async => const Right([]),
    );
    var viewModel = MovieListViewModel(mockMovieService);
    expect(viewModel.state.isLoading, true);
  });

  test('Should load movies successfully and update the state', () async {
    final mockMovies = [
      MovieModel(
        id: 1,
        originalLanguage: 'en',
        originalTitle: 'Star Wars Episode IV: A New Hope',
        overview: 'Há muito tempo em uma galáxia muito distante...',
        popularity: 10.0,
        posterPath: '/path1.jpg',
        releaseDate: '1977',
        title: 'Guerra Nas Estrelas Episódio IV: Uma Nova Esperança',
        video: false,
        voteAverage: 10.0,
        voteCount: 100,
      ),
      MovieModel(
        id: 2,
        originalLanguage: 'en',
        originalTitle: 'Star Wars Episode V: The Empire Strikes Back',
        overview: 'Yoda, nesse filme, você conhecer',
        popularity: 9.5,
        posterPath: '/path2.jpg',
        releaseDate: '1981',
        title: 'Guerra Nas Estrelas Episódio V: O Império Contra-Ataca',
        video: false,
        voteAverage: 10.0,
        voteCount: 150,
      ),
    ];

    when(mockMovieService.fetchPlayingMovies(any)).thenAnswer(
      (_) async => Right(mockMovies),
    );

    var viewModel = MovieListViewModel(mockMovieService);

    await viewModel.loadMovies();

    expect(viewModel.state.isLoading, false);
    expect(viewModel.state.movies, mockMovies);
    expect(viewModel.state.filteredMovies, mockMovies);
    expect(viewModel.state.errorMessage, null);
    expect(viewModel.state.nextPage, 3);
  });

  test('Should handle error when loading movies', () async {
    when(mockMovieService.fetchPlayingMovies(any)).thenAnswer(
      (_) async => const Left(FetchFailure(message: 'Erro ao carregar filmes')),
    );

    var viewModel = MovieListViewModel(mockMovieService);

    await viewModel.loadMovies();

    expect(viewModel.state.isLoading, false);
    expect(viewModel.state.movies.isEmpty, true);
    expect(viewModel.state.filteredMovies.isEmpty, true);
    expect(viewModel.state.errorMessage, 'Falha ao carregar filmes.');
  });

  test('Should load more movies and update the state', () async {
    final initialMovies = [
      MovieModel(
        id: 1,
        originalLanguage: 'en',
        originalTitle: 'Star Wars Episode IV: A New Hope',
        overview: 'Há muito tempo em uma galáxia muito distante...',
        popularity: 10.0,
        posterPath: '/path1.jpg',
        releaseDate: '1977',
        title: 'Guerra Nas Estrelas Episódio IV: Uma Nova Esperança',
        video: false,
        voteAverage: 10.0,
        voteCount: 100,
      ),
    ];

    final additionalMovies = [
      MovieModel(
        id: 2,
        originalLanguage: 'en',
        originalTitle: 'Star Wars Episode V: The Empire Strikes Back',
        overview: 'Yoda, nesse filme, você conhecer',
        popularity: 9.5,
        posterPath: '/path2.jpg',
        releaseDate: '1981',
        title: 'Guerra Nas Estrelas Episódio V: O Império Contra-Ataca',
        video: false,
        voteAverage: 10.0,
        voteCount: 150,
      ),
    ];

    when(mockMovieService.fetchPlayingMovies(any)).thenAnswer(
      (_) async => Right(initialMovies),
    );

    var viewModel = MovieListViewModel(mockMovieService);

    when(mockMovieService.fetchPlayingMovies(any)).thenAnswer(
      (_) async => Right(additionalMovies),
    );

    await viewModel.loadMoreMovies();

    expect(viewModel.state.isLoadingMore, false);
    expect(viewModel.state.movies.length, 2);
    expect(viewModel.state.movies, [...initialMovies, ...additionalMovies]);
    expect(viewModel.state.nextPage, 3);
  });

  test('Should update search query and filter movies', () async {
    final mockMovies = [
      MovieModel(
        id: 1,
        originalLanguage: 'en',
        originalTitle: 'Star Wars Episode IV: A New Hope',
        overview: 'Há muito tempo em uma galáxia muito distante...',
        popularity: 10.0,
        posterPath: '/path1.jpg',
        releaseDate: '1977',
        title: 'Guerra Nas Estrelas Episódio IV: Uma Nova Esperança',
        video: false,
        voteAverage: 10.0,
        voteCount: 100,
      ),
      MovieModel(
        id: 2,
        originalLanguage: 'en',
        originalTitle: 'Star Wars Episode V: The Empire Strikes Back',
        overview: 'Yoda, nesse filme, você conhecer',
        popularity: 9.5,
        posterPath: '/path2.jpg',
        releaseDate: '1981',
        title: 'Guerra Nas Estrelas Episódio V: O Império Contra-Ataca',
        video: false,
        voteAverage: 10.0,
        voteCount: 150,
      ),
    ];

    when(mockMovieService.fetchPlayingMovies(any)).thenAnswer(
      (_) async => Right(mockMovies),
    );

    var viewModel = MovieListViewModel(mockMovieService);

    await viewModel.loadMovies();

    viewModel.updateSearchQuery('Império');

    expect(viewModel.state.filteredMovies.length, 1);
    expect(viewModel.state.filteredMovies.first.title,
        'Guerra Nas Estrelas Episódio V: O Império Contra-Ataca');
  });
}
