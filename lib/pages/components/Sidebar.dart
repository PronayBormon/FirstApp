import 'package:flutter/material.dart';
import 'package:homepage_project/pages/categories.dart';
import '../HomePage.dart';
import '../authentication/signin.dart';
import '../authentication/signup.dart';
import '../user/profile.dart';

// import '../games.dart';
import '../games.dart';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);

class OffcanvasMenu extends StatelessWidget {
  const OffcanvasMenu({
    super.key,
  });

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
          )),
          ListTile(
            title: const Text(
              'Home',
              style: TextStyle(height: 1, fontWeight: FontWeight.w600),
            ),
            textColor: Colors.white,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const Homepage()), // Example navigation to a "MenuPage"
              );
            },
          ),
          ListTile(
            title: const Text(
              'Games',
              style: TextStyle(height: 1, fontWeight: FontWeight.w600),
            ),
            textColor: Colors.white,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const GamesPage()), // Example navigation to a "MenuPage"
              );
            },
          ),
          ListTile(
            title: const Text(
              'Categories',
              style: TextStyle(height: 1, fontWeight: FontWeight.w600),
            ),
            textColor: Colors.white,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const AllCats()), // Example navigation to a "MenuPage"
              );
            },
          ),
          ListTile(
            title: const Text(
              'Profile',
              style: TextStyle(height: 1, fontWeight: FontWeight.w600),
            ),
            textColor: Colors.white,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProfilePage()), // Example navigation to a "MenuPage"
              );
            },
          ),
          ListTile(
            title: const Text('Signin'),
            textColor: Colors.white,
            onTap: () {
              // Handle Item 2 tap
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignIn(),
                ), // Example navigation to a "MenuPage"
              );
            },
          ),
          ListTile(
            title: const Text('Signup'),
            textColor: Colors.white,
            onTap: () {
              // Handle Item 2 tap
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignUp(),
                ), // Example navigation to a "MenuPage"
              );
            },
          ),
        ],
      ),
    );
  }
}
