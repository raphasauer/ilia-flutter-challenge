import 'package:flutter/material.dart';
import '../../data/models/movie_model.dart';
import 'movie_tile.dart';
import 'error_tile.dart';

class MovieListView extends StatelessWidget {
  final ScrollController scrollController;
  final List<MovieModel> movies;
  final bool isLoadingMore;
  final String? errorMessage;
  final VoidCallback onRetry;

  const MovieListView({
    Key? key,
    required this.scrollController,
    required this.movies,
    required this.isLoadingMore,
    this.errorMessage,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: movies.length + (isLoadingMore || errorMessage != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < movies.length) {
          return MovieTile(movie: movies[index]);
        } else if (errorMessage != null) {
          return ErrorTile(errorMessage: errorMessage!, onRetry: onRetry);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
