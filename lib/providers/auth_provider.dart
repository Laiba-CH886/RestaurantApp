// lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _userId;
  String? _token;

  // Getter for user ID
  String? get userId => _userId;

  // Getter for token (used for authentication)
  String? get token => _token;

  // Sign In
  Future<void> signIn(String email, String password) async {
    // Assume we have a backend API to authenticate the user
    // For now, we mock the authentication process
    _userId = "user123";  // Mock user ID
    _token = "some_valid_token";  // Mock token

    // Save token to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', _userId!);
    prefs.setString('token', _token!);

    notifyListeners();
  }

  // Sign Up
  Future<void> signUp(String email, String password) async {
    // Assume the API call is successful, so we mock user creation
    _userId = "user123";  // Mock user ID
    _token = "some_valid_token";  // Mock token

    // Save token to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', _userId!);
    prefs.setString('token', _token!);

    notifyListeners();
  }

  // Log Out
  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
    prefs.remove('token');

    _userId = null;
    _token = null;
    notifyListeners();
  }

  // Check if the user is authenticated
  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userId');
    _token = prefs.getString('token');

    return _token != null;
  }
}
