import 'package:dio/dio.dart';
import 'package:flutter_movie_api/secrets/api_keys.dart';
import '../models/movie.dart';

class MovieApiService {
  static final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.themoviedb.org/3/'));

  static Future<List<Movie>> fetchMovies(String sortBy, int page) async {
    final response = await _dio.get(
      'movie/$sortBy',
      queryParameters: {
        'api_key': APIKEYS.MOVIEAPIKEY,
        'page': page,
      },
    );
    return List<Movie>.from(response.data['results'].map((x) => Movie.fromJson(x)));
  }
}
