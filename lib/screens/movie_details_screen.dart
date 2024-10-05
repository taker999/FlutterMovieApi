import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/movie.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        movie.title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
      )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: movie.posterPath,
              child: CachedNetworkImage(
                imageUrl: 'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'Overview',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(
                movie.overview,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Rating: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: movie.voteAverage.toString()),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Release Date: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: movie.releaseDate),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
