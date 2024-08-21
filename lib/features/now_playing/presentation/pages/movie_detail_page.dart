import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ilia_flutter_challenge/features/now_playing/data/models/movie_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:ilia_flutter_challenge/features/now_playing/api/movie_service.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:ilia_flutter_challenge/common/entities/failures.dart';

import '../../api/api_client.dart';
import '../../data/models/movie_detail_model.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({super.key, required this.movie});

  final MovieModel movie;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  MovieDetail? detailedInfo;
  bool isLoading = true;
  String? errorMessage;
  YoutubePlayerController? _youtubePlayerController;

  @override
  void initState() {
    super.initState();
    _fetchMovieDetails();
  }

  Future<void> _fetchMovieDetails() async {
    final movieService = MovieService(
      client: ApiClient(
          baseUrl: 'https://api.themoviedb.org/3',
          apiKey: dotenv.env['API_KEY']!),
    );

    final dartz.Either<FetchFailure, MovieDetail> result =
        await movieService.fetchMovieDetail(widget.movie.id.toString());

    result.fold(
      (failure) {
        setState(() {
          errorMessage = 'Failed to load details';
          isLoading = false;
        });
      },
      (details) {
        setState(() {
          detailedInfo = details;
          isLoading = false;
        });
      },
    );
  }

  void _playVideo(String videoKey) {
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: videoKey,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: YoutubePlayer(
            controller: _youtubePlayerController!,
            showVideoProgressIndicator: true,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _youtubePlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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
              'Avaliação: ${widget.movie.voteAverage}/10',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (!isLoading && errorMessage == null) ...[
              const SizedBox(height: 16.0),
              Text(
                'Detalhes Adicionais',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Duração: ${detailedInfo?.runtime ?? '-'} min',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8.0),
              Text(
                'Orçamento: \$${detailedInfo?.budget ?? '-'}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8.0),
              Text(
                'Gêneros: ${detailedInfo?.genres.map((g) => g.name).join(', ') ?? '-'}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16.0),
              if (detailedInfo?.videos.isNotEmpty == true) ...[
                const SizedBox(height: 16.0),
                Text(
                  'Trailers',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: detailedInfo!.videos
                        .map(
                          (video) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: TextButton.icon(
                              onPressed: () => _playVideo(video.key),
                              icon: const Icon(Icons.play_arrow),
                              label: Text(
                                video.name,
                                style: const TextStyle(fontSize: 14.0),
                              ),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 12.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                                foregroundColor: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ],
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text(
                    errorMessage!,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
