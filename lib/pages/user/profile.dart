import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homepage_project/pages/HomePage.dart';
import 'package:homepage_project/pages/authentication/signin.dart';
import 'package:homepage_project/pages/games.dart';
import 'package:homepage_project/pages/hoster-list.dart';
import 'package:homepage_project/pages/reels.dart';
import 'package:homepage_project/pages/user/about.dart';
import 'package:homepage_project/pages/user/affiliate.dart';
import 'package:homepage_project/pages/user/deposit.dart';
import 'package:homepage_project/pages/user/notification.dart';
import 'package:homepage_project/pages/user/personal-details.dart';
import 'package:homepage_project/pages/user/security.dart';
import 'package:homepage_project/pages/user/security/change-password.dart';
import 'package:homepage_project/pages/user/security/login-activitiy.dart';
import 'package:homepage_project/pages/user/security/privacy-setings.dart';
import 'package:homepage_project/pages/user/security/security-question.dart';
import 'package:homepage_project/pages/user/security/twofactor.dart';
import 'package:homepage_project/pages/user/share.dart';
import 'package:homepage_project/pages/user/transections.dart';
import 'package:homepage_project/pages/user/wallet.dart';
import 'package:homepage_project/pages/user/withdraw.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const primaryColor = Color.fromRGBO(35, 38, 38, 1);
const secondaryColor = Color.fromRGBO(41, 45, 46, 1);
const pinkGradient = LinearGradient(
  colors: [
    Color.fromRGBO(228, 62, 229, 1),
    Color.fromRGBO(229, 15, 112, 1),
  ],
);
const _secureStorage = FlutterSecureStorage();

Future<void> logout(BuildContext context) async {
  // Clear session data from secure storage
  await _secureStorage.deleteAll();

  // After logging out, navigate to the SignIn page
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const SignIn()),
  );
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3;

  bool _isLoggedIn = false; // Simple boolean state

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _checkTokenAndRedirect();
  }

  // Check if the token exists and update state
  Future<void> _checkLoginStatus() async {
    final token = await _secureStorage.read(key: 'access_token');
    setState(() {
      _isLoggedIn = token != null;
    });
  }

  void _checkTokenAndRedirect() async {
    final token = await _secureStorage.read(key: 'access_token');

    if (token == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignIn()),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    const String userId = "123456"; // Example user ID
    const String userName = "Fox"; // Example user name

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: secondaryColor,
        toolbarHeight: 80,
        leading: Padding(
          padding: const EdgeInsets.only(left: 0), // Adjust padding for logo
          child: Container(
            margin: EdgeInsets.only(left: 15),
            child: Image.asset(
              'assets/images/logo-Old.png', // Replace with your logo path
              // fit: BoxFit.contain,
              // height: 200, // Larger logo size
              // width: 80,
            ),
          ),
        ),
        actions: [
          _isLoggedIn
              ? Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Balance:",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            "\$00.00",
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProfilePage()),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/Avatar_image.png'),
                            radius: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: GestureDetector(
                            onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignIn(),
                                  ))
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        ],
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture and User Info
            const Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/Avatar_image.png'),
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'User ID: $userId',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Buttons for Withdraw and Deposit
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _actionButton(context, 'Withdraw', const WithdrawPage()),
                const SizedBox(width: 15),
                _actionButton(context, 'Deposit', const DepositPage()),
              ],
            ),
            const SizedBox(height: 20),
            // Profile Information Section
            const Text('Profile Information',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            // Options Grid for Profile Information
            // GridView.count(
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   crossAxisCount: 4,
            //   childAspectRatio: 1,
            //   crossAxisSpacing: 3,
            //   mainAxisSpacing: 3,
            //   children: const [],
            // ),
            const SizedBox(height: 10),
            // Options Grid for Balance
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              childAspectRatio: 1,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
              children: [
                _gridItem(context, Icons.person, 'Personal Details',
                    const PersonalDetails()),
                _gridItem(context, Icons.account_balance_wallet, 'Wallet',
                    const WalletPage()),
                _gridItem(
                    context, Icons.download, 'Deposit', const DepositPage()),
                _gridItem(
                    context, Icons.upload, 'Withdraw', const WithdrawPage()),
                _gridItem(context, Icons.star, 'Bonus', const reelsPage()),
                _gridItem(context, Icons.history, 'Transactions',
                    const Transection()),
              ],
            ),

            // Profile Information Section
            const Text('Security',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            // Options Grid for Profile Information
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              childAspectRatio: 1,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
              children: const [],
            ),
            const SizedBox(height: 10),
            // Options Grid for Balance
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              childAspectRatio: 1.2,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
              children: [
                _gridItem(context, Icons.lock, '2FA',
                    const TwoFactorAuthenticationPage()),
                _gridItem(context, Icons.password, 'Change Password',
                    const ChangePasswordPage()),
                _gridItem(context, Icons.history, 'Login Activity',
                    const LoginActivityPage()),
                _gridItem(context, Icons.message, 'Security Questions',
                    const SecurityQuestionsPage()),
                _gridItem(context, Icons.privacy_tip, 'Privacy Settings',
                    const BroadcastSettingsPage()),
              ],
            ),

            const SizedBox(height: 10),
            // Options Grid for Balance
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              childAspectRatio: 1.5,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
              children: [
                _gridItem(context, Icons.share, 'Share', const SharePage()),
                _gridItem(
                    context, Icons.groups, 'Affiliate', const AffiliatePage()),
                _gridItem(context, Icons.notifications, 'Notifications',
                    const NotificationPage()),
                _gridItem(context, Icons.info, 'About', const AboutPage()),
                InkWell(
                  onTap: () => logout(context), // Implemented logout function
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return pinkGradient.createShader(bounds);
                          },
                          child: const Icon(Icons.logout,
                              size: 25, color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        const Text('Logout',
                            textAlign:
                                TextAlign.center, // Align text to the center
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            )),
                      ],
                    ),
                  ),
                ), // Call logout method
              ],
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(BuildContext context, String title, Widget page) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          gradient: pinkGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => page));
          },
          child: Text(title, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _gridItem(
      BuildContext context, IconData icon, String title, Widget page) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return pinkGradient.createShader(bounds);
              },
              child: Icon(icon, size: 25, color: Colors.white),
            ),
            const SizedBox(height: 5),
            Text(title,
                textAlign: TextAlign.center, // Align text to the center
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                )),
          ],
        ),
      ),
    );
  }

  Widget _listTile(
      BuildContext context, IconData icon, String title, Widget page) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5.0),
      child: Material(
        elevation: 0, // Removed elevation to avoid shadow
        color: secondaryColor,
        borderRadius: BorderRadius.circular(5.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => page));
          },
          child: ListTile(
            leading: ShaderMask(
              shaderCallback: (Rect bounds) {
                return pinkGradient.createShader(bounds);
              },
              child: Icon(icon, color: Colors.white),
            ),
            title: Text(title, style: const TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
