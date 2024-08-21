import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ilia_flutter_challenge/features/now_playing/api/movie_service.dart';
import 'package:ilia_flutter_challenge/features/now_playing/api/api_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final movieServiceProvider = Provider<MovieService>((ref) {
  final apiClient = ApiClient(
    baseUrl: 'https://api.themoviedb.org/3',
    apiKey: dotenv.env['API_KEY']!,
  );
  return MovieService(client: apiClient);
});
