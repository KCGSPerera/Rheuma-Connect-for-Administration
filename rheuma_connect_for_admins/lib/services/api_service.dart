import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rheuma_connect_for_admins/models/doctor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/admin.dart';
import '../models/intern.dart';

class ApiService {
  final String baseUrl =
      'https://rheuma-bakend-git-main-hansanis-projects.vercel.app/api'; // Replace with your backend's IP address

  // =======================
  // ADMIN FUNCTIONS
  // =======================

  // Register a new admin
  Future<Map<String, dynamic>> registerAdmin(String username, String email,
      String password, String name, String contact, String nic) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admins/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'name': name,
        'contact': contact,
        'nic': nic,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', data['token']); // Save the token locally
      return data; // Return the entire response body
    } else {
      throw Exception('Failed to register admin: ${response.statusCode}');
    }
  }

  // Login admin
  Future<Map<String, dynamic>> loginAdmin(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admins/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    print(
        'Login response: ${response.body}'); // Add this line to see the response

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Check for null values in the expected response fields
      if (data['token'] == null || data['_id'] == null) {
        throw Exception('Missing token or ID in the login response');
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', data['token']); // Save token locally
      return data; // Return the entire response body
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }

  // View a specific admin by ID
  Future<Admin> getAdminById(String adminId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/admins/$adminId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return Admin.fromJson(jsonDecode(response.body)['admin']);
    } else {
      throw Exception('Failed to load admin details: ${response.statusCode}');
    }
  }

// fetch all admins
  Future<List<Admin>> getAllAdmins() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/admins/all'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> adminsJson = jsonDecode(response.body);
      return adminsJson.map((json) => Admin.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch all admins: ${response.statusCode}');
    }
  }

  // Update an admin profile by ID
  Future<http.Response> updateAdminProfile(String adminId, String email,
      String username, String name, String contact, String nic) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.put(
      Uri.parse('$baseUrl/admins/$adminId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'username': username,
        'email': email,
        'name': name,
        'contact': contact,
        'nic': nic,
      }),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to update admin profile: ${response.statusCode}');
    }
  }

// Delete an admin by ID
  Future<void> deleteAdmin(String adminId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('$baseUrl/admins/$adminId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete admin');
    }
  }

  // Logout an admin
  Future<void> logoutAdmin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Remove the stored token
    bool result = await prefs.remove('token');

    if (result) {
      print("Token removed successfully. User logged out.");
    } else {
      throw Exception("Failed to remove token.");
    }
  }

  // =======================
  // INTERN FUNCTIONS
  // =======================

  // Register a new intern
  Future<Map<String, dynamic>> registerIntern(String username, String email,
      String password, String name, String contact, String nic) async {
    final response = await http.post(
      Uri.parse('$baseUrl/interns/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'name': name,
        'contact': contact,
        'nic': nic,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', data['token']); // Save token locally
      return data; // Return the response body
    } else {
      throw Exception('Failed to register intern: ${response.statusCode}');
    }
  }

  // Login intern
  Future<Map<String, dynamic>> loginIntern(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/interns/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', data['token']); // Save token locally
      return data; // Return the response body
    } else {
      throw Exception('Failed to login intern: ${response.statusCode}');
    }
  }

  // View a specific intern by ID
  Future<Intern> getInternById(String internId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/interns/$internId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return Intern.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load intern details: ${response.statusCode}');
    }
  }

  // Fetch all interns
  Future<List<Intern>> getAllInterns() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/interns'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> internsJson = jsonDecode(response.body);
      return internsJson.map((json) => Intern.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch all interns: ${response.statusCode}');
    }
  }

  // Update intern profile by ID
  Future<http.Response> updateInternProfile(String internId, String email,
      String username, String name, String contact, String nic) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.put(
      Uri.parse('$baseUrl/interns/$internId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'username': username,
        'email': email,
        'name': name,
        'contact': contact,
        'nic': nic,
      }),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception(
          'Failed to update intern profile: ${response.statusCode}');
    }
  }

  // Delete intern by ID
  Future<void> deleteIntern(String internId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('$baseUrl/interns/$internId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete intern');
    }
  }

// =======================
  // DOCTOR FUNCTIONS
  // =======================

  // Register a new doctor
  Future<Map<String, dynamic>> registerDoctor(String username, String email,
      String password, String name, String contact, String nic) async {
    final response = await http.post(
      Uri.parse('$baseUrl/doctors/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'name': name,
        'contact': contact,
        'nic': nic,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', data['token']); // Save token locally
      return data; // Return the response body
    } else {
      throw Exception('Failed to register doctor: ${response.statusCode}');
    }
  }

  // Login doctor
  Future<Map<String, dynamic>> loginDoctor(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/doctors/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', data['token']); // Save token locally
      return data; // Return the response body
    } else {
      throw Exception('Failed to login doctor: ${response.statusCode}');
    }
  }

  // View a specific doctor by ID
  Future<Doctor> getDoctorById(String doctorId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/doctors/$doctorId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return Doctor.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load doctor details: ${response.statusCode}');
    }
  }

  // Fetch all doctors
  Future<List<Doctor>> getAllDoctors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/doctors'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> doctorsJson = jsonDecode(response.body);
      return doctorsJson.map((json) => Doctor.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch all doctors: ${response.statusCode}');
    }
  }

  // Update doctor profile by ID
  Future<http.Response> updateDoctorProfile(String doctorId, String email,
      String username, String name, String contact, String nic) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.put(
      Uri.parse('$baseUrl/doctors/$doctorId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'username': username,
        'email': email,
        'name': name,
        'contact': contact,
        'nic': nic,
      }),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception(
          'Failed to update doctor profile: ${response.statusCode}');
    }
  }

  // Delete doctor by ID
  Future<void> deleteDoctor(String doctorId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('$baseUrl/doctors/$doctorId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete doctor');
    }
  }
}
