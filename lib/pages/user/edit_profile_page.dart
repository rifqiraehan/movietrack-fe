import 'package:flutter/material.dart';
import 'package:movietrack/models/user.dart';
import 'package:movietrack/utils/common.dart';

class EditProfilePage extends StatefulWidget {
  final User user;

  const EditProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? _profilePicture; // Placeholder for profile picture URL

  void _pickImage() {
    // Implementasi untuk memilih gambar dari galeri
    print("Choose Profile Picture");
  }

  void _saveProfile() {
    // Implementasi untuk menyimpan data profil
    print("Save Profile Data");
    Navigator.pop(context);
  }

  void _closePage() {
    // Logika untuk menutup halaman
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Custom AppBar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFBDBDBD), width: 1), // Divider
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon Close (X)
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: _closePage,
                ),
                // Title
                const Text(
                  "Edit Profile",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                // Save Button
                GestureDetector(
                  onTap: _saveProfile,
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4F378B),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Form dan Konten Lainnya
            Expanded(
            child: Center(
              child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                const SizedBox(height: 20),
                // Profile Picture Section
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _profilePicture != null ? NetworkImage(_profilePicture!) : null,
                  child: _profilePicture == null
                    ? const Icon(Icons.add_a_photo, size: 40, color: Colors.grey)
                    : null,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFF4F378B)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                  "Pilih Foto",
                  style: TextStyle(color: Color(0xFF4F378B)),
                  ),
                ),
                const SizedBox(height: 20),
                // Form Fields
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                  labelText: "Username",
                  border: UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                  labelText: "Email",
                  border: UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                  labelText: "Ganti Password",
                  border: UnderlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                  labelText: "Konfirmasi Password Baru",
                  border: UnderlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                ],
              ),
              ),
            ),
            ),
        ],
      ),
    );
  }
}