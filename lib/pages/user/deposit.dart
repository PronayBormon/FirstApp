import 'package:flutter/material.dart';
import 'package:homepage_project/pages/HomePage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:homepage_project/pages/authentication/signin.dart';
import 'package:homepage_project/pages/games.dart';
import 'package:homepage_project/pages/hoster-list.dart';
import 'package:homepage_project/pages/reels.dart';
import 'package:homepage_project/pages/user/deposit-address.dart';
import 'package:homepage_project/pages/user/profile.dart';
import 'package:homepage_project/pages/user/wallet.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const primaryColor = Color.fromRGBO(35, 38, 38, 1);
const secondaryColor = Color.fromRGBO(41, 45, 46, 1);

class DepositPage extends StatefulWidget {
  const DepositPage({super.key});

  @override
  _DepositPageState createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _scaffoldKey = GlobalKey<ScaffoldState>(); // GlobalKey for Scaffold
  final _cryptoFormKey = GlobalKey<FormState>();
  final _fiatFormKey = GlobalKey<FormState>();

  String? selectedCurrencyId; // Changed to a String to hold currency ID
  String? selectedNetwork;
  String? selectedMethod;

  String? _amount;
  int _selectedIndex = 1;

  final _secureStorage = FlutterSecureStorage();
  bool _isLoggedIn = false; // Simple boolean state
  String? _walletAddress;
  String? _merchantId;

  Map<String, String>? selectedPlatform; // It holds the selected platform's map
  List<Map<String, String>> platformList = [];
  List<Map<String, String>> currencyOptions = [];

  int _countdown = 600;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _checkLoginStatus();
    _checkTokenAndRedirect();
    _checkSession();
    _getPlatformList();
    _getCurrencyList();
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
            selectedCurrencyId =
                currencyOptions.first['id']; // Select the first currency ID
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

  /// Check if session data exists
  Future<void> _checkSession() async {
    final storedAddress = await _secureStorage.read(key: 'wallet_address');
    final storedTime = await _secureStorage.read(key: 'countdown_end_time');

    if (storedAddress != null && storedTime != null) {
      final endTime = int.parse(storedTime);
      final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      if (endTime > currentTime) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DepositAddress(
                      deposit: "0",
                    )));
      }
    }
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
          content: Text('Please Complete Your Login.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _sendDepositRequest() async {
    final url =
        Uri.parse('https://api.totomonkey.com/api/deposit/sendDepositRequest');
    final token = await _secureStorage.read(key: 'access_token');

    print(
        "========= $selectedPlatform ============= $_amount ++++++++++++++ $selectedCurrencyId");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "gamingPltform": selectedPlatform!['id'], // Use platform ID
          'amount': _amount,
          'currency': selectedCurrencyId,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DepositAddress(
              deposit: "${response.body}",
            ),
          ),
        );
      } else {
        print('Deposit failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
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
      key: _scaffoldKey, // Assign the GlobalKey here
      appBar: AppBar(
        title: const Text('Deposit', style: TextStyle(color: mainColor)),
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
      backgroundColor: const Color.fromRGBO(35, 38, 38, 1),
      body: Column(
        children: [
          _buildCryptoDeposit(),
        ],
      ),
    );
  }

  Widget _buildCryptoDeposit() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _cryptoFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            DropdownButtonFormField<Map<String, String>>(
              value: selectedPlatform,
              onChanged: (value) {
                setState(() {
                  selectedPlatform = value;
                });
              },
              items: platformList.map((platform) {
                return DropdownMenuItem<Map<String, String>>(
                  value: platform,
                  child: Text(platform['name']!),
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
              ),
            ),
            const SizedBox(height: 30),
            DropdownButtonFormField<String>(
              value: selectedCurrencyId,
              onChanged: (value) {
                setState(() {
                  selectedCurrencyId = value;
                });
              },
              items: currencyOptions.map((currency) {
                return DropdownMenuItem<String>(
                  value: currency['id'],
                  child: Text(currency['name']!),
                );
              }).toList(),
              decoration: _inputDecoration('Currency List'),
            ),
            TextFormField(
              decoration: _inputDecoration('Amount'),
              style: const TextStyle(color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the amount';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _amount = value;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_cryptoFormKey.currentState!.validate()) {
                  _sendDepositRequest();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Deposit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      filled: true,
      fillColor: secondaryColor,
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    );
  }
}
