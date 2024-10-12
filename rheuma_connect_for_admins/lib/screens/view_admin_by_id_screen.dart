import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';

class ViewAdminByIdScreen extends StatefulWidget {
  final String adminId;

  const ViewAdminByIdScreen({required this.adminId, Key? key})
      : super(key: key);

  @override
  _ViewAdminByIdScreenState createState() => _ViewAdminByIdScreenState();
}

class _ViewAdminByIdScreenState extends State<ViewAdminByIdScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAdminDetails();
  }

  // Method to fetch the admin details
  Future<void> _fetchAdminDetails() async {
    try {
      await Provider.of<AdminProvider>(context, listen: false)
          .fetchAdminInList(widget.adminId);
    } catch (error) {
      print('Error fetching admin details: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    final viewedAdmin = adminProvider.viewedAdmin;

    return WillPopScope(
      onWillPop: () async {
        // Clear the viewed admin data when the user navigates back
        adminProvider.clearViewedAdmin();
        return true; // Allow navigation
      },
      child: Scaffold(
        backgroundColor:
            const Color(0xFFDAFDF9), // Set background color to DAFDF9
        appBar: AppBar(
          title: const Text('Admin Details'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              adminProvider
                  .clearViewedAdmin(); // Clear viewed admin data when going back
              Navigator.pop(context);
            },
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : viewedAdmin == null
                ? const Center(child: Text('Admin not found.'))
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Admin details
                        Center(
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: const AssetImage(
                                    'assets/default_profile.png'),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${viewedAdmin.name}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                viewedAdmin.role,
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
                              buildProfileRow("Admin ID", viewedAdmin.id),
                              buildProfileRow("Username", viewedAdmin.username),
                              buildProfileRow("Email", viewedAdmin.email),
                              buildProfileRow("Contact", viewedAdmin.contact),
                              buildProfileRow("NIC", viewedAdmin.nic),
                              buildProfileRow("Role", viewedAdmin.role),
                            ],
                          ),
                        ),
                      ],
                    ),
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
