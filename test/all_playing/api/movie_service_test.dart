import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ilia_flutter_challenge/common/entities/failures.dart';
import 'package:ilia_flutter_challenge/features/now_playing/api/api_client.dart';
import 'package:ilia_flutter_challenge/features/now_playing/api/movie_service.dart';
import 'package:ilia_flutter_challenge/features/now_playing/data/models/movie_detail_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<ApiClient>()])
import 'movie_service_test.mocks.dart';

void main() {
  late MockApiClient mockApiClient;
  late MovieService movieService;

  setUp(() {
    mockApiClient = MockApiClient();
    movieService = MovieService(client: mockApiClient);
  });

  group('fetchPlayingMovies', () {
    test('Should return a list of movies on a successful API call', () async {
      final mockApiResponse = {
        'results': [
          {
            'id': 1,
            'original_language': 'en',
            'original_title': 'Star Wars Episode IV: A New Hope',
            'overview': 'A long time ago in a galaxy far, far away...',
            'popularity': 10.0,
            'poster_path': '/path1.jpg',
            'release_date': '1977-05-25',
            'title': 'Star Wars Episode IV: A New Hope',
            'video': false,
            'vote_average': 10.0,
            'vote_count': 100,
          },
        ],
      };

      when(mockApiClient.fetch(any, any)).thenAnswer(
        (_) async => Right(mockApiResponse),
      );

      final result = await movieService.fetchPlayingMovies();

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []).length, 1);
      expect(result.getOrElse(() => [])[0].title,
          'Star Wars Episode IV: A New Hope');
    });

    test('Should return a FetchFailure on API call failure', () async {
      when(mockApiClient.fetch(any, any)).thenAnswer(
        (_) async => const Left(FetchFailure(message: 'API error')),
      );

      final result = await movieService.fetchPlayingMovies();

      expect(result.isLeft(), true);
      expect(result.fold((failure) => failure.message, (_) => ''), 'API error');
    });

    test('Should return a FetchFailure on parsing error', () async {
      final invalidApiResponse = {
        'results': 'Invalid data',
      };

      when(mockApiClient.fetch(any, any)).thenAnswer(
        (_) async => Right(invalidApiResponse),
      );

      final result = await movieService.fetchPlayingMovies();

      expect(result.isLeft(), true);
      expect(result.fold((failure) => failure.message, (_) => ''),
          contains('parse'));
    });
  });

  group('fetchMovieDetail', () {
    test('Should return movie details on a successful API call', () async {
      final mockApiResponse = {
        'id': 1,
        'title': 'Star Wars Episode IV: A New Hope',
        'overview': 'A long time ago in a galaxy far, far away...',
        'poster_path': '/path1.jpg',
        'backdrop_path': '/backdrop.jpg',
        'release_date': '1977-05-25',
        'runtime': 121,
        'budget': 11000000,
        'genres': [
          {'id': 1, 'name': 'Action'},
          {'id': 2, 'name': 'Adventure'},
          {'id': 3, 'name': 'Science Fiction'},
        ],
        'homepage': 'https://www.starwars.com',
        'original_language': 'en',
        'vote_average': 8.5,
        'videos': {
          'results': [
            {
              'iso_639_1': 'en',
              'iso_3166_1': 'US',
              'name': 'Official Trailer',
              'key': 'vZ734NWnAHA',
              'site': 'YouTube',
              'size': 1080,
              'type': 'Trailer',
              'official': true,
              'published_at': '2019-12-20T00:00:00Z',
              'id': '12345',
            }
          ]
        },
      };

      when(mockApiClient.fetch(any, any)).thenAnswer(
        (_) async => Right(mockApiResponse),
      );

      final result = await movieService.fetchMovieDetail('1');

      expect(result.isRight(), true);
      expect(
          result
              .getOrElse(
                () => MovieDetail(
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
                ),
              )
              .title,
          'Star Wars Episode IV: A New Hope');
    });

    test('Should return a FetchFailure on API call failure', () async {
      when(mockApiClient.fetch(any, any)).thenAnswer(
        (_) async => const Left(FetchFailure(message: 'API error')),
      );

      final result = await movieService.fetchMovieDetail('1');

      expect(result.isLeft(), true);
      expect(result.fold((failure) => failure.message, (_) => ''), 'API error');
    });

    test('Should return a FetchFailure on parsing error', () async {
      final invalidApiResponse = {
        'id': 'invalid',
      };

      when(mockApiClient.fetch(any, any)).thenAnswer(
        (_) async => Right(invalidApiResponse),
      );

      final result = await movieService.fetchMovieDetail('1');

      expect(result.isLeft(), true);
      expect(result.fold((failure) => failure.message, (_) => ''),
          contains('parse'));
    });
  });
}
