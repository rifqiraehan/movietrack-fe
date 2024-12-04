import 'package:flutter/material.dart';
import 'package:movietrack/screens/register_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:movietrack/pages/user/home_screen.dart';
import 'package:movietrack/pages/admin/home_page.dart';
import 'package:movietrack/models/user.dart';
import 'package:movietrack/utils/session.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    final errorMessage = await User.login(username, password);

    if (errorMessage == null) {
      final sessionManager = SessionManager();
      final isAdmin = await sessionManager.isAdmin();

      if (isAdmin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MovieTrack',
          style: TextStyle(color: Color(0xFFE6E0E9), fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4F378B),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'LOGIN',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF4F378B)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4F378B)),
                  child: const Text('Login', style: TextStyle(color: Colors.white)),
                ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                );
              },
              child: const Text('Belum Daftar? Daftar Sekarang'),
            ),
            TextButton(
              onPressed: () {
                launchUrl(
                  Uri.parse(
                    "mailto:rifqiraehan86@gmail.com?subject=%20%5BMovieTrack%5D%20Request%20Reset%20Password&body=Halo%2C%20Developer%20MovieTrack!%0A%0ASaya%20ingin%20melakukan%20reset%20password%20akun%20MovieTrack%20saya%20dengan%20nama%20akun%20email%20sebagai%20berikut%3A%0A%5Bnama_akun%5D%0A%0ASekian%2C%20Terima%20kasih.%0A%0A%0ACatatan%20Developer%3A%0AUntuk%20memastikan%20permintaan%20reset%20password%20dapat%20diproses%20dengan%20cepat%2C%20pastikan%20Anda%20mengirim%20email%20ini%20menggunakan%20akun%20email%20yang%20terdaftar%20di%20MovieTrack.%20Permintaan%20dari%20email%20yang%20tidak%20terdaftar%20akan%20ditolak."
                  )
                );
              },
              child: const Text('Lupa Password? Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}