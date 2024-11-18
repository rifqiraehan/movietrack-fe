import 'package:flutter/material.dart';
import 'package:movietrack/screens/login_screen.dart';
import 'package:movietrack/utils/session.dart';

class CommonUtils {
  static Future<void> logout(BuildContext context) async {
    final sessionManager = SessionManager();
    await sessionManager.clearSession();

    // Navigate to LoginScreen after logout
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}