import 'package:flutter/material.dart';
import 'package:movietrack/screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movietrack/utils/session.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    final sessionManager = SessionManager();
    await sessionManager.clearSession();

    // Kembali ke LoginScreen setelah logout
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MovieTrack',
      theme: ThemeData(
        primaryColor: const Color(0xFF4F378B),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const LoginScreen(),
    );
  }
}