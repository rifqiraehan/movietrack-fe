import 'package:flutter/material.dart';
import 'package:movietrack/utils/session.dart';
import 'package:movietrack/models/user.dart';
import 'package:movietrack/pages/user/edit_profile_page.dart';
import 'package:movietrack/utils/common.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<User?> _userProfile;

  @override
  void initState() {
    super.initState();
    _userProfile = _loadUserProfile();
  }

  Future<User?> _loadUserProfile() async {
    final user = await User.getUserProfile();
    if (user != null) {
      final sessionManager = SessionManager();
      await sessionManager.updateUser(user.username, user.email, user.profilePicture);
    }
    return user;
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
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFE6E0E9)),
            onPressed: () => CommonUtils.logout(context),
          ),
        ],
      ),
      body: FutureBuilder<User?>(
        future: _userProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Failed to load profile"));
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            final Map<String, int> stats = {
              "Watching": 3,
              "Completed": 4,
              "Dropped": 0,
              "Plan to Watch": 6,
            };

            return Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    // Profile Picture
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                          user.profilePicture.isNotEmpty ? NetworkImage(user.profilePicture) : null,
                      child: user.profilePicture.isEmpty
                          ? const Icon(Icons.person, size: 50, color: Colors.grey)
                          : null,
                    ),
                    const SizedBox(height: 10),
                    // Edit Profile Button
                    ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditProfilePage(user: user)),
                        );
                        if (result == true) {
                          setState(() {
                            _userProfile = _loadUserProfile();
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFF4F378B)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(color: Color(0xFF4F378B)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Username & Email
                    Text(
                      user.username,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user.email,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    // Divider
                    const Divider(thickness: 1, indent: 40, endIndent: 40),
                    // Stats
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: stats.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  entry.key,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  entry.value.toString(),
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    // Divider
                    const Divider(thickness: 1, indent: 40, endIndent: 40),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text("No profile data"));
          }
        },
      ),
    );
  }
}