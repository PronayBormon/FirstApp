import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homepage_project/pages/games.dart';
import 'package:homepage_project/pages/reels.dart';
import 'package:homepage_project/pages/user/profile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:homepage_project/pages/user/wallet.dart';
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

class AffiliatePage extends StatefulWidget {
  const AffiliatePage({super.key});

  @override
  _AffiliatePageState createState() => _AffiliatePageState();
}

class _AffiliatePageState extends State<AffiliatePage> {
  final int _selectedIndex = 3;
  bool _isLoggedIn = false;
  String? _userName;
  String? _email;
  double? _availableBalance;
  String _referralCode = "";

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _checkTokenAndRedirect();
    _getReferralCode();
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

  Future<void> _getReferralCode() async {
    final url =
        Uri.parse('https://api.totomonkey.com/api/user/getRefferalCode');
    final token = await _secureStorage.read(key: 'access_token');

    if (token == null) return;

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        print(responseData);

        setState(() {
          _userName = responseData['user']['username'];
          _email = responseData['user']['email'];
          _referralCode = responseData['user']['inviteCode'] ?? "";
        });
      } else {
        print('Failed to fetch referral code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching referral code: $e');
    }
  }

  Future<void> _checkLoginStatus() async {
    final token = await _secureStorage.read(key: 'access_token');
    final username = await _secureStorage.read(key: 'username');
    final email = await _secureStorage.read(key: 'email');
    final availableBalance =
        await _secureStorage.read(key: 'available_balance');

    setState(() {
      _isLoggedIn = token != null;
      _userName = username;
      _email = email;
      _availableBalance =
          availableBalance != null ? double.tryParse(availableBalance) : null;
    });
  }

  void _checkTokenAndRedirect() async {
    final token = await _secureStorage.read(key: 'access_token');

    if (token == null) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double myAffiliateAmount = 150.0;
    String affiliateLink =
        "https://www.totomonkey.com/invide-code/$_referralCode";

    List<Map<String, dynamic>> affiliateUsers = [
      // {'name': 'User A', 'amount': 50.0, 'Reg_date': '2024-10-12'},
      // {'name': 'User B', 'amount': 75.0, 'Reg_date': '2024-10-12'},
      // {'name': 'User C', 'amount': 100.0, 'Reg_date': '2024-10-12'},
      // {'name': 'User D', 'amount': 120.0, 'Reg_date': '2024-10-12'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Affiliate', style: TextStyle(color: mainColor)),
        centerTitle: true,
        backgroundColor: secondaryColor,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset('assets/icons/chevron-left.svg',
                color: Colors.white, height: 25, width: 25),
          ),
        ),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/refferal-transformed-removebg-preview.png',
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: Card(
                  color: secondaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(45.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // const Text('Your Affiliate Earnings',
                        //     style:
                        //         TextStyle(color: Colors.white, fontSize: 18)),
                        // const SizedBox(height: 10),
                        // Text('${myAffiliateAmount.toStringAsFixed(2)} Tokens',
                        //     style: const TextStyle(
                        //         color: mainColor,
                        //         fontSize: 24,
                        //         fontWeight: FontWeight.bold)),
                        // const SizedBox(height: 30),
                        const Text('Your Affiliate Link:',
                            style: TextStyle(color: Colors.white)),
                        const SizedBox(height: 5),
                        Text(affiliateLink,
                            style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            _copyToClipboard(context, affiliateLink);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: mainColor),
                          child: const Text('Copy Link',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Padding(
            //   padding: const EdgeInsets.all(15),
            //   child: Container(
            //     alignment: Alignment.centerLeft,
            //     child: const Text('Affiliate Users',
            //         style: TextStyle(color: Colors.white, fontSize: 20)),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: List.generate(affiliateUsers.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(affiliateUsers[index]['name'],
                          style: const TextStyle(color: Colors.white)),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${affiliateUsers[index]['amount']} Tokens',
                              style: const TextStyle(color: Colors.grey)),
                          Text('Reg: ${affiliateUsers[index]['Reg_date']}',
                              style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/bonusBannar.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String link) {
    Clipboard.setData(ClipboardData(text: link)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Link copied to clipboard!',
                style: TextStyle(color: Colors.white))),
      );
    });
  }
}
