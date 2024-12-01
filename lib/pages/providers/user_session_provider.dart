import 'package:flutter/material.dart';

class UserSessionProvider extends ChangeNotifier {
  String? _token;
  String? _username;
  String? _email;
  String? _name;

  String? get token => _token;
  String? get username => _username;
  String? get email => _email;
  String? get name => _name;

  // Method to set user session details
  void setUserSession({
    required String token,
    required String username,
    required String email,
    required String name,
  }) {
    _token = token;
    _username = username;
    _email = email;
    _name = name;
    notifyListeners(); // Notify listeners of session changes
  }

  // Method to clear session
  void clearSession() {
    _token = null;
    _username = null;
    _email = null;
    _name = null;
    notifyListeners(); // Notify listeners of session changes
  }
}
