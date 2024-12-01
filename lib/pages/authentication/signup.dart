import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homepage_project/pages/authentication/signin.dart';
import '../components/Sidebar.dart';
import 'dart:convert';
import 'package:homepage_project/helper/constant.dart';
import 'package:homepage_project/methods/api.dart';
import 'package:homepage_project/pages/HomePage.dart';

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

  String? _username;
  String? _password;
  String? _retypePassword;
  String? _inviteCode;

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

  // Password roles list with their validation checks
  bool _hasUppercase = false;
  bool _hasDigits = false;
  bool _hasLowercase = false;
  bool _hasSpecialCharacter = false;
  bool _isPasswordLongEnough = false;

  // Function to check password strength and roles
  void _checkPasswordStrength(String password) {
    setState(() {
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasDigits = password.contains(RegExp(r'[0-9]'));
      _hasLowercase = password.contains(RegExp(r'[a-z]'));
      _hasSpecialCharacter =
          password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
      _isPasswordLongEnough = password.length >= 8;
    });
  }

  String? _validatePasswordStrength(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter a password';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Password must contain at least 1 uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Password must contain at least 1 lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Password must contain at least 1 digit';
    }
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return 'Password must contain at least 1 special character';
    }
    return null;
  }

  String? _validateRetypedPassword(String? retypePassword) {
    if (retypePassword == null || retypePassword.isEmpty) {
      return 'Please retype your password';
    }
    if (retypePassword != _password) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _register() async {
    final data = {
      'username': _username ?? '',
      'password': _password ?? '',
      'password_confirmation': _retypePassword ?? '',
      'inviteCode': _inviteCode ?? '',
    };
    // print(data);
    final result = await API().postRequest(route: "/register", data: data);
    final response = jsonDecode(result.body);
    // if (response['status'] == 1) {
    //   // Navigator.of(context).pushReplacement(
    //   //   MaterialPageRoute(
    //   //     builder: (context) => Homepage(),
    //   //   ),
    //   // );
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => const Homepage()),
    //   );
    print(jsonDecode(result.body));
    // }
    // print(jsonDecode(result.body));
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
        backgroundColor: secondaryColor,
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
      ),
      drawer: const OffcanvasMenu(),
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                  height: 80,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Create a new account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: 'Username',
                  onChanged: (value) => _username = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                _buildTextField(
                  label: 'Password',
                  isPassword: true,
                  obscureText: _obscurePassword,
                  toggleVisibility: _togglePasswordVisibility,
                  onChanged: (value) {
                    _password = value;
                    _checkPasswordStrength(value);
                  },
                  validator: _validatePasswordStrength,
                ),

                const SizedBox(height: 20),
                _buildPasswordRequirements(), // Display password requirements

                const SizedBox(height: 16.0),
                _buildTextField(
                  label: 'Retype Password',
                  isPassword: true,
                  obscureText: _obscureRetypePassword,
                  toggleVisibility: _toggleRetypePasswordVisibility,
                  onChanged: (value) => _retypePassword = value,
                  validator: _validateRetypedPassword,
                ),
                const SizedBox(height: 16.0),
                _buildTextField(
                  label: 'Reffer code(Optional)',
                  onChanged: (value) => _inviteCode = value,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'SignUp',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Or Sign Up with',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 10),
                _buildSocialButtons(),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
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

  Widget _buildTextField({
    required String label,
    String? hint,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    bool isPassword = false,
    bool obscureText = false,
    void Function()? toggleVisibility,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.white),
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: primaryColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white,
                ),
                onPressed: toggleVisibility,
              )
            : null,
      ),
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      onChanged: onChanged,
    );
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

  Widget _buildPasswordRequirements() {
    return Padding(
      padding: const EdgeInsets.only(
          left: 0.0), // Optional padding for better spacing
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Ensure left alignment
        children: [
          Text(
            'Password Requirements:',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _isPasswordLongEnough
                  ? '✔️ At least 8 characters'
                  : '❌ At least 8 characters',
              style: TextStyle(
                  color: _isPasswordLongEnough ? Colors.green : Colors.red,
                  fontSize: 12),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _hasUppercase
                  ? '✔️ At least 1 uppercase letter'
                  : '❌ At least 1 uppercase letter',
              style: TextStyle(
                  color: _hasUppercase ? Colors.green : Colors.red,
                  fontSize: 12),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _hasLowercase
                  ? '✔️ At least 1 lowercase letter'
                  : '❌ At least 1 lowercase letter',
              style: TextStyle(
                  color: _hasLowercase ? Colors.green : Colors.red,
                  fontSize: 12),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _hasDigits ? '✔️ At least 1 digit' : '❌ At least 1 digit',
              style: TextStyle(
                  color: _hasDigits ? Colors.green : Colors.red, fontSize: 12),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _hasSpecialCharacter
                  ? '✔️ At least 1 special character'
                  : '❌ At least 1 special character',
              style: TextStyle(
                  color: _hasSpecialCharacter ? Colors.green : Colors.red,
                  fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
