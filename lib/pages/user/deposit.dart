import 'package:flutter/material.dart';
import 'package:homepage_project/pages/HomePage.dart';
import 'package:homepage_project/pages/components/Sidebar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:homepage_project/pages/games.dart';
import 'package:homepage_project/pages/hoster-list.dart';
import 'package:homepage_project/pages/user/profile.dart';

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
  String? _email;
  String? _bankName;
  String? _branch;
  String? _accountNumber;
  String? _mobileNumber;
  String? _amount;
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    List<Widget> pages = [
      const Homepage(),
      const GamesPage(),
      const HosterListPage(),
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
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        // actions: [
        //   IconButton(
        //     icon: SvgPicture.asset('assets/icons/menu.svg',
        //         color: Colors.white, height: 25, width: 25),
        //     onPressed: () {
        //       _scaffoldKey.currentState
        //           ?.openDrawer(); // Use GlobalKey to open the drawer
        //     },
        //   ),
        // ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Crypto'),
            Tab(text: 'Fiat'),
          ],
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.white, width: 3.0),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(0.0),
          topRight: Radius.circular(0.0),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: mainColor,
          unselectedItemColor: Colors.white54,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: secondaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_esports),
              label: 'Games',
              backgroundColor: secondaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.play_circle),
              label: 'Model',
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
      ),
      backgroundColor: const Color.fromRGBO(35, 38, 38, 1),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCryptoDeposit(),
          _buildFiatDeposit(),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdownField('Currency', selectedCurrency, currencyOptions,
                (value) {
              setState(() {
                selectedCurrency = value;
              });
            }),
            const SizedBox(height: 16),
            TextFormField(
              decoration: _inputDecoration('Wallet Address'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your wallet address';
                }
                return null;
              },
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
                'Wallet Network', selectedNetwork, networkOptions, (value) {
              setState(() {
                selectedNetwork = value;
              });
            }),
            const SizedBox(height: 16),
            TextFormField(
              decoration: _inputDecoration('Amount'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the amount';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _amount = value;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_cryptoFormKey.currentState!.validate()) {
                  // Handle crypto deposit action
                  print('Submitting Crypto Deposit:');
                  print('Currency: $selectedCurrency');
                  print('Wallet Address: $_amount'); // Adjust this as needed
                  print('Network: $selectedNetwork');
                  print('Amount: $_amount');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor, // Set the button color
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

  Widget _buildFiatDeposit() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _fiatFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: _inputDecoration('Amount'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the amount';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _amount = value;
              },
            ),
            const SizedBox(height: 16),
            _buildDropdownField('Method', selectedMethod, methodOptions,
                (value) {
              setState(() {
                selectedMethod = value;
              });
            }),
            if (selectedMethod == 'Bank') ...[
              const SizedBox(height: 16),
              _buildTextField('Bank Name', (value) {
                _bankName = value;
              }),
              const SizedBox(height: 16),
              _buildTextField('Branch', (value) {
                _branch = value;
              }),
              const SizedBox(height: 16),
              _buildTextField('Account Number', (value) {
                _accountNumber = value;
              }),
            ] else if (selectedMethod != 'Mobile Banking') ...[
              const SizedBox(height: 16),
              _buildTextField('Email', (value) {
                _email = value;
              }, isEmail: true),
            ] else ...[
              const SizedBox(height: 16),
              _buildTextField('Mobile Number', (value) {
                _mobileNumber = value;
              }),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_fiatFormKey.currentState!.validate()) {
                  // Handle fiat deposit action
                  print('Submitting Fiat Deposit:');
                  // print('Method: $selectedMethod');
                  // print('Amount: $_amount');
                  // print('Email: $_email');
                  // print('Bank Name: $_bankName');
                  // print('Branch: $_branch');
                  // print('Account Number: $_accountNumber');
                  // print('Mobile Number: $_mobileNumber');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor, // Set the button color
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
