import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homepage_project/methods/appbar.dart';
import 'package:homepage_project/pages/HomePage.dart';
import 'package:homepage_project/pages/authentication/signin.dart';
import 'package:homepage_project/pages/games.dart';
import 'package:homepage_project/pages/hoster-list.dart';
import 'package:homepage_project/pages/reels.dart';
import 'package:homepage_project/pages/user/affiliate.dart';
import 'package:homepage_project/pages/user/deposit.dart';
import 'package:homepage_project/pages/user/personal-details.dart';
import 'package:homepage_project/pages/user/profile.dart';
import 'package:homepage_project/pages/user/transections.dart';
import 'package:homepage_project/pages/user/withdraw.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const primaryColor = Color.fromRGBO(35, 38, 38, 1);
const secondaryColor = Color.fromRGBO(41, 45, 46, 1);
const pinkGradient = LinearGradient(
  colors: [Color.fromRGBO(228, 62, 229, 1), Color.fromRGBO(229, 15, 112, 1)],
);

String depositPolicy =
    "Encrypt private keys, enforce 2FA for transactions, and verify deposits with blockchain confirmations. Store funds securely in cold wallets, while monitoring for suspicious activity. Additionally, notify users of deposits and allow them to whitelist trusted addresses. Make sure users are educated on secure wallet practices to protect their assets.";

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final int _selectedIndex = 2; // Default to Profile
  final _secureStorage = FlutterSecureStorage();
  bool _isLoggedIn = false; // Simple boolean state

  String? _userName;
  String? _email;
  double? _balance;

  @override
  void initState() {
    super.initState();
    _getWalletBalance();
    _checkLoginStatus();
    _checkTokenAndRedirect();
  }

  Future<void> _getWalletBalance() async {
    final url =
        Uri.parse('https://api.totomonkey.com/api/balance/getCurrentBalance');
    final token = await _secureStorage.read(key: 'access_token');

    if (token == null) {
      print("Token is not available");
      return; // If the token is not available, exit early
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response
        final responseData = jsonDecode(response.body);
        // Assuming the balance is under 'data' -> 'balance'
        final balance = responseData['data']['balance'];

        // Ensure balance is a double, whether it's an int or already a double
        double availableBalance =
            (balance is int) ? balance.toDouble() : balance;

        setState(() {
          _balance = availableBalance;
          print('Current Balance: $_balance');
        });
      } else {
        print('Failed to fetch balance: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching balance: $e');
    }
  }

  // Check if the token exists and update state
  Future<void> _checkLoginStatus() async {
    final token = await _secureStorage.read(key: 'access_token');
    final username = await _secureStorage.read(key: 'username');
    final email = await _secureStorage.read(key: 'email');
    // final available_balance =
    //     await _secureStorage.read(key: 'available_balance');

    setState(() {
      _isLoggedIn = token != null;
      _userName = username;
      _email = email;
      // _balance =
      //     available_balance != null ? double.tryParse(available_balance) : null;
    });
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: secondaryColor,
        toolbarHeight: 80,
        leading: Padding(
          padding: const EdgeInsets.only(left: 0), // Adjust padding for logo
          child: Container(
            margin: EdgeInsets.only(left: 15),
            child: Image.asset(
              'assets/images/logo-Old.png',
              height: 60, width: 60,
              fit: BoxFit.contain, // Replace with your logo path
            ),
          ),
        ),
        actions: [
          _isLoggedIn
              ? Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Column(
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
                          // Text("$_availableBalance"),

                          // Showing the balance dynamically
                          Text(
                            "\$${_balance?.toStringAsFixed(2) ?? '00.00'}",
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
            const Text('Current Balance',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("\$${_balance?.toStringAsFixed(2) ?? '00.00'}",
                style: const TextStyle(
                    color: Colors.green,
                    fontSize: 32,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            // Action Buttons for Deposit and Withdraw
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     _actionButton(context, 'Deposit', const DepositPage()),
            //     const SizedBox(width: 15),
            //     _actionButton(context, 'Withdraw', const WithdrawPage()),
            //   ],
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
                // _gridItem(context, Icons.person, 'Personal Details',
                //     const PersonalDetails()),
                // _gridItem(context, Icons.account_balance_wallet, 'Wallet',
                //     const WalletPage()),
                _gridItem(
                    context, Icons.upload, 'Deposit', const DepositPage()),
                _gridItem(
                    context, Icons.download, 'Withdraw', const WithdrawPage()),
                _gridItem(
                    context, Icons.videocam, 'Hosters', const HosterListPage()),
                _gridItem(
                    context, Icons.sports_esports, 'Games', const GamesPage()),

                _gridItem(
                    context, Icons.groups, 'Affiliate', const AffiliatePage()),
              ],
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.all(15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/refer.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(
                depositPolicy,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            )
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
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                )),
          ],
        ),
      ),
    );
  }
}
