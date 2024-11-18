import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyToken = 'token';
  static const String _keyUserId = 'user_id';
  static const String _keyUsername = 'username';
  static const String _keyEmail = 'email';
  static const String _keyProfilePicture = 'pfp';
  static const String _keyIsAdmin = 'is_admin';

  // Simpan sesi pengguna
  Future<void> saveSession(String token, int userId, String username, String email, String profilePicture, bool isAdmin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setInt(_keyUserId, userId);
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyProfilePicture, profilePicture);
    await prefs.setBool(_keyIsAdmin, isAdmin);
  }

  // Perbarui data pengguna
  Future<void> updateUser(String username, String email, String profilePicture) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyProfilePicture, profilePicture);
  }

  // Ambil token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  // Ambil username
  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  // Ambil email
  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  // Ambil profile picture
  Future<String?> getProfilePicture() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyProfilePicture);
  }

  // Ambil status admin
  Future<bool> isAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsAdmin) ?? false;
  }

  // Hapus sesi (logout)
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}