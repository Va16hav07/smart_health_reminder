import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'Login_screen.dart';
import 'personal_info_screen.dart';
import 'notifications_screen.dart';
import 'privacy_security_screen.dart';
import 'appearance_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  File? _image;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch user data from Firestore
  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot =
      await _firestore.collection('users').doc(user.uid).get();
      if (snapshot.exists) {
        setState(() {
          userData = snapshot.data() as Map<String, dynamic>;
        });
      }
    }
  }

  // Pick an image from the gallery
  Future<void> _pickImage() async {
    try {
      final pickedFile =
      await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        setState(() {
          _image = imageFile;
        });
        await _uploadImage(imageFile);
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  // Upload image to Firebase Storage & update Firestore
  Future<void> _uploadImage(File image) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        Reference storageRef =
        FirebaseStorage.instance.ref().child('profile_pics/${user.uid}.jpg');
        UploadTask uploadTask = storageRef.putFile(image);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        await _firestore.collection('users').doc(user.uid).update({
          'profilePic': downloadUrl,
        });
        setState(() {
          userData?['profilePic'] = downloadUrl;
        });
      }
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  // Sign out user
  Future<void> _signOut() async {
    await _auth.signOut();
    if (mounted) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Picture with Edit Icon
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: (userData?['profilePic']?.isNotEmpty ?? false)
                        ? NetworkImage(userData!['profilePic'])
                        : const AssetImage('assets/default_profile.jpg')
                    as ImageProvider,
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

            // User's Name (Fetched from Firestore)
            Text(
              userData?['firstName'] ?? 'User',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),

            // User's Email (Fetched from Firestore)
            Text(
              userData?['email'] ?? 'Email not available',
              style: TextStyle(color: Colors.grey[600]),
            ),

            const SizedBox(height: 20),

            // User Stats (Tasks, Completion, Projects)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatCard('47', 'Tasks', Colors.blue),
                _buildStatCard('82%', 'Complete', Colors.green),
                _buildStatCard('12', 'Projects', Colors.purple),
              ],
            ),
            const SizedBox(height: 20),

            // Profile Options
            _buildSettingsItem(Icons.person, 'Personal Information',
                const PersonalInfoScreen()),
            _buildSettingsItem(Icons.notifications, 'Notifications',
                const NotificationsScreen()),
            _buildSettingsItem(Icons.lock, 'Privacy & Security',
                const PrivacySecurityScreen()),
            _buildSettingsItem(Icons.color_lens, 'Appearance',
                const AppearanceScreen()),
            _buildSettingsItem(
                Icons.settings, 'Settings', const SettingsScreen()),

            const SizedBox(height: 20),

            // Sign Out Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _signOut,
                icon: const Icon(Icons.logout),
                label: const Text("Sign Out"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for displaying user statistics
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

  // Widget for settings options
  Widget _buildSettingsItem(IconData icon, String title, Widget destinationScreen) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 16, color: Colors.grey),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => destinationScreen));
        },
      ),
    );
  }
}
