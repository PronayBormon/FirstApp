import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homepage_project/methods/api.dart';
import 'package:homepage_project/pages/HomePage.dart';
import 'package:homepage_project/pages/authentication/signup.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:homepage_project/pages/games.dart';
import 'package:homepage_project/pages/hoster-list.dart';
import 'package:homepage_project/pages/reels.dart';
import 'package:homepage_project/pages/user/profile.dart';
import 'package:homepage_project/pages/user/wallet.dart';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const primaryColor = Color.fromRGBO(35, 38, 38, 1);
const secondaryColor = Color.fromRGBO(41, 45, 46, 1);
const _secureStorage = FlutterSecureStorage();

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  String? _username;
  String? _password;
  bool _obscurePassword = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkTokenAndRedirect();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    List<Widget> pages = [
      const reelsPage(),
      const GamesPage(),
      const WalletPage(),
      const ProfilePage(),
    ];

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => pages[index]),
    );
  }

  // Toggle password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  // Show error messages
  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Check if access token exists and redirect
  void _checkTokenAndRedirect() async {
    final token = await _secureStorage.read(key: 'access_token');
    final userdata = await _secureStorage.read(key: 'userdata');

    print('Token: $token'); // Debug log
    print('UserData: $userdata'); // Debug log

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Homepage()),
      );
    }
  }

  // Handle sign-in logic
  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'username': _username ?? '',
        'password': _password ?? '',
      };

      try {
        // Call the API
        final result = await API().postRequest(route: "/userLogin", data: data);
        final response = jsonDecode(result.body);
        print("API Response: $response"); // Debug log

        final userdata = response['user'];
        final status = response['status'];

        if (status == 200) {
          // Save session details securely
          await _secureStorage.write(
              key: 'userdata', value: jsonEncode(response));
          await _secureStorage.write(
              key: 'access_token', value: response['access_token'] ?? '');
          await _secureStorage.write(
              key: 'username', value: userdata?['username'] ?? '');
          await _secureStorage.write(
              key: 'email', value: userdata?['email'] ?? '');
          await _secureStorage.write(
              key: 'name', value: userdata?['name'] ?? '');

          await _secureStorage.write(
              key: 'id', value: userdata?['id']?.toString() ?? '');

          await _secureStorage.write(
              key: 'available_balance',
              value: userdata?['available_balance']?.toString() ?? '');
          await _secureStorage.write(
              key: 'role_id', value: userdata?['role_id']?.toString() ?? '');
          await _secureStorage.write(
              key: 'phone_number',
              value: userdata?['phone_number']?.toString() ?? '');
          await _secureStorage.write(
              key: 'whtsapp', value: userdata?['whtsapp']?.toString() ?? '');
          await _secureStorage.write(
              key: 'register_bonus',
              value: userdata?['register_bonus']?.toString() ?? '');

          // Redirect to Homepage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(),
            ),
          );
        } else {
          final response = jsonDecode(result.body);
          final Error = response['errors']['account'];
          _showError('$Error' ?? 'Login failed. Please try again.');
        }
      } catch (error) {
        print("Error during login: $error"); // Debug log
        _showError('An error occurred. Please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign In',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 2.0,
        shadowColor: Colors.black,
        backgroundColor: secondaryColor,
        leading: GestureDetector(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 236, 7, 122),
        unselectedItemColor: Colors.white54,
        backgroundColor: Colors.transparent,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle),
            label: 'Reels',
            backgroundColor: secondaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_esports),
            label: 'Games',
            backgroundColor: secondaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Wallet',
            backgroundColor: secondaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: secondaryColor,
          ),
        ],
        onTap: _onItemTapped,
      ),
      backgroundColor: primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
                height: 80,
              ),
              const Text(
                'Welcome back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: secondaryColor,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white70),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  _username = value;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: secondaryColor,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white70),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: _togglePasswordVisibility,
                    color: Colors.white,
                  ),
                ),
                obscureText: _obscurePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 4) {
                    return 'Password must be at least 4 characters';
                  }
                  return null;
                },
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  _password = value;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _signIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              // const Text(
              //   'Or Signin with',
              //   style: TextStyle(color: Colors.white70),
              // ),
              // const SizedBox(height: 10),
              // _buildSocialButtons(),
              // const SizedBox(height: 10.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUp()),
                  );
                },
                child: const Text(
                  "Don't have an account? Register now!",
                  style: TextStyle(
                    color: Colors.white60,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildSocialButtons() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ElevatedButton(
        onPressed: () {
          // Add Google Sign-Up logic
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          minimumSize: const Size(50, 50),
          elevation: 2.0,
          shape: const CircleBorder(), // Makes the button circular
        ),
        child: Image.asset(
          'assets/images/google.png',
          height: 24,
          width: 24,
        ),
      ),
      ElevatedButton(
        onPressed: () {
          // Add Twitter Sign-Up logic
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          minimumSize: const Size(50, 50),
          elevation: 2.0,
          shape: const CircleBorder(),
        ),
        child: Image.asset(
          'assets/images/twitter.png',
          height: 24,
          width: 24,
        ),
      ),
      ElevatedButton(
        onPressed: () {
          // Add Twitter Sign-Up logic
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 0, 118, 214),
          minimumSize: const Size(50, 50),
          elevation: 2.0,
          shape: const CircleBorder(),
        ),
        child: Image.asset(
          'assets/images/facebook.png',
          height: 34,
          width: 34,
        ),
      ),
    ],
  );
}
