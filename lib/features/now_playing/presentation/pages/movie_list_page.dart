import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ilia_flutter_challenge/features/now_playing/presentation/widgets/movie_list_view.dart';
import 'package:ilia_flutter_challenge/features/now_playing/presentation/widgets/search_box.dart';

import '../viewmodels/movie_list_viewmodel.dart';
import '../widgets/error_section.dart';

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
          state.errorMessage != null
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchBox(
                    onChanged: (value) => viewModel.updateSearchQuery(value),
                  ),
                ),
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.errorMessage != null
                    ? ErrorSection(
                        errorMessage: state.errorMessage!,
                        onRetry: viewModel.loadMovies,
                      )
                    : MovieListView(
                        scrollController: _scrollController,
                        movies: state.filteredMovies,
                        isLoadingMore: state.isLoadingMore,
                      ),
          ),
        ],
      ),
    );
  }
}
