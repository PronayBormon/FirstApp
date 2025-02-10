import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homepage_project/methods/appbar.dart';
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
import 'package:http/http.dart' as http;
import 'dart:convert';

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
bool _isLoggedIn = false;

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
  String? _userName;
  String? _email;
  double? _available_balance;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _checkTokenAndRedirect();
    _GetRefferCode();
  }

  // Check if the token exists and update state
  Future<void> _checkLoginStatus() async {
    final token = await _secureStorage.read(key: 'access_token');
    final username = await _secureStorage.read(key: 'username');
    final email = await _secureStorage.read(key: 'email');
    final available_balance =
        await _secureStorage.read(key: 'available_balance');

    setState(() {
      _isLoggedIn = token != null;
      _userName = username;
      _email = email;
      _available_balance =
          available_balance != null ? double.tryParse(available_balance) : null;
    });
  }

  Future<void> _GetRefferCode() async {
    final url =
        Uri.parse('https://api.totomonkey.com/api/user/getRefferalCode');
    final token = await _secureStorage.read(key: 'access_token');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      // body: jsonEncode({'tokens': token}),
    );

    try {
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final user = responseData['user'];
        final username = responseData['user']['username'];
        final email = responseData['user']['email'];
        // final available_balance = responseData['user']['available_balance'];

        // print("user  : $user");
        // print("Email  : $email");
      } else {
        print('Deposit failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _checkTokenAndRedirect() async {
    final token = await _secureStorage.read(key: 'access_token');

    if (token == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignIn()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please Complate Your Login.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
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
    return Scaffold(
      appBar: AppBarWidget(), // Use a comma, not a semicolon
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

            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/Avatar_image.png'),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // _userName ?? "FOX",
                      '${_userName?.toUpperCase() ?? "FOX"}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Email: ${_email ?? "N/A"}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
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
                _gridItem(context, Icons.play_circle_fill, 'Reels',
                    const reelsPage()),
                _gridItem(
                    context, Icons.sports_esports, 'Games', const GamesPage()),
                _gridItem(
                    context, Icons.videocam, 'Hosters', const HosterListPage()),
                // _gridItem(context, Icons.history, 'Transactions',
                //     const Transection()),
                _gridItem(context, Icons.wallet, 'Wallet', const WalletPage()),
                _gridItem(
                    context, Icons.download, 'Deposit', const DepositPage()),
                _gridItem(
                    context, Icons.upload, 'Withdraw', const WithdrawPage()),
              ],
            ),
            const SizedBox(height: 20),

            // Profile Information Section
            const Text('Security ',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

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
                _gridItem(context, Icons.person, 'Personal Details',
                    const PersonalDetails()),
                // _gridItem(context, Icons.lock, '2FA',
                //     const TwoFactorAuthenticationPage()),
                _gridItem(context, Icons.password, 'Change Password',
                    const ChangePasswordPage()),
                // _gridItem(context, Icons.history, 'Login Activity',
                //     const LoginActivityPage()),
                // _gridItem(context, Icons.message, 'Security Questions',
                //     const SecurityQuestionsPage()),
                // _gridItem(context, Icons.privacy_tip, 'Privacy Settings',
                //     const BroadcastSettingsPage()),

                _gridItem(
                    context, Icons.groups, 'Affiliate', const AffiliatePage()),
                // _gridItem(context, Icons.share, 'Share', const SharePage()),
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

            // const Text('Settings',
            //     style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 16,
            //         fontWeight: FontWeight.bold)),

            // const SizedBox(height: 10),
            // // Options Grid for Balance
            // GridView.count(
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   crossAxisCount: 4,
            //   childAspectRatio: 1.5,
            //   crossAxisSpacing: 3,
            //   mainAxisSpacing: 3,
            //   children: [
            //     // _gridItem(context, Icons.share, 'Share', const SharePage()),
            //     _gridItem(
            //         context, Icons.groups, 'Affiliate', const AffiliatePage()),
            //     // _gridItem(context, Icons.notifications, 'Notifications',
            //     //     const NotificationPage()),
            //     // _gridItem(context, Icons.info, 'About', const AboutPage()),
            //     InkWell(
            //       onTap: () => logout(context), // Implemented logout function
            //       child: Container(
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             ShaderMask(
            //               shaderCallback: (Rect bounds) {
            //                 return pinkGradient.createShader(bounds);
            //               },
            //               child: const Icon(Icons.logout,
            //                   size: 25, color: Colors.white),
            //             ),
            //             const SizedBox(height: 5),
            //             const Text('Logout',
            //                 textAlign:
            //                     TextAlign.center, // Align text to the center
            //                 style: TextStyle(
            //                   color: Colors.white,
            //                   fontSize: 12,
            //                 )),
            //           ],
            //         ),
            //       ),
            //     ), // Call logout method
            //   ],
            // ),

            // const SizedBox(height: 10),
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
