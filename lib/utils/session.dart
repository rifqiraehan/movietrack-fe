import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyToken = 'token';
  static const String _keyUserId = 'user_id';
  static const String _keyUsername = 'username';
  static const String _keyIsAdmin = 'is_admin';

  // Simpan sesi pengguna
  Future<void> saveSession(String token, int userId, String username, bool isAdmin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setInt(_keyUserId, userId);
    await prefs.setString(_keyUsername, username);
    await prefs.setBool(_keyIsAdmin, isAdmin);
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