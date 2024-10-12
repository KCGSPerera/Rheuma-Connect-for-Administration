// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/admin_provider.dart';
// import './update_admin_profile_screen.dart';

// class AdminProfileScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final adminProvider = Provider.of<AdminProvider>(context);
//     final admin = adminProvider.admin;

//     // Fetch the admin details if not already available
//     if (admin == null) {
//       return Scaffold(
//         appBar: AppBar(title: const Text('Admin Profile')),
//         body: const Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Admin Profile'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Name: ${admin['name']}',
//               style: const TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'Username: ${admin['username']}',
//               style: const TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'Email: ${admin['email']}',
//               style: const TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'Contact: ${admin['contact']}',
//               style: const TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'NIC: ${admin['nic']}',
//               style: const TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 30),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Navigate to the UpdateAdminProfileScreen
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => UpdateAdminProfileScreen(),
//                     ),
//                   );
//                 },
//                 child: const Text('Edit Profile'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
