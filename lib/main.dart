import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';

import 'features/now_playing/data/models/cached_movie_detail.dart';
import 'features/now_playing/data/models/genre_model.dart';
import 'features/now_playing/data/models/movie_detail_model.dart';
import 'features/now_playing/data/models/video_model.dart';
import 'features/now_playing/presentation/pages/movie_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  Hive.registerAdapter(GenreAdapter());
  Hive.registerAdapter(VideoAdapter());
  Hive.registerAdapter(MovieDetailAdapter());
  Hive.registerAdapter(CachedMovieDetailAdapter());
  await Hive.openBox('movieDetails');

  runApp(const ProviderScope(child: MyIliaApp()));
}

class MyIliaApp extends StatelessWidget {
  const MyIliaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Filmes Ília',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MovieListPage(title: 'Filmes Ília'),
    );
  }
}
