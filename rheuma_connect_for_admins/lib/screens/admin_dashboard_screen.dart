import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';
import 'view_admin_profile_screen.dart';
import 'view_all_admins_screen.dart';
import 'intern_register_screen.dart';
import 'view_all_interns_screen.dart';
import 'doctor_register_screen.dart';
import 'admin_register_screen.dart';
import 'view_all_doctors_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    final admin = adminProvider.admin;
    String firstName = admin != null
        ? admin.name.split(' ')[0]
        : "Admin"; // Fallback to "Admin" if admin name is not available

    return Scaffold(
      backgroundColor:
          const Color(0xFFDAFDF9), // Set background color to DAFDF9
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open drawer on press
              },
            );
          },
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'Profile':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewAdminProfileScreen()),
                  );
                  break;
                case 'Logout':
                  await context
                      .read<AdminProvider>()
                      .logoutAdmin(context); // Use logout function
                  Navigator.of(context).pushReplacementNamed('/admin-login');
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'Profile',
                  child: Text('Profile'),
                ),
                const PopupMenuItem(
                  value: 'Logout',
                  child: Text('Logout'),
                ),
              ];
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Admin Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40, // Increased font size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(
                'Profile',
                style: TextStyle(fontSize: 23), // Increased font size
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewAdminProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text(
                'View All Admins',
                style: TextStyle(fontSize: 23), // Increased font size
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewAllAdminsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text(
                'View All Interns',
                style: TextStyle(fontSize: 23), // Increased font size
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewAllInternsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_search),
              title: const Text(
                'View All Doctors',
                style: TextStyle(fontSize: 23), // Increased font size
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewAllDoctorsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text(
                'Dashboard',
                style: TextStyle(fontSize: 23), // Increased font size
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdminDashboardScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                'Logout',
                style: TextStyle(fontSize: 23), // Increased font size
              ),
              onTap: () async {
                await context
                    .read<AdminProvider>()
                    .logoutAdmin(context); // Use logout function
                Navigator.of(context).pushReplacementNamed('/admin-login');
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Admin greeting section
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            AssetImage('assets/default_profile.png'),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, $firstName...',
                            style: const TextStyle(
                              fontSize: 28, // Increased font size
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Actions for Admin
                  Center(
                    child: Column(
                      children: [
                        _buildDashboardButton(
                          'Register New Admin',
                          Icons.admin_panel_settings,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminRegisterScreen()),
                            );
                          },
                        ),
                        _buildDashboardButton(
                          'Register New Doctor',
                          Icons.medical_services,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DoctorRegisterScreen()),
                            );
                          },
                        ),
                        _buildDashboardButton(
                          'Register New Intern',
                          Icons.school,
                          () {
                            // Navigate to Register Intern screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InternRegisterScreen()),
                            );
                          },
                        ),
                        _buildDashboardButton(
                          'View All Doctors',
                          Icons.person_search,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewAllDoctorsScreen()),
                            );
                          },
                        ),
                        _buildDashboardButton(
                          'View All Interns',
                          Icons.group,
                          () {
                            // Navigate to View All Interns screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewAllInternsScreen()),
                            );
                          },
                        ),
                        _buildDashboardButton(
                          'View Profile',
                          Icons.person,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ViewAdminProfileScreen()),
                            );
                          },
                        ),
                        _buildDashboardButton(
                          'View All Admins',
                          Icons.people,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewAllAdminsScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Floating Action Button (optional)
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: () {
                  // Handle message button press or additional action
                },
                backgroundColor: Colors.blue,
                child: Icon(Icons.message),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to create a button that spans the full width
  Widget _buildDashboardButton(
      String title, IconData icon, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16.0),
          backgroundColor: Colors.lightBlueAccent, // Same color for all buttons
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Reduced border radius
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            Icon(
              icon,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
