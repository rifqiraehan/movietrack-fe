import 'package:flutter/material.dart';
import 'package:movietrack/models/user.dart';
import 'package:movietrack/utils/file_picker_mobile.dart' if (dart.library.html) 'package:movietrack/utils/file_picker_web.dart';
import 'package:movietrack/utils/session.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class EditProfilePage extends StatefulWidget {
  final User user;

  const EditProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  dynamic _imageFile;
  String? _profilePicture;

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.user.username;
    _emailController.text = widget.user.email;
    _profilePicture = widget.user.profilePicture; // Initialize with current user's profile picture
  }

  Future<void> _pickImage() async {
    final pickedFile = await pickImage();
    if (pickedFile != null) {
      setState(() {
        if (pickedFile is Uint8List) {
          _imageFile = pickedFile;
        } else {
          _imageFile = pickedFile;
        }
      });
    }
  }

  Future<void> _saveProfile() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (username.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username and Email cannot be empty")),
      );
      return;
    }

    if (password.isNotEmpty && password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    final errorMessage = await User.updateProfile(
      username: username,
      email: email,
      password: password.isNotEmpty ? password : null,
      profilePictureFile: _imageFile,
    );

    if (errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );

      // Refresh user data
      final updatedUser = await User.getUserProfile();
      if (updatedUser != null) {
        final sessionManager = SessionManager();
        await sessionManager.updateUser(updatedUser.username, updatedUser.email, updatedUser.profilePicture);
        setState(() {
          _profilePicture = updatedUser.profilePicture; // Update with the latest profile picture
          _imageFile = null; // Clear the image file after successful update
        });
      }

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $errorMessage")),
      );
    }
  }

  void _closePage() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark, // Change this to the desired style
        child: SafeArea(
          child: Column(
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
                    InkWell(
                      onTap: _saveProfile,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4F378B),
                            fontWeight: FontWeight.bold,
                          ),
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
                            backgroundImage: _imageFile != null
                                ? (_imageFile is Uint8List
                                    ? MemoryImage(_imageFile)
                                    : FileImage(_imageFile as File))
                                : (_profilePicture != null ? NetworkImage(_profilePicture!) : null),
                            child: _imageFile == null && _profilePicture == null
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
        ),
      ),
    );
  }
}