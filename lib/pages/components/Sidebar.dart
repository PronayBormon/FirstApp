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

class OffcanvasMenu extends StatelessWidget {
  const OffcanvasMenu({super.key});

  // Clear session data for logout
  Future<void> logout(BuildContext context) async {
    // Clear session data from secure storage
    await _secureStorage.delete(key: 'access_token');
    await _secureStorage.delete(key: 'username');
    await _secureStorage.delete(key: 'email');
    await _secureStorage.delete(key: 'name');

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
      child: ListView(
        padding: EdgeInsets.zero,
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
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
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
          ListTile(
            title: const Text(
              'Logout',
              style: TextStyle(color: mainColor),
            ),
            textColor: Colors.white,
            onTap: () => logout(context), // Implemented logout function
          ),
        ],
      ),
    );
  }
}
