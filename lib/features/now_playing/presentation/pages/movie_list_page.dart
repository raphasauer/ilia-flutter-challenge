import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ilia_flutter_challenge/features/now_playing/presentation/widgets/movie_tile.dart';
import 'package:ilia_flutter_challenge/features/now_playing/presentation/widgets/search_box.dart';

import '../viewmodels/movie_list_viewmodel.dart';

class MovieListPage extends ConsumerStatefulWidget {
  const MovieListPage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends ConsumerState<MovieListPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
          ref.read(movieListViewModelProvider.notifier).loadMoreMovies();
        }
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(movieListViewModelProvider);
    final viewModel = ref.read(movieListViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: SearchBox(
                    onChanged: (value) {
                      viewModel.updateSearchQuery(value);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(state.errorMessage!),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => viewModel.loadMovies(),
                              child: const Text('Tentar novamente'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: state.filteredMovies.length +
                            (state.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == state.filteredMovies.length) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return MovieTile(movie: state.filteredMovies[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
