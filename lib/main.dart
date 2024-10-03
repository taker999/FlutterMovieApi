import 'package:flutter/material.dart';
import 'package:flutter_movie_api/repository/movie_repository_provider.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'theme/theme_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MovieRepositoryProvider(),
        ),
      ],
      child: const MaterialApp(
        title: 'Movies',
        home: HomeScreen(),
      ),
    );
  }
}
