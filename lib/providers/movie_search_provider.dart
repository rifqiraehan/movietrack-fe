import 'package:flutter/material.dart';
import 'package:movietrack/models/movie.dart';

class MovieSearchProvider with ChangeNotifier {
  List<Movie> _searchResults = [];
  bool _isSearching = false;
  bool _isLoading = false;
  String _errorMessage = '';

  List<Movie> get searchResults => _searchResults;
  bool get isSearching => _isSearching;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  void resetState() {
    _searchResults = [];
    _isSearching = false;
    _isLoading = false;
    _errorMessage = '';
    notifyListeners();
  }

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      resetState();
      return;
    }

    _isLoading = true;
    _isSearching = true;
    notifyListeners();

    try {
      final results = await Movie.search(query);
      _searchResults = results;
      _isLoading = false;
      _errorMessage = '';
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch search results';
    } finally {
      notifyListeners();
    }
  }
}