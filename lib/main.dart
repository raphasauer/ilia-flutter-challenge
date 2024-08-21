import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/now_playing/presentation/pages/movie_list_page.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyIliaApp()));
}

class MyIliaApp extends StatelessWidget {
  const MyIliaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Filmes Ília',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MovieListPage(title: 'Filmes Ília'),
    );
  }
}
