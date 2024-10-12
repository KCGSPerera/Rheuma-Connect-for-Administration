import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/doctor.dart';
import '../services/api_service.dart';

class DoctorProvider with ChangeNotifier {
  Doctor? _doctor; // Logged in doctor
  Doctor? _viewedDoctor; // Doctor viewed by ID
  List<Doctor> _doctors = []; // List of all doctors
  final ApiService _apiService = ApiService();

  Doctor? get doctor => _doctor; // Getter for logged-in doctor
  Doctor? get viewedDoctor => _viewedDoctor; // Getter for viewed doctor
  List<Doctor> get doctors => _doctors; // Getter for the doctors list
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // =======================
  // DOCTOR LOGIN
  // =======================
  Future<String> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.loginDoctor(email, password);

      final doctorId = response['_id'];
      final token = response['token'];

      if (doctorId == null || token == null) {
        throw Exception('Invalid login response: Missing doctorId or token');
      }

      // Store the logged-in doctor data
      _doctor = Doctor.fromJson(response);

      // Store the token locally
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);

      notifyListeners();
      return doctorId;
    } catch (error) {
      print("Login error: $error");
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =======================
  // REGISTER DOCTOR
  // =======================
  Future<void> registerDoctor(String username, String email, String password,
      String name, String contact, String nic) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.registerDoctor(
          username, email, password, name, contact, nic);

      if (response['token'] != null) {
        _doctor = Doctor.fromJson(response);
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
  // FETCH DOCTOR PROFILE
  // =======================
  Future<void> fetchDoctor(String doctorId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _doctor = await _apiService.getDoctorById(doctorId);
      notifyListeners();
    } catch (error) {
      print('Failed to fetch doctor details: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =======================
  // FETCH ALL DOCTORS
  // =======================
  Future<void> fetchAllDoctors() async {
    _isLoading = true;
    notifyListeners();

    try {
      _doctors = await _apiService.getAllDoctors();
      notifyListeners();
    } catch (error) {
      print('Failed to fetch all doctors: $error');
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =======================
  // UPDATE DOCTOR PROFILE
  // =======================
  Future<void> updateDoctorProfile(String doctorId, String email,
      String username, String name, String contact, String nic) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.updateDoctorProfile(
          doctorId, email, username, name, contact, nic);

      if (response.statusCode == 200) {
        // Update local data with updated doctor details
        await fetchDoctor(doctorId);
      } else {
        throw Exception('Failed to update doctor profile');
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
  // DELETE DOCTOR
  // =======================
  Future<void> deleteDoctor(String doctorId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _apiService.deleteDoctor(doctorId);
      _doctors.removeWhere((doctor) => doctor.id == doctorId); // Remove locally
      notifyListeners();
    } catch (error) {
      print('Error deleting doctor: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =======================
  // CLEAR VIEWED DOCTOR DATA
  // =======================
  void clearViewedDoctor() {
    _viewedDoctor = null;
    notifyListeners();
  }

  // =======================
  // FETCH DOCTOR IN LIST BY ID (for viewing another doctor)
  // =======================
  Future<void> fetchDoctorInList(String doctorId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _viewedDoctor = await _apiService.getDoctorById(doctorId);
      notifyListeners();
    } catch (error) {
      print('Failed to fetch doctor in list: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
