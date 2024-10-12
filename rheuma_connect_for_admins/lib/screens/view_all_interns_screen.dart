import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rheuma_connect_for_admins/screens/update_intern_in_list.dart';
import 'package:rheuma_connect_for_admins/screens/view_intern_by_id_screen.dart';
import '../providers/intern_provider.dart';

class ViewAllInternsScreen extends StatefulWidget {
  @override
  _ViewAllInternsScreenState createState() => _ViewAllInternsScreenState();
}

class _ViewAllInternsScreenState extends State<ViewAllInternsScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<InternProvider>(context, listen: false).fetchAllInterns();
    });
  }

  @override
  Widget build(BuildContext context) {
    final internProvider = Provider.of<InternProvider>(context);
    final interns = internProvider.interns;

    return Scaffold(
      backgroundColor:
          const Color(0xFFDAFDF9), // Set background color to DAFDF9
      appBar: AppBar(
        title: const Text('All Interns'),
      ),
      body: interns.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: interns.length,
              itemBuilder: (context, index) {
                final intern = interns[index];
                return Card(
                  elevation: 2,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                          intern.name[0]), // First letter of the intern's name
                    ),
                    title: Text(intern.name),
                    subtitle: Text(intern.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility),
                          onPressed: () {
                            // Navigate to ViewInternProfileScreen with internId
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewInternByIdScreen(
                                    internId: intern.id), //internId: intern.id
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Navigate to UpdateInternProfileScreen with internId
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateInternInListScreen(
                                    internId: intern.id), // internId: intern.id
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // Implement delete functionality here
                            // For now, you can show a dialog
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Delete Intern'),
                                  content: const Text(
                                      'Are you sure you want to delete this intern?'),
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
                                        // Call delete function in InternProvider
                                        internProvider.deleteIntern(intern.id);
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
