import 'dart:developer';

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
  final scrollController = ScrollController();

  // Keep track of whether more movies are currently being fetched
  bool _isFetchingMore = false;

  void _scrollListener() {
    if(_isFetchingMore) return;
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      _fetchMoreMovies();
    }
  }

  void _fetchMoreMovies() {
    if (!_isFetchingMore) {
      _isFetchingMore = true;
      final movieRepository =
      Provider.of<MovieRepositoryProvider>(context, listen: false);
      movieRepository.fetchMovies().whenComplete(() {
        _isFetchingMore = false; // Reset fetching flag after completing
      });
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    final movieRepository =
    Provider.of<MovieRepositoryProvider>(context, listen: false);
    _fetchMoviesFuture = movieRepository.fetchMovies();
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('build');

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
      body: Consumer<MovieRepositoryProvider>(
        builder: (context, movieRepository, child) => FutureBuilder(
          future: _fetchMoviesFuture,
          builder: (context, snapshot) {
            if (movieRepository.isLoading && !_isFetchingMore) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.connectionState == ConnectionState.done && snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            return GridView.builder(
              controller: scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemCount: movieRepository.movieList.length,
              itemBuilder: (context, index) {
                final movie = movieRepository.movieList[index];
                return Container(
                  margin: const EdgeInsets.all(5),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => MovieDetailsScreen(movie: movie))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Hero(
                        tag: movie.posterPath, // Use a unique tag for each movie
                        child: CachedNetworkImage(
                          imageUrl: 'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                          placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

