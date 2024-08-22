import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ilia_flutter_challenge/common/utils/formatting_utils.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../data/models/movie_model.dart';
import '../viewmodels/movie_detail_viewmodel.dart';

class MovieDetailPage extends ConsumerStatefulWidget {
  final MovieModel movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  ConsumerState<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends ConsumerState<MovieDetailPage> {
  String imageKey = UniqueKey().toString();

  @override
  Widget build(BuildContext context) {
    /*
      This workaround addresses a specific app state scenario:
      Providers, by default, retain their state in memory, which enables quick viewmodel access. 
      However, when a fetch for details fails, and the user navigates back and then reopens the details 
      (this time with an active connection), the widget may still display the previous error state. 
      Using `invalidate` ensures the provider fetches fresh data, either from cache or the API, resolving the issue.
     */
    ref.invalidate(movieDetailViewModelProvider(widget.movie.id.toString()));
    final state =
        ref.watch(movieDetailViewModelProvider(widget.movie.id.toString()));
    final viewModel = ref.read(
        movieDetailViewModelProvider(widget.movie.id.toString()).notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
                  key: Key(state.imageKey),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported, size: 200);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              widget.movie.title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Data de lançamento: ${widget.movie.releaseDate}',
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
              widget.movie.overview.isEmpty
                  ? 'Sinopse não disponível'
                  : widget.movie.overview,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Avaliações: ${widget.movie.voteAverage}/10',
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
                'Orçamento: ${FormatUtils.formatCurrency(state.movieDetail?.budget ?? 0)}',
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
                            padding: const EdgeInsets.only(right: 8.0),
                            child: TextButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: YoutubePlayer(
                                        controller: YoutubePlayerController(
                                          initialVideoId: video.key,
                                          flags: const YoutubePlayerFlags(
                                            autoPlay: true,
                                            mute: false,
                                          ),
                                        ),
                                        showVideoProgressIndicator: true,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.play_arrow),
                              label: Text(video.name),
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    Theme.of(context).colorScheme.primary,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 12.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
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
            ],
            if (state.errorMessage != null) ...[
              const SizedBox(height: 16.0),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Erro ao carregar detalhes adicionais',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => viewModel.loadMovieDetail(
                        widget.movie.id.toString(),
                      ),
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
