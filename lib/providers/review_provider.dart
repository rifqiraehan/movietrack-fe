import 'package:flutter/material.dart';
import 'package:movietrack/models/review.dart';

class ReviewProvider with ChangeNotifier {
  List<Review> _reviews = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Review> get reviews => _reviews;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchReviews() async {
    _isLoading = true;
    notifyListeners();

    try {
      final fetchedReviews = await Review.getAll();
      _reviews = fetchedReviews;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to load reviews';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}