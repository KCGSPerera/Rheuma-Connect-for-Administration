import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/doctor_provider.dart';
import 'view_doctor_by_id_screen.dart';
import 'view_all_doctors_screen.dart';

class UpdateDoctorInListScreen extends StatefulWidget {
  final String doctorId;

  const UpdateDoctorInListScreen({required this.doctorId, Key? key})
      : super(key: key);

  @override
  _UpdateDoctorInListScreenState createState() =>
      _UpdateDoctorInListScreenState();
}

class _UpdateDoctorInListScreenState extends State<UpdateDoctorInListScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();

  bool _isLoading = true; // Add loading flag

  @override
  void initState() {
    super.initState();
    _fetchDoctorDetails(); // Fetch the doctor details
  }

  // Fetch the doctor details based on the doctorId
  Future<void> _fetchDoctorDetails() async {
    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    await doctorProvider.fetchDoctorInList(widget.doctorId);

    // Initialize the form with the doctor data
    final doctor = doctorProvider.viewedDoctor;
    if (doctor != null) {
      _nameController.text = doctor.name;
      _usernameController.text = doctor.username;
      _emailController.text = doctor.email;
      _phoneController.text = doctor.contact;
      _nicController.text = doctor.nic;
    }

    setState(() {
      _isLoading = false; // Mark as not loading
    });
  }

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context);

    return Scaffold(
      backgroundColor:
          const Color(0xFFDAFDF9), // Set background color to DAFDF9
      appBar: AppBar(
        title: const Text('Update Doctor Profile'),
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
                      // Update the viewed doctor profile
                      await doctorProvider.updateDoctorProfile(
                          widget.doctorId,
                          _emailController.text,
                          _usernameController.text,
                          _nameController.text,
                          _phoneController.text,
                          _nicController.text);

                      // After updating, navigate back to ViewDoctorByIdScreen or ViewAllDoctorsScreen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewDoctorByIdScreen(
                            doctorId: widget.doctorId,
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
                      // Navigate back to the ViewDoctorByIdScreen without updating
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewDoctorByIdScreen(
                            doctorId: widget.doctorId,
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
                      // Optionally, navigate back to the ViewAllDoctorsScreen after the update
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewAllDoctorsScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      'Go to All Doctors',
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
