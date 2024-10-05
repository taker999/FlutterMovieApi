import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
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

  void _scrollListener() {
    if (Provider.of<MovieRepositoryProvider>(context, listen: false)
        .isFetchingMore) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      _fetchMoreMovies();
    }
  }

  void _fetchMoreMovies() {
    // Use a Consumer to access the provider
    final movieRepository =
        Provider.of<MovieRepositoryProvider>(context, listen: false);

    if (!movieRepository.isFetchingMore) {
      movieRepository.isFetchingMore = true;

      movieRepository.fetchMovies().whenComplete(() {
        movieRepository.isFetchingMore =
            false; // Reset fetching flag after completing
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

    return Consumer<MovieRepositoryProvider>(
      builder: (context, movieRepository, child) => PopScope(
        canPop: !movieRepository.isSearching,
        onPopInvokedWithResult: (didPop, result) {
          if (movieRepository.isSearching) {
            movieRepository.isSearching = false;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: movieRepository.isSearching
                ? TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Name...',
                    ),
                    autofocus: true,
                    style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                    // when search text changes then update search list
                    onChanged: (val) {
                      // search logic
                      movieRepository.resetSearchList();
                      for (var i in movieRepository.movieList) {
                        if (i.title
                            .toLowerCase()
                            .contains(val.toLowerCase())) {
                          movieRepository.addSearchList = i;
                        }
                      }
                    },
                  )
                : const Text(
                    'Movies',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                  ),
            actions: [
              //search user button
              IconButton(
                onPressed: () {
                  movieRepository.resetSearchList();
                  setState(() {
                    movieRepository.isSearching = !movieRepository.isSearching;
                  });
                },
                icon: Icon(movieRepository.isSearching
                    ? CupertinoIcons.clear_circled_solid
                    : Icons.search),
              ),

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
          body: Column(
            children: [
              Expanded(
                child: FutureBuilder(
                  future: _fetchMoviesFuture,
                  builder: (context, snapshot) {
                    if (movieRepository.isLoading &&
                        !movieRepository.isFetchingMore) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    return GridView.builder(
                      controller: scrollController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: movieRepository.isSearching
                          ? movieRepository.searchList.length
                          : movieRepository.movieList.length,
                      itemBuilder: (context, index) {
                        final movie = movieRepository.isSearching
                            ? movieRepository.searchList[index]
                            : movieRepository.movieList[index];
                        return Container(
                          margin: const EdgeInsets.all(5),
                          child: InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        MovieDetailsScreen(movie: movie))),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Hero(
                                tag: movie
                                    .posterPath, // Use a unique tag for each movie
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
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
              if (movieRepository.isFetchingMore)
                Container(
                  margin: const EdgeInsets.all(8),
                  width: 20,
                  height: 20,
                  child: const CircularProgressIndicator(
                    color: Colors.blue,
                    strokeWidth: 2,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
