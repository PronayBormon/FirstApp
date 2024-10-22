import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const primaryColor = Color.fromRGBO(35, 38, 38, 1);
const secondaryColor = Color.fromRGBO(41, 45, 46, 1);

class BroadcastSettingsPage extends StatefulWidget {
  const BroadcastSettingsPage({super.key});

  @override
  _BroadcastSettingsPageState createState() => _BroadcastSettingsPageState();
}

class _BroadcastSettingsPageState extends State<BroadcastSettingsPage> {
  // Boolean settings
  bool _listMyCam = true;
  bool _showCountryFlag = true;
  bool _passwordRequired = false;
  bool _allowPrivateShows = true;
  bool _allowPrivateShowRecordings = true;
  bool _showSatisfactionScore = true;

  // Strings for user input
  String _rules = '';
  String _blockedCountries = 'Afghanistan, Africa, USA, UK, UAE';
  String _blockedRegions =
      'Region 1, Region 2, Region 3, Region 4, Region 5, Region 6';
  String _privateShowTokensPerMinute = '0';
  String _privateShowMinimumMinutes = '0';
  String _spyOnPrivateShowTokensPerMinute = 'Yes';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Broadcast Settings',
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
            _buildSwitchTile('List My Cam on the Home Page', _listMyCam,
                (value) {
              setState(() {
                _listMyCam = value;
              });
            }),
            _buildSwitchTile('Show My Country Flag on the Home Page Thumbnail',
                _showCountryFlag, (value) {
              setState(() {
                _showCountryFlag = value;
              });
            }),
            _buildSwitchTile('Password Required for Others to View Your Cam',
                _passwordRequired, (value) {
              setState(() {
                _passwordRequired = value;
              });
            }),
            _buildTextField('Rules for Your Room', (value) {
              setState(() {
                _rules = value;
              });
            }),
            _buildTextField('Block Access to Users in These Countries',
                (value) {
              setState(() {
                _blockedCountries = value;
              });
            }),
            _buildTextField('Block Access to Users in These Regions', (value) {
              setState(() {
                _blockedRegions = value;
              });
            }),
            _buildSwitchTile('Appear on Network Sites', !_listMyCam, (value) {
              setState(() {
                _listMyCam = !value; // Reverse logic for visibility
              });
            }),
            _buildSwitchTile(
                'Show My Satisfaction Score', _showSatisfactionScore, (value) {
              setState(() {
                _showSatisfactionScore = value;
              });
            }),
            const Divider(color: Colors.white),
            const Text('Private Show Settings',
                style: TextStyle(color: Colors.white, fontSize: 20)),
            _buildSwitchTile('Allow Private Shows', _allowPrivateShows,
                (value) {
              setState(() {
                _allowPrivateShows = value;
              });
            }),
            _buildSwitchTile(
                'Allow Private Show Recordings', _allowPrivateShowRecordings,
                (value) {
              setState(() {
                _allowPrivateShowRecordings = value;
              });
            }),
            _buildTextField('Private Show Tokens Per Minute', (value) {
              setState(() {
                _privateShowTokensPerMinute = value;
              });
            }),
            _buildTextField('Private Show Minimum Minutes', (value) {
              setState(() {
                _privateShowMinimumMinutes = value;
              });
            }),
            _buildSwitchTile('Spy on Private Show Tokens Per Minute',
                _spyOnPrivateShowTokensPerMinute == 'Yes', (value) {
              setState(() {
                _spyOnPrivateShowTokensPerMinute = value ? 'Yes' : 'No';
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
      String title, bool value, ValueChanged<bool> onChanged) {
    return Card(
      color: secondaryColor,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: mainColor,
        ),
      ),
    );
  }

  Widget _buildTextField(String label, ValueChanged<String> onChanged) {
    return Card(
      color: secondaryColor,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: TextField(
          onChanged: onChanged,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.white),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            filled: true,
            fillColor: secondaryColor,
          ),
        ),
      ),
    );
  }
}
