import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../data/models/movie_model.dart';
import '../viewmodels/movie_detail_viewmodel.dart';

class MovieDetailPage extends ConsumerWidget {
  final MovieModel movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(movieDetailViewModelProvider(movie.id.toString()));
    final viewModel =
        ref.read(movieDetailViewModelProvider(movie.id.toString()).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.errorMessage!),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () =>
                            viewModel.loadMovieDetail(movie.id.toString()),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported,
                                  size: 200);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        movie.title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Data de lançamento: ${movie.releaseDate}',
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Sinopse',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        movie.overview.isEmpty
                            ? 'Sinopse não disponível'
                            : movie.overview,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Avaliações: ${movie.voteAverage}/10',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (state.movieDetail != null) ...[
                        const SizedBox(height: 16.0),
                        Text(
                          'Detalhes adicionais',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Duração: ${state.movieDetail?.runtime ?? '-'} min',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Orçamento: \$${state.movieDetail?.budget ?? '-'}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Gêneros: ${state.movieDetail?.genres.map((g) => g.name).join(', ') ?? '-'}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        if (state.movieDetail!.videos.isNotEmpty) ...[
                          const SizedBox(height: 16.0),
                          Text(
                            'Vídeos',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8.0),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: state.movieDetail!.videos
                                  .map(
                                    (video) => Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: TextButton.icon(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              content: AspectRatio(
                                                aspectRatio: 16 / 9,
                                                child: YoutubePlayer(
                                                  controller:
                                                      YoutubePlayerController(
                                                    initialVideoId: video.key,
                                                    flags:
                                                        const YoutubePlayerFlags(
                                                      autoPlay: true,
                                                      mute: false,
                                                    ),
                                                  ),
                                                  showVideoProgressIndicator:
                                                      true,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.play_arrow),
                                        label: Text(video.name),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 12.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.1),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ]
                    ],
                  ),
                ),
    );
  }
}
