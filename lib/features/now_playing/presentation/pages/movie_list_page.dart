import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ilia_flutter_challenge/features/now_playing/presentation/widgets/movie_list_view.dart';
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
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (state.errorMessage == null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchBox(
                onChanged: (value) => viewModel.updateSearchQuery(value),
              ),
            ),
          Expanded(
            child: MovieListView(
              scrollController: _scrollController,
              movies: state.filteredMovies,
              isLoadingMore: state.isLoadingMore,
              errorMessage: state.errorMessage,
              onRetry: viewModel.loadMoreMovies,
            ),
          ),
        ],
      ),
    );
  }
}
