import 'package:flutter/material.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy & Security')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPrivacyOption(Icons.lock, 'Change Password'),
            _buildPrivacyOption(Icons.privacy_tip, 'Manage Account Privacy'),
            _buildPrivacyOption(Icons.delete, 'Delete Account'),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyOption(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        // Handle navigation
      },
    );
  }
}
