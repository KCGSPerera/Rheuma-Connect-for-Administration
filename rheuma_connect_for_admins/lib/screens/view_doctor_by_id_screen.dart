import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/doctor_provider.dart';

class ViewDoctorByIdScreen extends StatefulWidget {
  final String doctorId;

  const ViewDoctorByIdScreen({required this.doctorId, Key? key})
      : super(key: key);

  @override
  _ViewDoctorByIdScreenState createState() => _ViewDoctorByIdScreenState();
}

class _ViewDoctorByIdScreenState extends State<ViewDoctorByIdScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDoctorDetails();
  }

  // Method to fetch the doctor details
  Future<void> _fetchDoctorDetails() async {
    try {
      await Provider.of<DoctorProvider>(context, listen: false)
          .fetchDoctorInList(widget.doctorId);
    } catch (error) {
      print('Error fetching doctor details: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context);
    final viewedDoctor = doctorProvider.viewedDoctor;

    return WillPopScope(
      onWillPop: () async {
        // Clear the viewed doctor data when the user navigates back
        doctorProvider.clearViewedDoctor();
        return true; // Allow navigation
      },
      child: Scaffold(
        backgroundColor:
            const Color(0xFFDAFDF9), // Set background color to DAFDF9
        appBar: AppBar(
          title: const Text('Doctor Details'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              doctorProvider
                  .clearViewedDoctor(); // Clear viewed doctor data when going back
              Navigator.pop(context);
            },
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : viewedDoctor == null
                ? const Center(child: Text('Doctor not found.'))
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Doctor details
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
                                viewedDoctor.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                viewedDoctor.role,
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
                              buildProfileRow("Doctor ID", viewedDoctor.docId),
                              buildProfileRow(
                                  "Username", viewedDoctor.username),
                              buildProfileRow("Email", viewedDoctor.email),
                              buildProfileRow("Contact", viewedDoctor.contact),
                              buildProfileRow("NIC", viewedDoctor.nic),
                              buildProfileRow("Role", viewedDoctor.role),
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
