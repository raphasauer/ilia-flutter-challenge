import 'package:flutter/material.dart';
import 'package:ilia_flutter_challenge/features/now_playing/presentation/widgets/movie_tile.dart';
import '../../data/models/movie_model.dart';

class MovieListView extends StatelessWidget {
  final ScrollController scrollController;
  final List<MovieModel> movies;
  final bool isLoadingMore;

  const MovieListView({
    Key? key,
    required this.scrollController,
    required this.movies,
    required this.isLoadingMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: movies.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == movies.length) {
          return const Center(child: CircularProgressIndicator());
        }
        return MovieTile(movie: movies[index]);
      },
    );
  }
}
