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

  String? selectedCurrency;
  String? selectedNetwork;
  String? selectedMethod;
  // String? _email;
  // String? _bankName;
  // String? _branch;
  // String? _accountNumber;
  // String? _mobileNumber;
  String? _amount;
  int _selectedIndex = 1;

  final _secureStorage = FlutterSecureStorage();
  bool _isLoggedIn = false; // Simple boolean state
  String? _walletAddress;
  String? _merchantId;
  int _countdown = 600;

  // @override
  // void initState() {
  //   super.initState();
  // }

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
                  )),
        );
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
          content: Text('Please Complate Your Login.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    } else {}
  }

  Future<void> _sendDepositRequest() async {
    final url =
        Uri.parse('https://api.totomonkey.com/api/deposit/sendDepositRequest');
    final token = await _secureStorage.read(key: 'access_token');

    try {
      // print(token);
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Add Authorization header
        },
        body: jsonEncode({'amount': _amount}),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => DepositAddress(
                    deposit: "${response.body}",
                  )),
        );
        // print('Deposit successful: ${response.body}');
      } else {
        print('Deposit failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
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

  final List<String> currencyOptions = ['Bitcoin', 'Ethereum', 'Litecoin'];
  final List<String> networkOptions = ['ERC20', 'TRC20'];
  final List<String> methodOptions = [
    'Bank',
    'PayPal',
    'Stripe',
    'Payoneer',
    'Mobile Banking'
  ];

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
        // controller: _tabController,
        children: [
          _buildCryptoDeposit(),
          // _buildFiatDeposit(),
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
            TextFormField(
              decoration: _inputDecoration('Amount'),
              style: const TextStyle(color: Colors.white), // Input text color
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
                // print(_amount);
                if (_cryptoFormKey.currentState!.validate()) {
                  _sendDepositRequest();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Set the button color
                minimumSize: const Size(double.infinity, 50), // Full width
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

  // Widget _buildFiatDeposit() {
  //   return Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: Form(
  //       key: _fiatFormKey,
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           TextFormField(
  //             decoration: _inputDecoration('Amount'),
  //             validator: (value) {
  //               if (value == null || value.isEmpty) {
  //                 return 'Please enter the amount';
  //               }
  //               return null;
  //             },
  //             keyboardType: TextInputType.number,
  //             onChanged: (value) {
  //               _amount = value;
  //             },
  //           ),
  //           const SizedBox(height: 16),
  //           _buildDropdownField('Method', selectedMethod, methodOptions,
  //               (value) {
  //             setState(() {
  //               selectedMethod = value;
  //             });
  //           }),
  //           if (selectedMethod == 'Bank') ...[
  //             const SizedBox(height: 16),
  //             _buildTextField('Bank Name', (value) {
  //               _bankName = value;
  //             }),
  //             const SizedBox(height: 16),
  //             _buildTextField('Branch', (value) {
  //               _branch = value;
  //             }),
  //             const SizedBox(height: 16),
  //             _buildTextField('Account Number', (value) {
  //               _accountNumber = value;
  //             }),
  //           ] else if (selectedMethod != 'Mobile Banking') ...[
  //             const SizedBox(height: 16),
  //             _buildTextField('Email', (value) {
  //               _email = value;
  //             }, isEmail: true),
  //           ] else ...[
  //             const SizedBox(height: 16),
  //             _buildTextField('Mobile Number', (value) {
  //               _mobileNumber = value;
  //             }),
  //           ],
  //           const SizedBox(height: 16),
  //           ElevatedButton(
  //             onPressed: () {
  //               if (_fiatFormKey.currentState!.validate()) {
  //                 // Handle fiat deposit action
  //                 print('Submitting Fiat Deposit:');
  //                 // print('Method: $selectedMethod');
  //                 // print('Amount: $_amount');
  //                 // print('Email: $_email');
  //                 // print('Bank Name: $_bankName');
  //                 // print('Branch: $_branch');
  //                 // print('Account Number: $_accountNumber');
  //                 // print('Mobile Number: $_mobileNumber');
  //               }
  //             },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: mainColor, // Set the button color
  //               minimumSize: const Size(double.infinity, 50), // Full width
  //             ),
  //             child: const Text(
  //               'Deposit',
  //               style: TextStyle(color: Colors.white),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildDropdownField(String label, String? selectedValue,
      List<String> options, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        onChanged: onChanged,
        items: options.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: const TextStyle(color: Colors.white)),
          );
        }).toList(),
        decoration: _inputDecoration(label),
        dropdownColor: secondaryColor,
      ),
    );
  }

  Widget _buildTextField(String label, ValueChanged<String?> onChanged,
      {bool isEmail = false}) {
    return TextFormField(
      decoration: _inputDecoration(label),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
      onChanged: onChanged,
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
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    );
  }
}
