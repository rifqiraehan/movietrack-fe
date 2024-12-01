import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:movietrack/utils/config.dart';

class Review {
  final int id;
  final int userId;
  final int movieId;
  final String body;
  final String userName;
  final String movieTitle;
  final String userPfp;
  final String date;

  Review({
    required this.id,
    required this.userId,
    required this.movieId,
    required this.body,
    required this.userName,
    required this.movieTitle,
    required this.userPfp,
    required this.date,
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
    };
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userId: json['user_id'],
      movieId: json['movie_id'],
      body: json['body'],
      userName: json['user_name'],
      movieTitle: json['movie_title'],
      userPfp: json['user_pfp'],
      date: json['date'],
    );
  }

  static Future<List<Review>> fetchReviewsForMovie(int movieId) async {
    final Logger logger = Logger();
    const String baseUrl = AuthService.baseUrl;

    try {
      final response = await http.get(Uri.parse("$baseUrl/movies/$movieId/reviews"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success'] == false && responseData['message'] == 'No reviews found for this movie') {
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
}