import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ilia_flutter_challenge/features/now_playing/api/movie_service.dart';
import 'package:ilia_flutter_challenge/features/now_playing/presentation/widgets/movie_tile.dart';

import '../../api/api_client.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var apiClient = ApiClient(
      baseUrl: 'https://api.themoviedb.org/3', apiKey: dotenv.env['API_KEY']!);

  late MovieService movieService;

  @override
  void initState() {
    movieService = MovieService(client: apiClient);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder(
          future: movieService.fetchPlayingMovies(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return snapshot.data!.fold(
                (l) => const Text('Opsie dupsie'),
                (r) => Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) => MovieTile(movie: r[index]),
                    itemCount: r.length,
                  ),
                ),
              );
            } else {
              return const Text('No data available');
            }
          },
        ),
      ),
    );
  }
}
