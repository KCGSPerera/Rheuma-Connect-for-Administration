import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rheuma_connect_for_admins/screens/splash_screen.dart';
import 'providers/admin_provider.dart';
import 'providers/intern_provider.dart'; // Import InternProvider
import 'providers/doctor_provider.dart'; // Import DoctorProvider
import 'screens/admin_login_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/update_admin_profile_screen.dart';
import 'screens/intern_register_screen.dart'; // Import Intern Register Screen
import 'screens/view_all_interns_screen.dart'; // Import View All Interns Screen
import 'screens/doctor_register_screen.dart'; // Import Doctor Register Screen
import 'screens/view_all_doctors_screen.dart'; // Import View All Doctors Screen

void main() {
  runApp(AdminApp());
}

class AdminApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AdminProvider()),
        ChangeNotifierProvider(
            create: (_) => InternProvider()), // Add InternProvider
        ChangeNotifierProvider(
            create: (_) => DoctorProvider()), // Add DoctorProvider
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rheumatic Clinic Admin App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
        routes: {
          '/admin-login': (context) => AdminLoginScreen(),
          '/admin-dashboard': (context) => AdminDashboardScreen(),
          '/update-admin-profile': (context) => UpdateAdminProfileScreen(),
          '/register-intern': (context) =>
              InternRegisterScreen(), // Add Intern Register Route
          '/view-all-interns': (context) =>
              ViewAllInternsScreen(), // Add View All Interns Route
          '/register-doctor': (context) =>
              DoctorRegisterScreen(), // Add Doctor Register Route
          '/view-all-doctors': (context) =>
              ViewAllDoctorsScreen(), // Add View All Doctors Route
        },
      ),
    );
  }
}








// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'providers/admin_provider.dart';
// import 'screens/admin_login_screen.dart';
// import 'screens/admin_register_screen.dart';
// import 'screens/admin_dashboard_screen.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AdminProvider()),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Rheuma Connect for Admins',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         home: AdminLoginScreen(),
//         routes: {
//           '/admin-dashboard': (context) => AdminDashboardScreen(),
//           '/admin-login': (context) => AdminLoginScreen(),
//           '/register-admin': (context) => AdminRegisterScreen(),
//         },
//       ),
//     );
//   }
// }
