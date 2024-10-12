import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rheuma_connect_for_admins/screens/update_admin_in_list.dart';
import 'package:rheuma_connect_for_admins/screens/view_admin_by_id_screen.dart';
import '../providers/admin_provider.dart';

class ViewAllAdminsScreen extends StatefulWidget {
  @override
  _ViewAllAdminsScreenState createState() => _ViewAllAdminsScreenState();
}

class _ViewAllAdminsScreenState extends State<ViewAllAdminsScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      Provider.of<AdminProvider>(context, listen: false).fetchAllAdmins();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    final admins = adminProvider.admins;

    return Scaffold(
      backgroundColor:
          const Color(0xFFDAFDF9), // Set background color to DAFDF9
      appBar: AppBar(
        title: const Text('All Admins'),
      ),
      body: admins.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: admins.length,
              itemBuilder: (context, index) {
                final admin = admins[index];
                return Card(
                  elevation: 2,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                          admin.name[0]), // First letter of the admin's name
                    ),
                    title: Text(admin.name),
                    subtitle: Text(admin.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility),
                          onPressed: () {
                            // Navigate to ViewAdminProfileScreen with adminId
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewAdminByIdScreen(
                                    adminId: admin.id), //adminId: admin.id
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Navigate to UpdateAdminProfileScreen with adminId
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateAdminInListScreen(
                                    adminId: admin.id), // adminId: admin.id
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // Show delete confirmation dialog
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Delete Admin'),
                                  content: const Text(
                                      'Are you sure you want to delete this admin?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Dismiss dialog
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Call delete function in AdminProvider
                                        adminProvider.deleteAdmin(admin.id);
                                        Navigator.of(context)
                                            .pop(); // Dismiss dialog
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
