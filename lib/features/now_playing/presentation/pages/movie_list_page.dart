import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ilia_flutter_challenge/features/now_playing/api/movie_service.dart';
import 'package:ilia_flutter_challenge/features/now_playing/presentation/widgets/movie_tile.dart';

import '../../api/api_client.dart';
import '../../models/movie_model.dart';

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
  List<MovieModel> movies = [];
  int currentPage = 1;
  bool isLoadingMore = false;
  bool hasMoreMovies = true;
  bool isLoadingInitial = true;
  String? initialLoadError;
  String? loadMoreError;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    movieService = MovieService(client: apiClient);
    _loadInitialMovies();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadMoreMovies();
      }
    });
    super.initState();
  }

  Future<void> _loadInitialMovies() async {
    setState(() {
      isLoadingInitial = true;
      initialLoadError = null;
    });

    final result = await movieService.fetchPlayingMovies(currentPage);

    result.fold(
      (l) {
        setState(() {
          isLoadingInitial = false;
          initialLoadError = "Falha ao carregar filmes.";
        });
      },
      (r) {
        setState(() {
          movies = r;
          currentPage++;
          isLoadingInitial = false;
        });
      },
    );
  }

  Future<void> _loadMoreMovies() async {
    if (!hasMoreMovies || isLoadingMore) return;

    setState(() {
      isLoadingMore = true;
      loadMoreError = null;
    });

    final result = await movieService.fetchPlayingMovies(currentPage);

    result.fold(
      (l) {
        setState(() {
          isLoadingMore = false;
          loadMoreError = "Falha ao carregar os filmes";
        });
      },
      (r) {
        setState(() {
          movies.addAll(r);
          isLoadingMore = false;
          currentPage++;
          if (r.isEmpty) {
            hasMoreMovies = false;
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isLoadingInitial
          ? const Center(child: CircularProgressIndicator())
          : initialLoadError != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(initialLoadError!),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _loadInitialMovies,
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: movies.length + (isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == movies.length) {
                      if (loadMoreError != null) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(loadMoreError!),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: _loadMoreMovies,
                                child: const Text('Tentar novamente'),
                              ),
                            ],
                          ),
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    }
                    return MovieTile(movie: movies[index]);
                  },
                ),
    );
  }
}
