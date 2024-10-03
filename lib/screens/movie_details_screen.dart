import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/movie.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: Column(
        children: [
          CachedNetworkImage(imageUrl: 'https://image.tmdb.org/t/p/w500/${movie.posterPath}'),
          Text(movie.overview),
          Text('Rating: ${movie.voteAverage}'),
          Text('Release Date: ${movie.releaseDate}'),
        ],
      ),
    );
  }
}
