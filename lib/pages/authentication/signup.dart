import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homepage_project/helper/constant.dart';
import 'package:homepage_project/methods/api.dart';
import 'package:homepage_project/pages/authentication/signin.dart';
import '../components/Sidebar.dart';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const primaryColor = Color.fromRGBO(35, 38, 38, 1);
const secondaryColor = Color.fromRGBO(41, 45, 46, 1);

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _email;
  String? _password;
  String? _retypePassword;
  String? _referralCode;

  bool _obscurePassword = true;
  bool _obscureRetypePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleRetypePasswordVisibility() {
    setState(() {
      _obscureRetypePassword = !_obscureRetypePassword;
    });
  }

  void _register() async {
    final data = {
      'name': _name ?? '',
      'username': _name ?? '',
      'email': _email ?? '',
      'password': _password ?? '',
      'repass': _retypePassword ?? '',
      'Refer_Code': _referralCode ?? '',
    };
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Signup',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 2.0,
        shadowColor: Colors.black,
        backgroundColor:
            const Color.fromRGBO(41, 45, 46, 1), // Custom dark color
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Go back to the previous screen
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
      backgroundColor: primaryColor,
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
                  'Create a new account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle:
                        const TextStyle(color: Colors.white), // Set label color
                    filled: true,
                    fillColor: primaryColor,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.white70), // Set border color
                      borderRadius: BorderRadius.circular(20.0),
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
                  style: const TextStyle(color: Colors.white), // Set text color
                  onChanged: (value) {
                    _name = value;
                  },
                ),
                const SizedBox(height: 16.0),
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
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Retype Password',
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
                        _obscureRetypePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: _toggleRetypePasswordVisibility,
                      color: Colors.white,
                    ),
                  ),
                  obscureText: _obscureRetypePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please retype your password';
                    }
                    if (value != _password) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.white), // Set text color
                  onChanged: (value) {
                    _retypePassword = value;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Refaral Code (Optional)',
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

                  style: const TextStyle(color: Colors.white), // Set text color
                  onChanged: (value) {
                    _referralCode = value;
                  },
                ),
                const SizedBox(height: 20.0),

                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    minimumSize:
                        const Size(double.infinity, 50), // Full width button
                  ),
                  child: Text(
                    'SignUp',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10.0),
                TextButton(
                  onPressed: () {
                    // Navigate to the SignIn screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignIn()),
                    );
                  },
                  child: const Text(
                    'Already have an account? Login',
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
