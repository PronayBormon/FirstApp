import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homepage_project/pages/HomePage.dart';
import 'package:homepage_project/pages/authentication/signin.dart';
import 'package:homepage_project/pages/hoster-list.dart';
import 'package:homepage_project/pages/reels.dart';
import 'package:homepage_project/pages/user/profile.dart';
import 'package:homepage_project/pages/games.dart';
import 'package:homepage_project/pages/user/wallet.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

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

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({super.key});

  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  int _selectedIndex = 2; // Default to Home
  Map<String, String>? selectedPlatform;
  Map<String, String>? selectedCurrency;
  bool? _isLoggedIn = false;
  String? userCurrency;
  int? userBalance;
  List<Map<String, String>> platformList = [];
  List<Map<String, String>> currencyOptions = [];

  @override
  void initState() {
    super.initState();
    _getPlatformList();
    _getCurrencyList();
    _getbalance();
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please Complate Your Login.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    } else {}
  }

  Future<void> _getCurrencyList() async {
    final url = Uri.parse('https://api.totomonkey.com/api/deposit/getCurrency');
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

        List<Map<String, String>> currencies = (responseData['data'] as List)
            .map((item) => {
                  'id': item['id'].toString(),
                  'name': item['name'].toString(),
                })
            .toList();

        setState(() {
          currencyOptions = currencies;
          if (currencyOptions.isNotEmpty) {
            selectedCurrency =
                currencyOptions.first; // Select the first currency by default
          }
        });
      } else {
        print('Failed to fetch currency list: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching currency list: $e');
    }
  }

  Future<void> _getPlatformList() async {
    final url = Uri.parse('https://api.totomonkey.com/api/games/gamePltfmAll');
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

        List<Map<String, String>> platforms = (responseData['data'] as List)
            .map((item) => {
                  'id': item['id'].toString(),
                  'name': item['name'].toString(),
                })
            .toList();

        setState(() {
          platformList = platforms;
          if (platformList.isNotEmpty) {
            selectedPlatform =
                platformList.first; // Select the first platform by default
          }
        });
      } else {
        print('Failed to fetch platform list: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching platform list: $e');
    }
  }

  Future<void> _getbalance() async {
    final url =
        Uri.parse('https://api.totomonkey.com/api/balance/getCurrentBalance');
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
        final Currency = responseData['currency'];
        final balance = responseData['data']['balance'];

        setState(() {
          userCurrency = Currency;
          userBalance = balance;
        });
      } else {
        print('Failed to fetch Balance: ${response.statusCode}');
      }
    } catch (e) {
      print('Could not find Balance: $e');
    }
  }

  // Mock data for demonstration
  double lockedFunds = 0.0; // Example locked funds
  double minWithdrawal = 1.0; // Minimum withdrawal limit
  final TextEditingController amountController = TextEditingController();

  Future<void> _onWithdraw() async {
    final double withdrawAmount = double.tryParse(amountController.text) ?? 0.0;

    if (withdrawAmount >= minWithdrawal && withdrawAmount <= userBalance!) {
      final url = Uri.parse(
          'https://api.totomonkey.com/api/withdrawal/sendWithdrawalRequest');
      final token = await _secureStorage.read(key: 'access_token');

      if (token == null) return;

      final data = {
        "amount": withdrawAmount,
        "gamingPltform": selectedPlatform!['id'], // Use platform ID
        "currency": selectedCurrency!['id'], // Use currency ID
      };

      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(data),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                'Successfully requested withdrawal request Send',
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WalletPage(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Failed to request withdrawal: ${response.statusCode}')),
          );
        }
      } catch (e) {
        print('Error sending withdrawal request: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error requesting withdrawal')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid withdrawal amount')),
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
        title: const Text('Withdraw', style: TextStyle(color: mainColor)),
        centerTitle: true,
        elevation: 2.0,
        shadowColor: Colors.black,
        backgroundColor: const Color.fromRGBO(41, 45, 46, 1),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Enable back function
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
        // actions: [
        //   Builder(
        //     builder: (context) => IconButton(
        //       icon: SvgPicture.asset(
        //         'assets/icons/menu.svg',
        //         color: Colors.white,
        //         height: 25,
        //         width: 25,
        //       ),
        //       onPressed: () {
        //         Scaffold.of(context).openDrawer();
        //       },
        //     ),
        //   ),
        // ],
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
      backgroundColor: const Color.fromRGBO(35, 38, 38, 1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            DropdownButtonFormField<Map<String, String>>(
              value: selectedPlatform, // Default selection
              onChanged: (value) {
                setState(() {
                  selectedPlatform = value;
                });
              },
              items: platformList.map((platform) {
                return DropdownMenuItem<Map<String, String>>(
                  value: platform,
                  child: Text(platform['name']!,
                      style: const TextStyle(color: Colors.white)),
                );
              }).toList(),

              decoration: const InputDecoration(
                labelText: 'Platform List',
                filled: true,
                fillColor: Color.fromRGBO(41, 45, 46, 1),
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              dropdownColor: const Color.fromRGBO(41, 45, 46, 1),
            ),
            const SizedBox(height: 30),
            DropdownButtonFormField<Map<String, String>>(
              value: selectedCurrency,
              onChanged: (value) {
                setState(() {
                  selectedCurrency = value;
                });
              },
              items: currencyOptions.map((currency) {
                return DropdownMenuItem<Map<String, String>>(
                  value: currency,
                  child: Text(currency['name']!,
                      style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Currency List',
                filled: true,
                fillColor: Color.fromRGBO(41, 45, 46, 1),
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              dropdownColor: const Color.fromRGBO(41, 45, 46, 1),
            ),

            const SizedBox(height: 30),
            // Amount Input
            TextFormField(
              controller: amountController,
              style: const TextStyle(color: Colors.white), // Text color
              decoration: const InputDecoration(
                labelText: 'Withdraw Amount',
                filled: true,
                fillColor: Color.fromRGBO(41, 45, 46, 1),
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Text(
              'Min: ${NumberFormat.simpleCurrency(name: userCurrency).format(minWithdrawal)}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),

            // Available and Locked Funds Display
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available: ${NumberFormat.simpleCurrency(name: userCurrency).format(userBalance ?? 0.0)}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                    'Locked Funds: ${NumberFormat.simpleCurrency(name: userCurrency).format(lockedFunds ?? 0.0)}',
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
            const SizedBox(height: 20),

            // Request Withdrawal Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                minimumSize: const Size(double.infinity, 50), // Full width
              ),
              onPressed: () {
                if (selectedCurrency != null &&
                    selectedPlatform != null &&
                    amountController.text.isNotEmpty) {
                  _onWithdraw();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                }
              },
              child: const Text(
                'Request Withdrawal',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
