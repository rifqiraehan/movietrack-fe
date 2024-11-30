import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:movietrack/utils/config.dart';

class Movie {
  final int id;
  final String title;
  final String posterPath;
  final String releaseDate;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.releaseDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'poster_path': posterPath,
      'release_date': releaseDate,
    };
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      posterPath: json['poster_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${json['poster_path']}'
          : '',
      releaseDate: json['release_date'] ?? '',
    );
  }

  static Future<List<Movie>> search(String query) async {
    final Logger logger = Logger();
    const String baseUrl = AuthService.baseUrl;

    try {
      final response = await http.get(Uri.parse("$baseUrl/movies?query=$query"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'];
        logger.i("Received movies: $data");

        return data.map((e) => Movie.fromJson(e)).toList();
      } else {
        logger.e("Failed to fetch movies: ${response.body}");
        throw Exception("Failed to fetch movies");
      }
    } catch (e) {
      logger.e("Failed to fetch movies: $e");
      throw Exception("Failed to fetch movies");
    }
  }
}