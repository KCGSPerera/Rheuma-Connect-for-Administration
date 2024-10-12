import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';
import 'admin_dashboard_screen.dart';
import 'admin_register_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDAFDF9), // Light background color
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Admin Login',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontFamily: 'Serif',
                  ),
                ),
                const SizedBox(height: 40),
                _buildTextFormField('Email', emailController),
                _buildTextFormField('Password', passwordController,
                    obscureText: true),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final email = emailController.text;
                    final password = passwordController.text;

                    try {
                      // Call login method and get the adminId from the response
                      final adminId = await context
                          .read<AdminProvider>()
                          .login(email, password);

                      // Fetch the admin details using the adminId
                      await context.read<AdminProvider>().fetchAdmin(adminId);

                      // If mounted, navigate to Admin Dashboard
                      if (mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AdminDashboardScreen()),
                        );
                      }
                    } catch (error) {
                      if (mounted) {
                        // Show error message if login fails
                        _showErrorDialog(
                            context, 'Login Failed', 'Error: $error');
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
                    'Login',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    // Navigate to the AdminRegisterScreen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => AdminRegisterScreen()),
                    );
                  },
                  child: const Text(
                    'Register as New Admin',
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

  // Reusable text field builder
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
}





// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/admin_provider.dart';

// class AdminLoginScreen extends StatelessWidget {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Admin Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: const InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 final email = _emailController.text;
//                 final password = _passwordController.text;

//                 try {
//                   await context
//                       .read<AdminProvider>()
//                       .loginAdmin(email, password);
//                   Navigator.pushReplacementNamed(context, '/admin-dashboard');
//                 } catch (error) {
//                   print('Login failed: $error');
//                 }
//               },
//               child: const Text('Login'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pushNamed(
//                     context, '/register-admin'); // Register navigation
//               },
//               child: const Text('Register as New Admin'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
