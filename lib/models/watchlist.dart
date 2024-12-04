import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:movietrack/utils/config.dart';
import 'package:movietrack/utils/session.dart';
import 'package:movietrack/models/watchlist_status_count.dart';

class Watchlist {
  final int id;
  final int userId;
  final int movieId;
  final int statusId;
  final int score;

  Watchlist({
    required this.id,
    required this.userId,
    required this.movieId,
    required this.statusId,
    required this.score,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'movie_id': movieId,
      'status_id': statusId,
      'score': score,
    };
  }

  factory Watchlist.fromJson(Map<String, dynamic> json) {
    return Watchlist(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      movieId: json['movie_id'] ?? 0,
      statusId: json['status_id'] ?? 0,
      score: json['score'] ?? 0,
    );
  }

  static Future<List<Watchlist>> fetchWatchlist() async {
    final Logger logger = Logger();
    const String baseUrl = AuthService.baseUrl;

    try {
      final sessionManager = SessionManager();
      final token = await sessionManager.getToken();

      final response = await http.get(
        Uri.parse("$baseUrl/watchlists"),
        headers: {
          'Authorization': '$token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        List<Watchlist> watchlists = [];
        for (var status in data) {
          for (var movie in status['movies']) {
            watchlists.add(Watchlist.fromJson(movie));
          }
        }
        return watchlists;
      } else {
        logger.e("Failed to fetch watchlist: ${response.body}");
        throw Exception("Failed to fetch watchlist");
      }
    } catch (e) {
      logger.e("Exception occurred while fetching watchlist: $e");
      throw Exception("Failed to fetch watchlist");
    }
  }

  static Future<List<Watchlist>> fetchWatchlistByStatus(int statusId) async {
    final Logger logger = Logger();
    const String baseUrl = AuthService.baseUrl;

    try {
      final sessionManager = SessionManager();
      final token = await sessionManager.getToken();

      final response = await http.get(
        Uri.parse("$baseUrl/watchlists/$statusId"),
        headers: {
          'Authorization': '$token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'];
        return data.map((e) => Watchlist.fromJson(e)).toList();
      } else {
        logger.e("Failed to fetch watchlist by status: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      logger.e("Failed to fetch watchlist by status: $e");
      return [];
    }
  }

  static Future<List<WatchlistStatusCount>> fetchWatchlistCount() async {
    final Logger logger = Logger();
    const String baseUrl = AuthService.baseUrl;

    try {
      final sessionManager = SessionManager();
      final token = await sessionManager.getToken();

      final response = await http.get(
        Uri.parse("$baseUrl/watchlist/status-count"),
        headers: {
          'Authorization': '$token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success'] == false &&
            responseData['message'] == 'No watchlist found for this user') {
          logger.i("No watchlist found for this user");
          return [];
        }
        final List<dynamic> data = responseData['data'];
        return data.map((e) => WatchlistStatusCount.fromJson(e)).toList();
      } else {
        logger.e("Failed to fetch watchlist count: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      logger.e("Failed to fetch watchlist count: $e");
      return [];
    }
  }

  static Future<WatchlistStatusCount> fetchMostFavoriteGenre() async {
    final Logger logger = Logger();
    const String baseUrl = AuthService.baseUrl;

    try {
      final sessionManager = SessionManager();
      final token = await sessionManager.getToken();

      final response = await http.get(
        Uri.parse("$baseUrl/watchlist/most-genre"),
        headers: {
          'Authorization': '$token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final Map<String, dynamic> data = responseData['data'];
        return WatchlistStatusCount.fromJson(data);
      } else {
        logger.e("Failed to fetch most favorite genre: ${response.statusCode}");
        return WatchlistStatusCount(id: 0, name: '', count: 0);
      }
    } catch (e) {
      logger.e("Failed to fetch most favorite genre: $e");
      return WatchlistStatusCount(id: 0, name: '', count: 0);
    }
  }

  static Future<Watchlist> addToWatchlist(
      int movieId, int statusId, int score) async {
    final Logger logger = Logger();
    const String baseUrl = AuthService.baseUrl;

    try {
      final sessionManager = SessionManager();
      final token = await sessionManager.getToken();
      final userId = await sessionManager.getUserId();

      final response = await http.post(
        Uri.parse("$baseUrl/watchlists"),
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': userId,
          'movie_id': movieId,
          'status_id': statusId,
          'score': score,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return Watchlist.fromJson(responseData['data']);
      } else {
        logger.e("Failed to add to watchlist: ${response.body}");
        throw Exception("Failed to add to watchlist");
      }
    } catch (e) {
      logger.e("Exception occurred while adding to watchlist: $e");
      throw Exception("Failed to add to watchlist");
    }
  }

    static Future<Watchlist> editWatchlist(int id, int statusId, int score) async {
    final Logger logger = Logger();
    const String baseUrl = AuthService.baseUrl;

    try {
      final sessionManager = SessionManager();
      final token = await sessionManager.getToken();

      final requestBody = jsonEncode({
        'status_id': statusId,
        'score': score,
      });

      final response = await http.patch(
        Uri.parse("$baseUrl/watchlists/$id"),
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      logger.i("Request to edit watchlist: ${response.request?.url}");
      logger.i("Request body: $requestBody");
      logger.i("Response status: ${response.statusCode}");
      logger.i("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
        final responseData = jsonDecode(response.body);
        if (responseData is Map<String, dynamic> && responseData['data'] is List) {
          final dataList = responseData['data'] as List;
          if (dataList.isNotEmpty && dataList[0] is Map<String, dynamic>) {
            return Watchlist.fromJson(dataList[0]);
          } else {
            logger.e("Unexpected response format: ${response.body}");
            throw Exception("Unexpected response format");
          }
        } else {
          logger.e("Unexpected response format: ${response.body}");
          throw Exception("Unexpected response format");
        }
      } else {
        final responseData = jsonDecode(response.body);
        if (responseData['message'] == 'Movie not found in current user’s watchlist') {
          logger.e("Movie not found in current user’s watchlist");
          throw Exception("Movie not found in current user’s watchlist");
        } else {
          logger.e("Failed to edit watchlist: ${response.body}");
          throw Exception("Failed to edit watchlist");
        }
      }
    } catch (e) {
      logger.e("Exception occurred while editing watchlist: $e");
      throw Exception("Failed to edit watchlist");
    }
  }

  // delete watchlist
  static Future<void> deleteWatchlist(int id) async {
    final Logger logger = Logger();
    const String baseUrl = AuthService.baseUrl;

    try {
      final sessionManager = SessionManager();
      final token = await sessionManager.getToken();

      final response = await http.delete(
        Uri.parse("$baseUrl/watchlists/$id"),
        headers: {
          'Authorization': '$token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        logger.i("Successfully deleted watchlist");
      } else {
        logger.e("Failed to delete watchlist: ${response.body}");
        throw Exception("Failed to delete watchlist");
      }
    } catch (e) {
      logger.e("Exception occurred while deleting watchlist: $e");
      throw Exception("Failed to delete watchlist");
    }
  }


}
