import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movietrack/models/user.dart';
import 'package:logger/logger.dart';
import 'package:movietrack/utils/session.dart';

class AuthService {
  final String _baseUrl = "http://127.0.0.1:8000/api";
  final Logger _logger = Logger();
  final SessionManager _sessionManager = SessionManager();

  // Fungsi login
  Future<String?> login(User user) async {
    try {
      _logger.i("Sending login request with user: ${user.toJson()}");

      final response = await http.post(
        Uri.parse("$_baseUrl/users/login"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user.toJson()),
      );

      // Log response
      _logger.i("Response Status: ${response.statusCode}");
      _logger.i("Response Body: ${response.body}");

      // Cek status response
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body)['data'];
        final token = responseData['token'];
        final userId = responseData['id'];
        final username = responseData['username'];

        // Simpan sesi pengguna
        await _sessionManager.saveSession(token, userId, username);

        _logger.i("Login success: ${response.body}");
        return null; // Jika berhasil login
      } else {
        final errorData = jsonDecode(response.body)['errors'];
        return errorData['message']?.first ?? "Login failed";
      }
    } catch (e) {
      _logger.i("Error: $e");
      return "An error occurred. Please try again."; // Pesan error fallback
    }
  }
}
