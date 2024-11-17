import 'package:flutter/material.dart';
import 'package:movietrack/screens/login_screen.dart';
import 'package:movietrack/pages/home_screen.dart';
import 'package:movietrack/pages/admin/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movietrack/utils/session.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  Future<Map<String, dynamic>> _checkLoginStatus() async {
    final sessionManager = SessionManager();
    final token = await sessionManager.getToken();

    return {
      'token': token
    };
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
      home: FutureBuilder<Map<String, dynamic>>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData && snapshot.data!['token'] != null) {
              return const HomeScreen();
          } else {
              return const LoginScreen();
          }
        },
      ),
    );
  }
}