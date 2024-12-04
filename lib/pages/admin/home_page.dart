import 'package:flutter/material.dart';
import 'package:movietrack/models/user.dart';
import 'package:movietrack/screens/login_screen.dart';
import 'package:movietrack/utils/session.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<User> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllUsers();
  }

  Future<void> _fetchAllUsers() async {
    setState(() {
      _isLoading = true;
    });

    final users = await User.fetchAllUsers();
    setState(() {
      _users = users;
      _isLoading = false;
    });
  }

  Future<void> _searchUsers(String query) async {
    setState(() {
      _isLoading = true;
    });

    final users = await User.searchUsers(query);
    setState(() {
      _users = users;
      _isLoading = false;
    });
  }

  Future<void> _resetPassword(int userId, String email) async {
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: const Text('Are you sure you want to reset the password for this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('OK', style: TextStyle(color: Color.fromARGB(255, 79, 55, 139))),
          ),
        ],
      ),
    );

    if (result == true) {
      await User.resetPassword(userId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset successfully')),
      );

      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: email,
        query: Uri.encodeFull(
          'subject=[MovieTrack] Confirmed Request Password&body=Password akun Anda telah berhasil direset. Password sementara Anda adalah \'secret\'.\n\nDemi keamanan, kami menyarankan Anda untuk segera mengubah password ini melalui pengaturan akun MovieTrack.\n\nTerima kasih atas kepercayaan Anda menggunakan MovieTrack.',
        ),
      );

      launchUrl(emailLaunchUri);
    }
  }

  Future<void> _removeUser(int userId) async {
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove User'),
        content: const Text('Are you sure you want to remove this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('OK', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (result == true) {
      await User.removeUser(userId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User removed successfully')),
      );
      _fetchAllUsers(); // Refresh the user list
    }
  }

  Future<void> _logout(BuildContext context) async {
    final sessionManager = SessionManager();
    await sessionManager.clearSession();

    // Navigate to LoginScreen after logout
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
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
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFE6E0E9)),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _fetchAllUsers();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (query) {
                if (query.isEmpty) {
                  _fetchAllUsers();
                } else {
                  _searchUsers(query);
                }
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      return UserCard(
                        user: user,
                        onResetPassword: () => _resetPassword(user.userId, user.email),
                        onRemoveUser: () => _removeUser(user.userId),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback onResetPassword;
  final VoidCallback onRemoveUser;

  const UserCard({
    Key? key,
    required this.user,
    required this.onResetPassword,
    required this.onRemoveUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePicture),
                  radius: 20,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.username,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user.email,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 16, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: onResetPassword,
                  child: const Text('Reset', style: TextStyle(color: Color.fromARGB(255, 79, 55, 139))),
                ),
                TextButton(
                  onPressed: onRemoveUser,
                  child: const Text('Remove', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}