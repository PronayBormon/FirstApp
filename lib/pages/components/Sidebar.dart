import 'package:flutter/material.dart';
import 'package:homepage_project/pages/categories.dart';
import '../HomePage.dart';
import '../authentication/signin.dart';
import '../authentication/signup.dart';
import '../authentication/profile.dart';
import '../categories.dart';
import '../games.dart';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);

class OffcanvasMenu extends StatelessWidget {
  const OffcanvasMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: Color.fromRGBO(41, 45, 46, 1),

      backgroundColor: Color.fromRGBO(35, 38, 38, 1),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
              padding: const EdgeInsets.only(
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
                        Homepage()), // Example navigation to a "MenuPage"
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
                        GamesPage()), // Example navigation to a "MenuPage"
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
                        AllCats()), // Example navigation to a "MenuPage"
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
                  builder: (context) => SignIn(),
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
                  builder: (context) => SignUp(),
                ), // Example navigation to a "MenuPage"
              );
            },
          ),
        ],
      ),
    );
  }
}
