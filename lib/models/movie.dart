import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:movietrack/utils/config.dart';
import 'package:movietrack/models/genre.dart';
import 'package:movietrack/models/production_company.dart';

class Movie {
  final int id;
  final String title;
  final String? posterPath;
  final String? releaseDate;
  final List<Genre> genres;
  final String? overview;
  final ProductionCompany? productionCompany;
  final int? runtime;
  final String? status;
  final double? voteAverage;

  Movie({
    required this.id,
    required this.title,
    this.posterPath,
    this.releaseDate,
    required this.genres,
    this.overview,
    this.productionCompany,
    this.runtime,
    this.status,
    this.voteAverage,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'poster_path': posterPath,
      'release_date': releaseDate,
      'genres': genres.map((genre) => genre.toJson()).toList(),
      'overview': overview,
      'production_company': productionCompany?.toJson(),
      'runtime': runtime,
      'status': status,
      'vote_average': voteAverage,
    };
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      posterPath: json['poster_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${json['poster_path']}'
          : null,
      releaseDate: json['release_date'],
      genres: (json['genres'] as List<dynamic>?)
              ?.map((genreJson) => Genre.fromJson(genreJson))
              .toList() ??
          [],
      overview: json['overview'],
      productionCompany: json['production_companies'] != null
          ? ProductionCompany.fromJson(json['production_companies'])
          : null,
      runtime: json['runtime'],
      status: json['status'],
      voteAverage: json['vote_average'] != null
          ? (json['vote_average'] as num).toDouble()
          : null,
    );
  }

  static Future<List<Movie>> search(String query) async {
    final Logger logger = Logger();
    const String baseUrl = AuthService.baseUrl;

    try {
      final response = await http.get(Uri.parse("$baseUrl/movies?query=$query"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
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

  static Future<List<Movie>> fetchRecommendations() async {
    final Logger logger = Logger();
    const String baseUrl = AuthService.baseUrl;

    try {
      final response = await http.get(Uri.parse("$baseUrl/recs/upcoming"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        logger.i("Received recommendations: $data");

        return data.map((e) => Movie.fromJson(e)).toList();
      } else {
        logger.e("Failed to fetch recommendations: ${response.body}");
        throw Exception("Failed to fetch recommendations");
      }
    } catch (e) {
      logger.e("Failed to fetch recommendations: $e");
      throw Exception("Failed to fetch recommendations");
    }
  }

  static Future<List<Movie>> fetchTopRated() async {
    final Logger logger = Logger();
    const String baseUrl = AuthService.baseUrl;

    try {
      final response = await http.get(Uri.parse("$baseUrl/recs/top-rated"));
      logger.i("Top Rated Response Status Code: ${response.statusCode}");
      logger.i("Top Rated Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        logger.i("Received top rated movie data: $data");

        return data.map((e) => Movie.fromJson(e)).toList();
      } else {
        logger.e("Failed to fetch top rated movie: ${response.body}");
        throw Exception("Failed to fetch top rated movie");
      }
    } catch (e) {
      logger.e("Exception occurred while fetching top rated movie: $e");
      throw Exception("Failed to fetch top rated movie");
    }
  }

  static Future<List<Movie>> fetchPopular() async {
    final Logger logger = Logger();
    const String baseUrl = AuthService.baseUrl;

    try {
      final response = await http.get(Uri.parse("$baseUrl/recs/popular"));
      logger.i("Popular Response Status Code: ${response.statusCode}");
      logger.i("Popular Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        logger.i("Received popular movie data: $data");

        return data.map((e) => Movie.fromJson(e)).toList();
      } else {
        logger.e("Failed to fetch popular movie: ${response.body}");
        throw Exception("Failed to fetch popular movie");
      }
    } catch (e) {
      logger.e("Exception occurred while fetching popular movie: $e");
      throw Exception("Failed to fetch popular movie");
    }
  }
}