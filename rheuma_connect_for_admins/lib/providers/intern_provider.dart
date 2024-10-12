import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/intern.dart';
import '../services/api_service.dart';

class InternProvider with ChangeNotifier {
  Intern? _intern; // Logged in intern
  Intern? _viewedIntern; // Intern viewed by ID
  List<Intern> _interns = []; // List of all interns
  final ApiService _apiService = ApiService();

  Intern? get intern => _intern; // Getter for logged-in intern
  Intern? get viewedIntern => _viewedIntern; // Getter for viewed intern
  List<Intern> get interns => _interns; // Getter for the interns list
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // =======================
  // INTERN LOGIN
  // =======================
  Future<String> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.loginIntern(email, password);

      final internId = response['_id'];
      final token = response['token'];

      if (internId == null || token == null) {
        throw Exception('Invalid login response: Missing internId or token');
      }

      // Store the logged-in intern data
      _intern = Intern.fromJson(response);

      // Store the token locally
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);

      notifyListeners();
      return internId;
    } catch (error) {
      print("Login error: $error");
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =======================
  // REGISTER INTERN
  // =======================
  Future<void> registerIntern(String username, String email, String password,
      String name, String contact, String nic) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.registerIntern(
          username, email, password, name, contact, nic);

      if (response['token'] != null) {
        _intern = Intern.fromJson(response);
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
  // FETCH INTERN PROFILE
  // =======================
  Future<void> fetchIntern(String internId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _intern = await _apiService.getInternById(internId);
      notifyListeners();
    } catch (error) {
      print('Failed to fetch intern details: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =======================
  // FETCH ALL INTERNS
  // =======================
  Future<void> fetchAllInterns() async {
    _isLoading = true;
    notifyListeners();

    try {
      _interns = await _apiService.getAllInterns();
      notifyListeners();
    } catch (error) {
      print('Failed to fetch all interns: $error');
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =======================
  // UPDATE INTERN PROFILE
  // =======================
  Future<void> updateInternProfile(String internId, String email,
      String username, String name, String contact, String nic) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.updateInternProfile(
          internId, email, username, name, contact, nic);

      if (response.statusCode == 200) {
        // Update local data with updated intern details
        await fetchIntern(internId);
      } else {
        throw Exception('Failed to update intern profile');
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
  // DELETE INTERN
  // =======================
  Future<void> deleteIntern(String internId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _apiService.deleteIntern(internId);
      _interns.removeWhere((intern) => intern.id == internId); // Remove locally
      notifyListeners();
    } catch (error) {
      print('Error deleting intern: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =======================
  // CLEAR VIEWED INTERN DATA
  // =======================
  void clearViewedIntern() {
    _viewedIntern = null;
    notifyListeners();
  }

  // =======================
  // FETCH INTERN IN LIST BY ID (for viewing another intern)
  // =======================
  Future<void> fetchInternInList(String internId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _viewedIntern = await _apiService.getInternById(internId);
      notifyListeners();
    } catch (error) {
      print('Failed to fetch intern in list: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
