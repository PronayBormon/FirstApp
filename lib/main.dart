import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:homepage_project/pages/authentication/signin.dart';
import 'package:homepage_project/pages/reels.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _secureStorage = const FlutterSecureStorage();
  bool _isLoggedIn = false;
  Timer? _logoutTimer;
  static const int sessionTimeout = 50 * 60; // 50 minutes in seconds

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _startSessionTimer();
  }

  // Check if the token exists and update state
  Future<void> _checkLoginStatus() async {
    final token = await _secureStorage.read(key: 'access_token');
    setState(() {
      _isLoggedIn = token != null;
    });
  }

  // Start a session timer that logs out the user after inactivity
  void _startSessionTimer() {
    _logoutTimer?.cancel(); // Cancel existing timer if any
    _logoutTimer = Timer(Duration(seconds: sessionTimeout), _logoutUser);
  }

  // Reset the session timer on user activity
  void _resetSessionTimer() {
    _startSessionTimer();
  }

  // Logout the user and clear session
  Future<void> _logoutUser() async {
    await _secureStorage.delete(key: 'access_token'); // Clear stored token
    setState(() {
      _isLoggedIn = false;
    });
    // Navigate to the login screen
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignIn()),
      );
    }
  }

  @override
  void dispose() {
    _logoutTimer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _resetSessionTimer, // Reset timer on any user tap
      onPanDown: (_) => _resetSessionTimer(), // Also reset on scroll
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: reelsPage(),
        title: 'FansGames',
      ),
    );
  }
}
