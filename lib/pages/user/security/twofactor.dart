import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homepage_project/pages/HomePage.dart';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const primaryColor = Color.fromRGBO(35, 38, 38, 1);
const secondaryColor = Color.fromRGBO(41, 45, 46, 1);

class TwoFactorAuthenticationPage extends StatefulWidget {
  const TwoFactorAuthenticationPage({super.key});

  @override
  _TwoFactorAuthenticationPageState createState() =>
      _TwoFactorAuthenticationPageState();
}

class _TwoFactorAuthenticationPageState
    extends State<TwoFactorAuthenticationPage> {
  bool _is2FAEnabled = false;
  String _selectedMethod = "SMS"; // Default method
  final List<String> _methods = ["SMS", "Authenticator App"];

  void _toggle2FA(bool? value) {
    setState(() {
      _is2FAEnabled = value ?? false;
    });
  }

  void _saveSettings() {
    // Implement saving logic here
    print("2FA Enabled: $_is2FAEnabled, Method: $_selectedMethod");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Two-Factor Authentication',
            style: TextStyle(color: mainColor)),
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
      backgroundColor: primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            SwitchListTile(
              title: const Text('Enable Two-Factor Authentication',
                  style: TextStyle(color: Colors.white)),
              value: _is2FAEnabled,
              onChanged: _toggle2FA,
              activeColor: mainColor,
              activeTrackColor: Colors.white38,
              inactiveTrackColor: Colors.grey,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _is2FAEnabled ? _selectedMethod : null,
              onChanged: _is2FAEnabled
                  ? (value) {
                      setState(() {
                        _selectedMethod = value!;
                      });
                    }
                  : null,
              items: _methods.map((String method) {
                return DropdownMenuItem<String>(
                  value: method,
                  child:
                      Text(method, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Select 2FA Method',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: secondaryColor,
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
              dropdownColor: secondaryColor,
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                gradient: pinkGradient,
                borderRadius:
                    BorderRadius.circular(50), // Optional: for rounded corners
              ),
              child: ElevatedButton(
                onPressed: _is2FAEnabled ? _saveSettings : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.transparent, // Set background to transparent
                  elevation: 0, // Remove elevation to avoid shadow
                  padding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 30), // Adjust padding as needed
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
