import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';
import 'view_admin_profile_screen.dart';

class UpdateAdminProfileScreen extends StatefulWidget {
  @override
  _UpdateAdminProfileScreenState createState() =>
      _UpdateAdminProfileScreenState();
}

class _UpdateAdminProfileScreenState extends State<UpdateAdminProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final admin = Provider.of<AdminProvider>(context, listen: false).admin;
    if (admin != null) {
      _nameController.text = admin.name;
      _usernameController.text = admin.username;
      _emailController.text = admin.email;
      _phoneController.text = admin.contact;
      _nicController.text = admin.nic;
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    return Scaffold(
      backgroundColor:
          const Color(0xFFDAFDF9), // Set background color to DAFDF9
      appBar: AppBar(
        title: const Text('Update Profile'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Logout') {
                Navigator.of(context).pushReplacementNamed('/admin-login');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'Logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextFormField('Name', _nameController),
            _buildTextFormField('Username', _usernameController),
            _buildTextFormField('Email', _emailController),
            _buildTextFormField('Phone', _phoneController),
            _buildTextFormField('NIC', _nicController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                adminProvider.updateAdminProfile(
                    adminProvider.admin!.id,
                    _emailController.text,
                    _usernameController.text,
                    _nameController.text,
                    _phoneController.text,
                    _nicController.text);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewAdminProfileScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'UPDATE',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewAdminProfileScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
              child: const Text(
                'CANCEL',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create text fields
  Widget _buildTextFormField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
