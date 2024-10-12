import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';
import 'update_admin_profile_screen.dart';
import 'admin_dashboard_screen.dart';

class ViewAdminProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    final admin = adminProvider.admin;

    return Scaffold(
      backgroundColor:
          const Color(0xFFDAFDF9), // Set background color to DAFDF9
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: const Text('Admin Profile'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'Profile':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewAdminProfileScreen()),
                  );
                  break;
                case 'Dashboard':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminDashboardScreen()),
                  );
                  break;
                case 'Logout':
                  adminProvider.logoutAdmin(context).then((_) {
                    Navigator.of(context).pushReplacementNamed('/admin-login');
                  });
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
                  value: 'Dashboard',
                  child: Text('Dashboard'),
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
      body: admin == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              const AssetImage('assets/default_profile.png'),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${admin.name}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          admin.role,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        buildProfileRow("Admin ID", admin.id),
                        buildProfileRow("Username", admin.username),
                        buildProfileRow("Email", admin.email),
                        buildProfileRow("Contact", admin.contact),
                        buildProfileRow("NIC", admin.nic),
                        buildProfileRow("Role", admin.role),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Edit Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UpdateAdminProfileScreen()), // Navigate to the update admin profile screen
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "EDIT",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Helper function to build profile rows
  Widget buildProfileRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
