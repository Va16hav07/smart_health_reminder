import 'package:flutter/material.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personal Information')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Full Name', 'Alex Morgan'),
            _buildTextField('Username', '@alexmorgan'),
            _buildTextField('Email', 'alexmorgan@example.com'),
            _buildTextField('Phone Number', '+1 234 567 890'),
            _buildTextField('Date of Birth', 'Jan 15, 1995'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save updated info
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          hintText: value,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
