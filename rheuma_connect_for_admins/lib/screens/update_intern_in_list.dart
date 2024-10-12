import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/intern_provider.dart';
import 'view_intern_by_id_screen.dart';
import 'view_all_interns_screen.dart';

class UpdateInternInListScreen extends StatefulWidget {
  final String internId;

  const UpdateInternInListScreen({required this.internId, Key? key})
      : super(key: key);

  @override
  _UpdateInternInListScreenState createState() =>
      _UpdateInternInListScreenState();
}

class _UpdateInternInListScreenState extends State<UpdateInternInListScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();

  bool _isLoading = true; // Add loading flag

  @override
  void initState() {
    super.initState();
    _fetchInternDetails(); // Fetch the intern details
  }

  // Fetch the intern details based on the internId
  Future<void> _fetchInternDetails() async {
    final internProvider = Provider.of<InternProvider>(context, listen: false);
    await internProvider.fetchInternInList(widget.internId);

    // Initialize the form with the intern data
    final intern = internProvider.viewedIntern;
    if (intern != null) {
      _nameController.text = intern.name;
      _usernameController.text = intern.username;
      _emailController.text = intern.email;
      _phoneController.text = intern.contact;
      _nicController.text = intern.nic;
    }

    setState(() {
      _isLoading = false; // Mark as not loading
    });
  }

  @override
  Widget build(BuildContext context) {
    final internProvider = Provider.of<InternProvider>(context);

    return Scaffold(
      backgroundColor:
          const Color(0xFFDAFDF9), // Set background color to DAFDF9
      appBar: AppBar(
        title: const Text('Update Intern Profile'),
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
                      // Update the viewed intern profile
                      await internProvider.updateInternProfile(
                          widget.internId,
                          _emailController.text,
                          _usernameController.text,
                          _nameController.text,
                          _phoneController.text,
                          _nicController.text);

                      // After updating, navigate back to ViewInternByIdScreen or ViewAllInternsScreen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewInternByIdScreen(
                            internId: widget.internId,
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
                      // Navigate back to the ViewInternByIdScreen without updating
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewInternByIdScreen(
                            internId: widget.internId,
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
                      // Optionally, navigate back to the ViewAllInternsScreen after the update
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewAllInternsScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      'Go to All Interns',
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
