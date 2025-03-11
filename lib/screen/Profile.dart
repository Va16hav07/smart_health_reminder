import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'appearance_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// Profile Picture
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _image != null
                        ? FileImage(_image!) as ImageProvider
                        : const AssetImage('assets/default_profile.jpg'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt,
                            size: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              'Alex Morgan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text('@alexmorgan', style: TextStyle(color: Colors.grey)),

            const SizedBox(height: 20),

            /// Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatCard('47', 'Tasks', Colors.blue),
                _buildStatCard('82%', 'Complete', Colors.green),
                _buildStatCard('12', 'Projects', Colors.purple),
              ],
            ),

            const SizedBox(height: 20),

            /// Settings List
            _buildSettingsItem(Icons.person, 'Personal Information', () {}),
            _buildSettingsItem(Icons.notifications, 'Notifications', () {}),
            _buildSettingsItem(Icons.lock, 'Privacy & Security', () {}),
            _buildSettingsItem(Icons.color_lens, 'Appearance', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AppearanceScreen()),
              );
            }),
            _buildSettingsItem(Icons.settings, 'Settings', () {}),
          ],
        ),
      ),
    );
  }

  /// Helper Method: Build Stat Card
  Widget _buildStatCard(String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
