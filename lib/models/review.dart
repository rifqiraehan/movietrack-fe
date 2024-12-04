import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:movietrack/utils/config.dart';
import 'package:movietrack/utils/session.dart';

class Review {
  final int id;
  final int userId;
  final int movieId;
  final String body;
  final String userName;
  final String movieTitle;
  final String userPfp;
  final String date;
  final String recMsg;

  Review({
    required this.id,
    required this.userId,
    required this.movieId,
    required this.body,
    required this.userName,
    required this.movieTitle,
    required this.userPfp,
    required this.date,
    required this.recMsg,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'movie_id': movieId,
      'body': body,
      'user_name': userName,
      'movie_title': movieTitle,
      'user_pfp': userPfp,
      'date': date,
      'recommendation_message': recMsg,
    };
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userId: json['user_id'],
      movieId: json['movie_id'],
      body: json['body'] ?? '',
      userName: json['user_name'] ?? '',
      movieTitle: json['movie_title'] ?? '',
      userPfp: json['user_pfp'] ?? '',
      date: json['date'] ?? '',
      recMsg: json['recommendation_message'] ?? '',
    );
  }

  /* {
      "comment-request" : "/movies/{movie_id}/reviews/user  --AUTH",
      "data": {
          "id": 7,
          "user_id": 2,
          "movie_id": 615165,
          "body": "This movie is terrible.",
          "user_name": "AkebiKomichi",
          "movie_title": "Her Blue Sky",
          "user_pfp": "http://localhost:8000/storage/pfps/akebi.jpeg",
          "recommendation_message": null,
          "date": "03 Dec 2024"
      }
  } */

  // get review of movie_id by current user's watchlist
  static Future<Review> fetchReview(int movieId) async {
    final Logger logger = Logger();
    const String baseUrl = AuthService.baseUrl;

    try {
      final sessionManager = SessionManager();
      final token = await sessionManager.getToken();

      final response = await http.get(
        Uri.parse("$baseUrl/movies/$movieId/reviews/user"),
        headers: {
          'Authorization': '$token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final data = responseData['data'];
        logger.i("Received review: $data");

        return Review.fromJson(data);
      } else {
        logger.e("Failed to fetch review: ${response.body}");
        throw Exception("Failed to fetch review");
      }
    } catch (e) {
      logger.e("Exception occurred while fetching review: $e");
      throw Exception("Failed to fetch review");
    }
  }

  static Future<List<Review>> fetchReviewsForMovie(int movieId) async {
    final Logger logger = Logger();
    const String baseUrl = AuthService.baseUrl;

    try {
      final response =
          await http.get(Uri.parse("$baseUrl/movies/$movieId/reviews"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success'] == false &&
            responseData['message'] == 'No reviews found for this movie') {
          logger.i("No reviews found for movie ID: $movieId");
          return [];
        }
        final List<dynamic> data = responseData['data'];
        logger.i("Received reviews: $data");

        return data.map((e) => Review.fromJson(e)).toList();
      } else {
        logger.e("Failed to fetch reviews: ${response.body}");
        throw Exception("Failed to fetch reviews");
      }
    } catch (e) {
      logger.e("Exception occurred while fetching reviews: $e");
      throw Exception("Failed to fetch reviews");
    }
  }

  static Future<List<Review>> fetchLatestReviewsForMovie(int movieId) async {
    final Logger logger = Logger();
    const String baseUrl = AuthService.baseUrl;

    try {
      final response =
          await http.get(Uri.parse("$baseUrl/movies/$movieId/reviews/latest"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success'] == false &&
            responseData['message'] == 'No reviews found for this movie') {
          logger.i("No reviews found for movie ID: $movieId");
          return [];
        }
        final List<dynamic> data = responseData['data'];
        logger.i("Received reviews: $data");

        return data.map((e) => Review.fromJson(e)).toList();
      } else {
        logger.e("Failed to fetch reviews: ${response.body}");
        throw Exception("Failed to fetch reviews");
      }
    } catch (e) {
      logger.e("Exception occurred while fetching reviews: $e");
      throw Exception("Failed to fetch reviews");
    }
  }

  static Future<List<Review>> getAll() async {
    final Logger logger = Logger();
    const String baseUrl = AuthService.baseUrl;

    try {
      final response = await http.get(Uri.parse("$baseUrl/reviews"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'];
        logger.i("Received reviews: $data");

        return data.map((e) => Review.fromJson(e)).toList();
      } else {
        logger.e("Failed to get reviews: ${response.body}");
        return [];
      }
    } catch (e) {
      logger.e("Failed to get reviews: $e");
      return [];
    }
  }

  static Future<Review> addReview(int movieId, String body) async {
    final Logger logger = Logger();
    const String baseUrl = AuthService.baseUrl;

    try {
      final sessionManager = SessionManager();
      final token = await sessionManager.getToken();
      final userId = await sessionManager.getUserId();

      final response = await http.post(
        Uri.parse("$baseUrl/review"),
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': userId,
          'movie_id': movieId,
          'body': body,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return Review.fromJson(responseData['data']);
      } else {
        logger.e("Failed to add review: ${response.body}");
        throw Exception("Failed to add review");
      }
    } catch (e) {
      logger.e("Exception occurred while adding review: $e");
      throw Exception("Failed to add review");
    }
  }

  static Future<void> editReview(int reviewId, String reviewText) async {
    final Logger logger = Logger();
    const String baseUrl = AuthService.baseUrl;

    try {
      final sessionManager = SessionManager();
      final token = await sessionManager.getToken();

      final requestBody = jsonEncode({
        'body': reviewText,
      });

      final response = await http.patch(
        Uri.parse("$baseUrl/reviews/$reviewId"),
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      logger.i("Request to edit review: ${response.request?.url}");
      logger.i("Request body: $requestBody");
      logger.i("Response status: ${response.statusCode}");
      logger.i("Response body: ${response.body}");

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        final responseData = jsonDecode(response.body);
        if (responseData is Map<String, dynamic> &&
            responseData['data'] is Map<String, dynamic>) {
          logger.i("Review edited successfully");
        } else {
          logger.e("Unexpected response format: ${response.body}");
          throw Exception("Unexpected response format");
        }
      } else {
        logger.e("Failed to edit review: ${response.body}");
        throw Exception("Failed to edit review");
      }
    } catch (e) {
      logger.e("Exception occurred while editing review: $e");
      throw Exception("Failed to edit review");
    }
  }

  static Future<void> deleteReview(int reviewId) async {
    final Logger logger = Logger();
    const String baseUrl = AuthService.baseUrl;

    try {
      final sessionManager = SessionManager();
      final token = await sessionManager.getToken();

      final response = await http.delete(
        Uri.parse("$baseUrl/reviews/$reviewId"),
        headers: {
          'Authorization': '$token',
        },
      );

      logger.i("Request to delete review: ${response.request?.url}");
      logger.i("Response status: ${response.statusCode}");
      logger.i("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 204) {
        logger.i("Review deleted successfully");
      } else {
        logger.e("Failed to delete review: ${response.body}");
        throw Exception("Failed to delete review");
      }
    } catch (e) {
      logger.e("Exception occurred while deleting review: $e");
      throw Exception("Failed to delete review");
    }
  }
}