import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_api/repository/movie_repository_provider.dart';
import 'package:provider/provider.dart';

import '../theme/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // dark mode
                Text(
                  'Dark Mode',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),

                // switch toggle
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return CupertinoSwitch(
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.toggleTheme();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // dark mode
                Text(
                  'Sort By',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),

                Consumer<MovieRepositoryProvider>(
                    builder: (context, movieRepositoryProvider, child) {
                  return DropdownButton<String>(
                      value: movieRepositoryProvider.sortBy,
                      icon: const Icon(Icons.arrow_drop_down),
                      items: const [
                        DropdownMenuItem(
                          value: 'popular',
                          child: Text('Most Popular'),
                        ),
                        DropdownMenuItem(
                          value: 'top_rated',
                          child: Text('Highest Rated'),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        movieRepositoryProvider.sortBy = newValue!;
                      });
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
