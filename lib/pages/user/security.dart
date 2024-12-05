import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homepage_project/pages/HomePage.dart';
import 'package:homepage_project/pages/user/security/change-password.dart';
import 'package:homepage_project/pages/user/security/login-activitiy.dart';
import 'package:homepage_project/pages/user/security/privacy-setings.dart';
import 'package:homepage_project/pages/user/security/security-question.dart';
import 'package:homepage_project/pages/user/security/twofactor.dart';
import 'package:homepage_project/pages/user/wallet.dart';
import 'package:homepage_project/pages/hoster-list.dart';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const primaryColor = Color.fromRGBO(35, 38, 38, 1);
const secondaryColor = Color.fromRGBO(41, 45, 46, 1);
const pinkGradient = LinearGradient(
  colors: [
    Color.fromRGBO(228, 62, 229, 1),
    Color.fromRGBO(229, 15, 112, 1),
  ],
);

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  _SecurityPageState createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation logic
    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Homepage()));
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const WalletPage()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HosterListPage()));
        break;
      case 3:
        // Stay on the security page
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Security Settings', style: TextStyle(color: mainColor)),
        centerTitle: true,
        backgroundColor: secondaryColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset('assets/icons/chevron-left.svg',
                color: Colors.white, height: 25, width: 25),
          ),
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(0.0), topRight: Radius.circular(0.0)),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: mainColor,
          unselectedItemColor: Colors.black54,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Wallet'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Hosters'),
            BottomNavigationBarItem(
                icon: Icon(Icons.security), label: 'Security'),
          ],
          onTap: _onItemTapped,
        ),
      ),
      backgroundColor: primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _securityOptionTile('Two-Factor Authentication', Icons.lock, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const TwoFactorAuthenticationPage()));
            }),
            _securityOptionTile('Change Password', Icons.password, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChangePasswordPage()));
            }),
            _securityOptionTile('Login Activity', Icons.history, () {
              // Navigate to Login Activity History page
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginActivityPage()));
            }),
            _securityOptionTile('Security Questions', Icons.question_answer,
                () {
              // Navigate to Security Questions setup page
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SecurityQuestionsPage()));
            }),
            _securityOptionTile('Privacy Settings', Icons.privacy_tip, () {
              // Navigate to Privacy Settings page
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BroadcastSettingsPage()));
            }),
          ],
        ),
      ),
    );
  }

  Widget _securityOptionTile(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: secondaryColor,
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              // Using Shader to create a gradient effect for the icon
              ShaderMask(
                shaderCallback: (bounds) => pinkGradient.createShader(bounds),
                child: Icon(icon, color: Colors.white), // Icon must be white
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const Icon(Icons.arrow_forward, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
