
class User {
  final String username;
  final String password;

  User({required this.username, required this.password});

  // Convert to JSON (untuk dikirim ke API)
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}