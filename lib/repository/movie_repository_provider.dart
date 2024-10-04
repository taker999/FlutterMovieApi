import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../apis/movie_api_service.dart';
import '../models/movie.dart';

class MovieRepositoryProvider extends ChangeNotifier {
  final List<Movie> _movieList = [];
  int _currentPage = 1;
  bool _isLoading = true;
  String _sortBy = 'popular';

  Future<void> fetchMovies() async {
    _isLoading = true;
    notifyListeners();

    try {
      final movies = await MovieApiService.fetchMovies(_sortBy, _currentPage);
      if (movies.isNotEmpty) {
        _movieList.addAll(movies);
        _currentPage++;
      }
    } catch (e) {
      log("Error fetching movies: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    log('Current Page: $_currentPage');
  }

  void resetMovies() {
    _movieList.clear();
    _currentPage = 1;
    fetchMovies();
    // notifyListeners();
  }

  List<Movie> get movieList => _movieList;
  bool get isLoading => _isLoading;

  String get sortBy => _sortBy;

  set sortBy(String value) {
    if (_sortBy != value) {
      _sortBy = value;
      resetMovies();
      // notifyListeners();
    }
  }
}
