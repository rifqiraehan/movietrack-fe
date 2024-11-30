import 'package:flutter/material.dart';
import 'package:movietrack/models/movie.dart';

class MovieRecommendationsProvider with ChangeNotifier {
  List<Movie> _recommendations = [];
  List<Movie> _topRated = [];
  List<Movie> _popular = [];

  List<Movie> get topRated => _topRated;
  List<Movie> get popular => _popular;
  List<Movie> get recommendations => _recommendations;

  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchRecommendations() async {
    _isLoading = true;
    notifyListeners();

    try {
      final results = await Movie.fetchRecommendations();
      _recommendations = results;
      _isLoading = false;
      _errorMessage = '';
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch recommendations';
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchTopRated() async {
    _isLoading = true;
    notifyListeners();

    try {
      final results = await Movie.fetchTopRated();
      _topRated = results;
      _isLoading = false;
      _errorMessage = '';
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch top-rated movies';
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchPopular() async {
    _isLoading = true;
    notifyListeners();

    try {
      final results = await Movie.fetchPopular();
      _popular = results;
      _isLoading = false;
      _errorMessage = '';
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch popular movies';
    } finally {
      notifyListeners();
    }
  }
}