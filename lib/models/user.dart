import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movietrack/utils/session.dart';
import 'package:logger/logger.dart';
import 'package:movietrack/utils/config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class User {
  final int userId;
  final String username;
  final String email;
  final String password;
  final bool isAdmin;
  final String profilePicture;

  User({
    required this.userId,
    required this.username,
    required this.email,
    required this.password,
    this.isAdmin = false,
    this.profilePicture = '',
  });

  // Convert to JSON (untuk dikirim ke API)
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'email': email,
      'password': password,
    };
  }

  // Create a User object from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['id'],
      username: json['username'],
      email: json['email'],
      password: '',
      isAdmin: json['is_admin'] == 1,
      profilePicture: json['pfp'] ?? '',
    );
  }

  // Fungsi login
  static Future<String?> login(String username, String password) async {
    final Logger logger = Logger();
    final SessionManager sessionManager = SessionManager();
    const String baseUrl = AuthService.baseUrl;

    try {
      final user =
          User(userId: 0, username: username, email: '', password: password);
      logger.i("Sending login request with user: ${user.toJson()}");

      final response = await http.post(
        Uri.parse("$baseUrl/users/login"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user.toJson()),
      );

      // Log response
      logger.i("Response Status: ${response.statusCode}");
      logger.i("Response Body: ${response.body}");

      // Cek status response
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body)['data'];
        final token = responseData['token'];
        final userId = responseData['id'];
        final username = responseData['username'];
        final email = responseData['email'];
        final profilePicture = responseData['pfp'] ?? '';
        final isAdmin = responseData['is_admin'] == 1;

        // Simpan sesi pengguna
        await sessionManager.saveSession(
            token, userId, username, email, profilePicture, isAdmin);

        logger.i("Login success: ${response.body}");
        return null; // Jika berhasil login
      } else {
        final errorData = jsonDecode(response.body)['errors'];
        return errorData['message']?.first ?? "Login failed";
      }
    } catch (e) {
      logger.i("Error: $e");
      return "An error occurred. Please try again."; // Pesan error fallback
    }
  }

  // Fungsi register
  static Future<String?> register(
      String username, String email, String password) async {
    final Logger logger = Logger();
    const String baseUrl = AuthService.baseUrl;

    try {
      final user =
          User(userId: 0, username: username, email: email, password: password);
      logger.i("Sending register request with user: ${user.toJson()}");

      final response = await http.post(
        Uri.parse("$baseUrl/users"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user.toJson()),
      );

      // Log response
      logger.i("Response Status: ${response.statusCode}");
      logger.i("Response Body: ${response.body}");

      // Cek status response
      if (response.statusCode == 201) {
        logger.i("Register success: ${response.body}");
        return null; // Jika berhasil register
      } else {
        final errorData = jsonDecode(response.body)['errors'];
        return errorData.values.first.first ?? "Register failed";
      }
    } catch (e) {
      logger.i("Error: $e");
      return "An error occurred. Please try again."; // Pesan error fallback
    }
  }

  // Fungsi getUserProfile
  static Future<User?> getUserProfile() async {
    final Logger logger = Logger();
    final SessionManager sessionManager = SessionManager();
    const String baseUrl = AuthService.baseUrl;

    try {
      final token = await sessionManager.getToken();
      if (token == null) {
        return null;
      }
      final response = await http.get(
        Uri.parse("$baseUrl/users"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      // Log response
      logger.i("Response Status: ${response.statusCode}");
      logger.i("Response Body: ${response.body}");

      // Cek status response
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body)['data'];
        final user = User.fromJson(responseData);

        // Perbarui data pengguna di SharedPreferences
        await sessionManager.updateUser(
            user.username, user.email, user.profilePicture);

        return user;
      } else {
        logger.e("Failed to load user profile");
        return null;
      }
    } catch (e) {
      logger.i("Error: $e");
      return null; // Pesan error fallback
    }
  }

  // Fungsi updateUserProfile
  static Future<String?> updateProfile({
    required String username,
    required String email,
    String? password,
    dynamic profilePictureFile,
  }) async {
    final Logger logger = Logger();
    final SessionManager sessionManager = SessionManager();
    const String baseUrl = AuthService.baseUrl;

    try {
      final token = await sessionManager.getToken();
      if (token == null) {
        return "Unauthorized";
      }
      final dio = Dio();
      dio.options.headers['Authorization'] = token;
      dio.options.headers['Accept'] = 'application/json';
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers['X-HTTP-Method-Override'] = 'PATCH';

      FormData formData = FormData.fromMap({
        'username': username,
        'email': email,
        if (password != null && password.isNotEmpty) 'password': password,
      });

      if (profilePictureFile != null) {
        if (kIsWeb) {
          // Handle file upload for web
          formData.files.add(MapEntry(
            'pfp',
            MultipartFile.fromBytes(profilePictureFile,
                filename: 'profile_picture.jpg'),
          ));
        } else {
          // Handle file upload for mobile
          formData.files.add(MapEntry(
            'pfp',
            await MultipartFile.fromFile(profilePictureFile.path,
                filename: 'profile_picture.jpg'),
          ));
        }
      }

      final response = await dio.post(
        '$baseUrl/users',
        data: formData,
      );

      logger.i("Update Profile Response: ${response.statusCode}");
      logger.i("Response Body: ${response.data}");

      if (response.statusCode == 200) {
        final responseData = response.data['data'];
        final updatedUser = User.fromJson(responseData);

        // Clear current session
        await sessionManager.clearSession();

        // Save new session data
        await sessionManager.saveSession(
          token,
          updatedUser.userId,
          updatedUser.username,
          updatedUser.email,
          updatedUser.profilePicture,
          updatedUser.isAdmin,
        );

        return null; // Success
      } else {
        return response.data['message'] ?? 'Failed to update profile';
      }
    } catch (e) {
      logger.e("Error updating profile: $e");
      return "An error occurred. Please try again.";
    }
  }

  // Fetch all users
  static Future<List<User>> fetchAllUsers() async {
    final Logger logger = Logger();
    const String baseUrl = AuthService.baseUrl;

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/users/all"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        logger.e("Failed to fetch users: ${response.body}");
        throw Exception("Failed to fetch users");
      }
    } catch (e) {
      logger.e("Error fetching users: $e");
      throw Exception("Error fetching users");
    }
  }

  // Search users
  static Future<List<User>> searchUsers(String query) async {
    final Logger logger = Logger();
    const String baseUrl = AuthService.baseUrl;

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/users/search?query=$query"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        logger.e("Failed to search users: ${response.body}");
        throw Exception("Failed to search users");
      }
    } catch (e) {
      logger.e("Error searching users: $e");
      throw Exception("Error searching users");
    }
  }

  // Reset user password
  static Future<void> resetPassword(int userId) async {
    final Logger logger = Logger();
    const String baseUrl = AuthService.baseUrl;

    try {
      final response = await http.patch(
        Uri.parse("$baseUrl/users/$userId/reset-password"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        logger.e("Failed to reset password: ${response.body}");
        throw Exception("Failed to reset password");
      }
    } catch (e) {
      logger.e("Error resetting password: $e");
      throw Exception("Error resetting password");
    }
  }

  // Remove user
  static Future<void> removeUser(int userId) async {
    final Logger logger = Logger();
    const String baseUrl = AuthService.baseUrl;

    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/users/$userId"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        logger.e("Failed to remove user: ${response.body}");
        throw Exception("Failed to remove user");
      }
    } catch (e) {
      logger.e("Error removing user: $e");
      throw Exception("Error removing user");
    }
  }
}
