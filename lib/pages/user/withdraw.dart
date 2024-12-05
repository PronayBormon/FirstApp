import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homepage_project/pages/HomePage.dart';
import 'package:homepage_project/pages/components/Sidebar.dart';
import 'package:homepage_project/pages/hoster-list.dart';
import 'package:homepage_project/pages/user/profile.dart';
import 'package:homepage_project/pages/games.dart';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({super.key});

  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  int _selectedIndex = 1; // Default to Home
  String? selectedCurrency;
  String? selectedNetwork;
  String? selectedMethod;
  final List<String> currencyOptions = [
    'Bitcoin',
    'Ethereum',
    'Litecoin',
    'BDT',
    'USD',
  ];
  final List<String> networkOptions = ['ERC20', 'TRC20'];
  final List<String> methodOptions = [
    'Bank Account',
    'Card',
    'Crypto',
    'Stripe',
    'PayPal'
  ];

  // Mock data for demonstration
  double availableAmount = 1000.0; // Example balance
  double lockedFunds = 0.0; // Example locked funds
  double minWithdrawal = 20.0; // Minimum withdrawal limit

  final TextEditingController amountController = TextEditingController();
  final TextEditingController bankBranchController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cryptoAddressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void _onWithdraw() {
    final double withdrawAmount = double.tryParse(amountController.text) ?? 0.0;
    if (withdrawAmount >= minWithdrawal && withdrawAmount <= availableAmount) {
      // Handle the withdrawal logic based on the selected method
      print('Requesting withdrawal of \$$withdrawAmount via $selectedMethod');
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Successfully requested withdrawal of \$$withdrawAmount')),
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid withdrawal amount')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });

    // Handle navigation logic
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Homepage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GamesPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HosterListPage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
        break;
      case 4:
        break;
    }
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
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: SvgPicture.asset(
                'assets/icons/menu.svg',
                color: Colors.white,
                height: 25,
                width: 25,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ],
      ),
      drawer: const OffcanvasMenu(),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(0.0),
          topRight: Radius.circular(0.0),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: mainColor,
          unselectedItemColor: Colors.black54,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_esports),
              label: 'Games',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.play_circle),
              label: 'Model',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          onTap: _onItemTapped,
        ),
      ),
      backgroundColor: const Color.fromRGBO(35, 38, 38, 1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Withdraw Currency',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedCurrency,
              onChanged: (value) {
                setState(() {
                  selectedCurrency = value;
                  selectedNetwork = null; // Reset network when currency changes
                });
              },
              items: currencyOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child:
                      Text(value, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color.fromRGBO(41, 45, 46, 1),
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
            const SizedBox(height: 20),

            const Text(
              'Withdraw Method',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedMethod,
              onChanged: (value) {
                setState(() {
                  selectedMethod = value;
                });
              },
              items: methodOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child:
                      Text(value, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color.fromRGBO(41, 45, 46, 1),
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
            const SizedBox(height: 20),

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
            Text('Min: \$$minWithdrawal',
                style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 20),

            // Conditional Fields Based on Method
            if (selectedMethod == 'Bank Account') ...[
              TextFormField(
                controller: bankBranchController,
                style: const TextStyle(color: Colors.white), // Text color
                decoration: const InputDecoration(
                  labelText: 'Bank Branch',
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
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: accountNumberController,
                style: const TextStyle(color: Colors.white), // Text color
                decoration: const InputDecoration(
                  labelText: 'Account Number',
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
              ),
            ] else if (selectedMethod == 'Card') ...[
              TextFormField(
                controller: cardNumberController,
                style: const TextStyle(color: Colors.white), // Text color
                decoration: const InputDecoration(
                  labelText: 'Card Number',
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
              ),
              // Additional card details (expiry, CVV) can be added here
            ] else if (selectedMethod == 'Crypto') ...[
              DropdownButtonFormField<String>(
                value: selectedNetwork,
                onChanged: (value) {
                  setState(() {
                    selectedNetwork = value;
                  });
                },
                items: networkOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color.fromRGBO(41, 45, 46, 1),
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
              const SizedBox(height: 10),
              TextFormField(
                controller: cryptoAddressController,
                decoration: const InputDecoration(
                  labelText: 'Crypto Address',
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
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: accountNumberController,
                decoration: const InputDecoration(
                  labelText: 'Account Number (for Crypto)',
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
              ),
            ] else if (selectedMethod == 'Stripe' ||
                selectedMethod == 'PayPal') ...[
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
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
              ),
            ],

            // Available and Locked Funds Display
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Available: \$$availableAmount',
                    style: const TextStyle(color: Colors.white)),
                Text('Locked Funds: \$$lockedFunds',
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
                    selectedMethod != null &&
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
