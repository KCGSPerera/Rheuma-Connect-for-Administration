import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/intern_provider.dart';

class ViewInternByIdScreen extends StatefulWidget {
  final String internId;

  const ViewInternByIdScreen({required this.internId, Key? key})
      : super(key: key);

  @override
  _ViewInternByIdScreenState createState() => _ViewInternByIdScreenState();
}

class _ViewInternByIdScreenState extends State<ViewInternByIdScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchInternDetails();
  }

  // Method to fetch the intern details
  Future<void> _fetchInternDetails() async {
    try {
      await Provider.of<InternProvider>(context, listen: false)
          .fetchInternInList(widget.internId);
    } catch (error) {
      print('Error fetching intern details: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final internProvider = Provider.of<InternProvider>(context);
    final viewedIntern = internProvider.viewedIntern;

    return WillPopScope(
      onWillPop: () async {
        // Clear the viewed intern data when the user navigates back
        internProvider.clearViewedIntern();
        return true; // Allow navigation
      },
      child: Scaffold(
        backgroundColor:
            const Color(0xFFDAFDF9), // Set background color to DAFDF9
        appBar: AppBar(
          title: const Text('Intern Details'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              internProvider
                  .clearViewedIntern(); // Clear viewed intern data when going back
              Navigator.pop(context);
            },
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : viewedIntern == null
                ? const Center(child: Text('Intern not found.'))
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Intern details
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
                                viewedIntern.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                viewedIntern.role,
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
                              buildProfileRow(
                                  "Intern ID", viewedIntern.internId),
                              buildProfileRow(
                                  "Username", viewedIntern.username),
                              buildProfileRow("Email", viewedIntern.email),
                              buildProfileRow("Contact", viewedIntern.contact),
                              buildProfileRow("NIC", viewedIntern.nic),
                              buildProfileRow("Role", viewedIntern.role),
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
