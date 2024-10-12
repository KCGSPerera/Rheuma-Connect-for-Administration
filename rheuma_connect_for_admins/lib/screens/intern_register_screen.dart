import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/intern_provider.dart';
import 'admin_dashboard_screen.dart';

class InternRegisterScreen extends StatefulWidget {
  @override
  _InternRegisterScreenState createState() => _InternRegisterScreenState();
}

class _InternRegisterScreenState extends State<InternRegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController nicController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDAFDF9), // Light background color
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40), // Space at the top for the title
                const Text(
                  'Intern Register',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontFamily: 'Serif',
                  ),
                ),
                const SizedBox(height: 40),
                _buildTextFormField('Username', usernameController),
                _buildTextFormField('Email', emailController),
                _buildTextFormField('Password', passwordController,
                    obscureText: true),
                _buildTextFormField(
                    'Confirm Password', confirmPasswordController,
                    obscureText: true),
                _buildTextFormField('Full Name', nameController),
                _buildTextFormField('Contact Number', contactController),
                _buildTextFormField('NIC', nicController),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    final username = usernameController.text;
                    final email = emailController.text;
                    final password = passwordController.text;
                    final confirmPassword = confirmPasswordController.text;
                    final name = nameController.text;
                    final contact = contactController.text;
                    final nic = nicController.text;

                    if (password != confirmPassword) {
                      _showErrorDialog(
                          context, 'Error', 'Passwords do not match.');
                      return;
                    }

                    try {
                      // Register intern using the InternProvider
                      await context.read<InternProvider>().registerIntern(
                            username,
                            email,
                            password,
                            name,
                            contact,
                            nic,
                          );

                      if (mounted) {
                        // Show success message
                        _showSuccessDialog(context, 'Success',
                            'Intern registered successfully.');
                      }
                    } catch (error) {
                      if (mounted) {
                        _showErrorDialog(context, 'Registration Failed',
                            'Please try again. Error: $error');
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D597C), // Dark blue color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 16), // Button size
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    if (mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => AdminDashboardScreen()),
                      );
                    }
                  },
                  child: const Text(
                    'Back to Dashboard',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF0D597C),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, TextEditingController controller,
      {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: label,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
                vertical: 16, horizontal: 20), // Padding inside the text field
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Helper function to show the error dialog using a valid BuildContext
  void _showErrorDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Helper function to show success dialog with navigation to the dashboard
  void _showSuccessDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to Admin Dashboard after registration
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => AdminDashboardScreen()),
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
