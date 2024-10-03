import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repository/movie_repository_provider.dart';
import 'movie_details_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<void> _fetchMoviesFuture;

  @override
  void initState() {
    super.initState();
    final movieRepository = Provider.of<MovieRepositoryProvider>(context, listen: false);
    _fetchMoviesFuture = movieRepository.fetchMovies('top_rated');
  }

  @override
  Widget build(BuildContext context) {
    final movieRepository = Provider.of<MovieRepositoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _fetchMoviesFuture,
        builder: (context, snapshot) {
          if (movieRepository.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.connectionState == ConnectionState.done && snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
            ),
            itemCount: movieRepository.movieList.length,
            itemBuilder: (context, index) {
              final movie = movieRepository.movieList[index];
              return GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MovieDetailsScreen(movie: movie))),
                child: CachedNetworkImage(
                  imageUrl: 'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
