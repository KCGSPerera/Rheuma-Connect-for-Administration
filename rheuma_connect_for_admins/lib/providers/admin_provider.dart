import 'package:flutter/material.dart';
// import 'package:rheuma_connect_for_admins/screens/view_admin_profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/admin.dart';
import '../services/api_service.dart';

class AdminProvider with ChangeNotifier {
  Admin? _admin;
  Admin? _viewedAdmin; // Admin viewed by ID
  List<Admin> _admins = [];
  final ApiService _apiService = ApiService();

  Admin? get admin => _admin;
  Admin? get viewedAdmin => _viewedAdmin; // Getter for viewed admin
  List<Admin> get admins => _admins; // Getter for the admins list
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // =======================
  // ADMIN LOGIN
  // =======================
  Future<String> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.loginAdmin(email, password);

      // Extract the necessary fields from the response
      final adminId = response['_id'];
      final token = response['token'];

      if (adminId == null || token == null) {
        throw Exception('Invalid login response: Missing adminId or token');
      }

      // Store the logged-in admin data
      _admin = Admin.fromJson(response);

      print("This is the error ");
      print(_admin);

      // Optionally, store the token locally
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token); // Save token locally

      notifyListeners();
      return adminId;
    } catch (error) {
      print("Login error: $error");
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =======================
  // REGISTER ADMIN
  // =======================
  Future<void> registerAdmin(String username, String email, String password,
      String name, String contact, String nic) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.registerAdmin(
          username, email, password, name, contact, nic);

      if (response['token'] != null) {
        print('Registration successful');
        // Optionally: store the registered admin data
        _admin = Admin.fromJson(response);
      } else {
        throw Exception('Registration failed');
      }

      notifyListeners();
    } catch (error) {
      print("Registration error: $error");
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =======================
  // FETCH ADMIN PROFILE
  // =======================
  Future<void> fetchAdmin(String adminId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _admin = await _apiService.getAdminById(adminId);
      notifyListeners();
    } catch (error) {
      print('Failed to fetch admin details: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =======================
  // Fetch All Admins
  // =======================
  Future<void> fetchAllAdmins() async {
    _isLoading = true;
    notifyListeners();

    try {
      _admins = await _apiService.getAllAdmins();
      notifyListeners();
    } catch (error) {
      print('Failed to fetch all admins: $error');
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =======================
  // UPDATE ADMIN PROFILE
  // =======================
  Future<void> updateAdminProfile(String adminId, String email, String username,
      String name, String contact, String nic) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.updateAdminProfile(
          adminId, email, username, name, contact, nic);

      if (response.statusCode == 200) {
        // Update local data with updated admin details
        await fetchAdmin(adminId);
      } else {
        throw Exception('Failed to update admin profile');
      }

      notifyListeners();
    } catch (error) {
      print('Error updating profile: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

// =======================
  // DELETE ADMIN
  // =======================
  Future<void> deleteAdmin(String adminId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _apiService.deleteAdmin(adminId);
      _admins.removeWhere(
          (admin) => admin.id == adminId); // Remove admin from local list
      notifyListeners();
    } catch (error) {
      print('Error deleting admin: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =======================
  // LOGOUT ADMIN
  // =======================
  Future<void> logoutAdmin(BuildContext context) async {
    try {
      // Clear the saved token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');

      // Clear the admin data locally
      _admin = null;
      notifyListeners();

      // Redirect to the login page
      Navigator.of(context).pushReplacementNamed('/admin-login');
    } catch (error) {
      print('Error logging out: $error');
    }
  }

  // =======================
  // CLEAR ADMIN DATA
  // =======================
  void clearViewedAdmin() {
    _viewedAdmin = null;
    notifyListeners();
  }

  // =======================
  // FETCH ADMIN IN LIST BY ID (for viewing another admin)
  // =======================
  Future<void> fetchAdminInList(String adminId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _viewedAdmin = await _apiService.getAdminById(adminId);
      notifyListeners();
    } catch (error) {
      print('Failed to fetch admin in list: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =======================
  // UPDATE VIEWED ADMIN PROFILE
  // =======================
  Future<void> updateAdminInList(String adminId, String email, String username,
      String name, String contact, String nic) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.updateAdminProfile(
          adminId, email, username, name, contact, nic);

      if (response.statusCode == 200) {
        await fetchAdminInList(
            adminId); // Fetch updated details for viewed admin
      } else {
        throw Exception('Failed to update admin profile');
      }

      notifyListeners();
    } catch (error) {
      print('Error updating viewed admin profile: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
