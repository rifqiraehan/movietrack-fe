import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyToken = 'token';
  static const String _keyUserId = 'user_id';
  static const String _keyUsername = 'username';

  // Simpan sesi pengguna
  Future<void> saveSession(String token, int userId, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setInt(_keyUserId, userId);
    await prefs.setString(_keyUsername, username);
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

  // Hapus sesi (logout)
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}