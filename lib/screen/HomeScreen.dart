import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Profile.dart'; // Import Profile Screen
import 'ProgressScreen.dart'; // Import Progress Screen
import 'ChallengesScreen.dart'; // Import Challenges Screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String firstName = "User"; // Default name
  String profilePicUrl = ""; // Default profile picture

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch user first name and profile picture from Firestore
  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          firstName = userDoc['firstName'] ?? "User"; // Fetch first name
          profilePicUrl = userDoc['profilePic'] ?? ""; // Fetch profile picture
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      HomeContent(firstName: firstName, profilePicUrl: profilePicUrl),
      ProgressScreen(),
      ChallengesScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Progress"),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: "Challenges"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

// Extracted Home Content Widget
class HomeContent extends StatelessWidget {
  final String firstName;
  final String profilePicUrl;

  const HomeContent({super.key, required this.firstName, required this.profilePicUrl});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting with Profile Picture
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfileScreen()),
                    );
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: profilePicUrl.isNotEmpty
                            ? NetworkImage(profilePicUrl)
                            : const AssetImage('assets/default_profile.jpg') as ImageProvider, // Default image
                        radius: 22,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Good morning", style: TextStyle(fontSize: 14, color: Colors.grey)),
                          Text(firstName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // Updated to show fetched name
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {},
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Today's Progress Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Today's Progress", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("March 15, 2025", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _progressItem(Icons.directions_walk, "Steps", "6,542", Colors.blue),
                      _progressItem(Icons.water_drop, "Water", "1.2L", Colors.lightBlueAccent),
                      _progressItem(Icons.accessibility, "Posture", "Good", Colors.blueAccent),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Health Goals Section
            const Text("Health Goals", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _goalProgress("Daily Steps", 0.65, Colors.blue),
            _goalProgress("Water Intake", 0.40, Colors.teal),
            _goalProgress("Posture Check", 0.80, Colors.blue),
            const SizedBox(height: 20),

            // Quick Actions Section
            const Text("Quick Actions", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                _quickAction("Set Reminder", Icons.notifications, Colors.blue),
                const SizedBox(width: 15),
                _quickAction("Add Water", Icons.add, Colors.teal),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Progress item widget
  Widget _progressItem(IconData icon, String title, String value, Color color) {
    return Column(
      children: [
        Icon(icon, size: 30, color: color),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 3),
        Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  // Goal progress bar
  Widget _goalProgress(String title, double progress, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 5),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            color: color,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  // Quick action buttons
  Widget _quickAction(String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
