import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/doctor_provider.dart';
import 'update_doctor_in_list.dart';
import 'view_doctor_by_id_screen.dart';

class ViewAllDoctorsScreen extends StatefulWidget {
  @override
  _ViewAllDoctorsScreenState createState() => _ViewAllDoctorsScreenState();
}

class _ViewAllDoctorsScreenState extends State<ViewAllDoctorsScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<DoctorProvider>(context, listen: false).fetchAllDoctors();
    });
  }

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context);
    final doctors = doctorProvider.doctors;

    return Scaffold(
      backgroundColor:
          const Color(0xFFDAFDF9), // Set background color to DAFDF9
      appBar: AppBar(
        title: const Text('All Doctors'),
      ),
      body: doctors.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final doctor = doctors[index];
                return Card(
                  elevation: 2,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                          doctor.name[0]), // First letter of the doctor's name
                    ),
                    title: Text(doctor.name),
                    subtitle: Text(doctor.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility),
                          onPressed: () {
                            // Navigate to ViewDoctorProfileScreen with doctorId
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ViewDoctorByIdScreen(doctorId: doctor.id),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Navigate to UpdateDoctorProfileScreen with doctorId
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateDoctorInListScreen(
                                    doctorId: doctor.id),
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
                                  title: const Text('Delete Doctor'),
                                  content: const Text(
                                      'Are you sure you want to delete this doctor?'),
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
                                        // Call delete function in DoctorProvider
                                        doctorProvider.deleteDoctor(doctor.id);
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
