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
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Movies',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.themeData,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
