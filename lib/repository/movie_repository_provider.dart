import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../apis/movie_api_service.dart';
import '../models/movie.dart';

class MovieRepositoryProvider extends ChangeNotifier {
  final List<Movie> _movieList = [];
  int _currentPage = 1;
  bool _isLoading = true;
  String _sortBy = 'popular';
  //for storing searched users
  final List<Movie> _searchList = [];
  bool _isSearching = false;
  // Keep track of whether more movies are currently being fetched
  bool _isFetchingMore = false;

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

  set addSearchList(Movie m) {
    _searchList.add(m);
    notifyListeners();
  }

  void resetSearchList() {
    _searchList.clear();
    // notifyListeners();
  }

  List<Movie> get searchList => _searchList;

  bool get isSearching => _isSearching;
  set isSearching(bool val) {
    _isSearching = val;
    notifyListeners();
  }

  bool get isFetchingMore => _isFetchingMore;
  set isFetchingMore(bool val) {
    _isFetchingMore = val;
    notifyListeners();
  }
}
