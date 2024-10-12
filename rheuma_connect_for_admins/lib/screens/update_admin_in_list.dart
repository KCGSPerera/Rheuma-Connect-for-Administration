import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';
import 'view_admin_by_id_screen.dart';
import 'view_all_admins_screen.dart';

class UpdateAdminInListScreen extends StatefulWidget {
  final String adminId;

  const UpdateAdminInListScreen({required this.adminId, Key? key})
      : super(key: key);

  @override
  _UpdateAdminInListScreenState createState() =>
      _UpdateAdminInListScreenState();
}

class _UpdateAdminInListScreenState extends State<UpdateAdminInListScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();

  bool _isLoading = true; // Add loading flag

  @override
  void initState() {
    super.initState();
    _fetchAdminDetails(); // Fetch the admin details
  }

  // Fetch the admin details based on the adminId
  Future<void> _fetchAdminDetails() async {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    await adminProvider.fetchAdminInList(
        widget.adminId); // Fetch admin using the newly added method

    // Initialize the form with the admin data
    final admin = adminProvider.viewedAdmin;
    if (admin != null) {
      _nameController.text = admin.name;
      _usernameController.text = admin.username;
      _emailController.text = admin.email;
      _phoneController.text = admin.contact;
      _nicController.text = admin.nic;
    }

    setState(() {
      _isLoading = false; // Mark as not loading
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    return Scaffold(
      backgroundColor:
          const Color(0xFFDAFDF9), // Set background color to DAFDF9
      appBar: AppBar(
        title: const Text('Update Admin Profile'),
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
      body: _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Display loader when fetching data
          : Padding(
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
                    onPressed: () async {
                      // Update the viewed admin profile
                      await adminProvider.updateAdminInList(
                          widget.adminId,
                          _emailController.text,
                          _usernameController.text,
                          _nameController.text,
                          _phoneController.text,
                          _nicController.text);

                      // After updating, navigate back to ViewAdminByIdScreen or ViewAllAdminsScreen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewAdminByIdScreen(
                            adminId: widget.adminId,
                          ),
                        ),
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
                      // Navigate back to the ViewAdminByIdScreen without updating
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewAdminByIdScreen(
                            adminId: widget.adminId,
                          ),
                        ),
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
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Optionally, navigate back to the ViewAllAdminsScreen after the update
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewAllAdminsScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      'Go to All Admins',
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
