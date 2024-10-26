import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homepage_project/pages/HomePage.dart';
import 'package:homepage_project/pages/authentication/signup.dart';
import 'package:homepage_project/pages/components/Sidebar.dart';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const primaryColor = Color.fromRGBO(35, 38, 38, 1);
const secondaryColor = Color.fromRGBO(41, 45, 46, 1);

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;

  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      // Perform sign-in logic (API call, etc.)
      // Example: print email and password
      print('Email: $_email');
      print('Password: $_password');
      // Add your API call here
      // Navigate to the SignIn screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Homepage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign In',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 2.0,
        shadowColor: Colors.black,
        backgroundColor: const Color.fromRGBO(41, 45, 46, 1),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'assets/icons/chevron-left.svg',
              color: Colors.white,
              height: 25,
              width: 25,
            ),
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: SvgPicture.asset(
                'assets/icons/menu.svg',
                color: Colors.white,
                height: 25,
                width: 25,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ],
      ),
      drawer: const OffcanvasMenu(),
      backgroundColor: const Color.fromRGBO(35, 38, 38, 1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                  height: 80,
                ), // Logo image
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
                    labelText: 'Email',
                    labelStyle:
                        const TextStyle(color: Colors.white), // Set label color
                    filled: true,
                    fillColor: primaryColor,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.white70), // Set border color
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusColor: Colors.white,
                    hintStyle: const TextStyle(
                        color: Colors.grey), // Placeholder color
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white70), // Focused border color
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white70), // Enabled border color
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.white), // Set text color
                  onChanged: (value) {
                    _email = value;
                  },
                ),
                const SizedBox(height: 16.0),

                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle:
                        const TextStyle(color: Colors.white), // Set label color
                    filled: true,
                    fillColor: primaryColor,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.white70), // Set border color
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusColor: Colors.white,
                    hintStyle: const TextStyle(
                        color: Colors.grey), // Placeholder color
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white70), // Focused border color
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white70), // Enabled border color
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
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.white), // Set text color
                  onChanged: (value) {
                    _password = value;
                  },
                ),
                const SizedBox(height: 16.0),
                const SizedBox(height: 20.0),

                ElevatedButton(
                  onPressed: _signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    minimumSize:
                        const Size(double.infinity, 50), // Full width button
                  ),
                  child: const Text(
                    'Signin',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10.0),
                TextButton(
                  onPressed: () {
                    // Navigate to the SignIn screen
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
      ),
    );
  }
}
