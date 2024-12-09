import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:homepage_project/pages/categories.dart';
import '../HomePage.dart';
import '../authentication/signin.dart';
import '../authentication/signup.dart';
import '../user/profile.dart';
import '../games.dart';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const _secureStorage = FlutterSecureStorage();

class OffcanvasMenu extends StatefulWidget {
  const OffcanvasMenu({super.key});

  @override
  State<OffcanvasMenu> createState() => _OffcanvasMenuState();
}

class _OffcanvasMenuState extends State<OffcanvasMenu> {
  late Future<bool> _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = _checkLoginStatus();
  }

  // Check if the token exists
  Future<bool> _checkLoginStatus() async {
    final token = await _secureStorage.read(key: 'access_token');
    return token != null; // Returns true if token exists
  }

  // Clear session data for logout
  Future<void> logout(BuildContext context) async {
    // Clear session data from secure storage
    await _secureStorage.deleteAll();

    // After logging out, navigate to the SignIn page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignIn()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromRGBO(35, 38, 38, 1),
      child: FutureBuilder<bool>(
        future: _isLoggedIn,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while checking login status
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final isLoggedIn = snapshot.data ?? false;

          return ListView(
            // padding: EdgeInsets.zero,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  top: 30.0,
                  left: 15.0,
                  right: 15.0,
                  bottom: 10.0,
                ),
              ),
              ListTile(
                title: const Text(
                  'Home',
                  style: TextStyle(
                    height: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                textColor: Colors.white,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Homepage()),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Games',
                  style: TextStyle(
                    height: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                textColor: Colors.white,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GamesPage()),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Categories',
                  style: TextStyle(
                    height: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                textColor: Colors.white,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AllCats()),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Profile',
                  style: TextStyle(
                    height: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                textColor: Colors.white,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()),
                  );
                },
              ),
              if (!isLoggedIn) ...[
                // Show Sign In and Sign Up only if not logged in
                ListTile(
                  title: const Text('Sign In'),
                  textColor: Colors.white,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignIn()),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Sign Up'),
                  textColor: Colors.white,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUp()),
                    );
                  },
                ),
              ],
              if (isLoggedIn)
                ListTile(
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: mainColor),
                  ),
                  textColor: Colors.white,
                  onTap: () => logout(context), // Implemented logout function
                ),
            ],
          );
        },
      ),
    );
  }
}
