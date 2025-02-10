import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:homepage_project/pages/reels.dart';
import 'package:homepage_project/pages/games.dart';
import 'package:homepage_project/pages/user/profile.dart';
import 'package:homepage_project/pages/user/wallet.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  _PersonalDetailsState createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  int _selectedIndex = 3;
  bool _isLoggedIn = false;
  String? _userName;
  String? _name;
  String? _email;
  String? _phone;
  String? _gender;
  String? _dob;
  String? _nationality;
  String? _whtsapp;

  @override
  void initState() {
    super.initState();
    _personalDetails_list();
  }

  Future<void> _personalDetails_list() async {
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
        final name = responseData['user']['name'];
        final email = responseData['user']['email'];
        final phone = responseData['user']['phone_number'];
        final dob = responseData['user']['date-of-birth'];
        final gender = responseData['user']['gender'];
        final nationality = responseData['user']['nationality'];
        final whtsapp = responseData['user']['whtsapp'];
        // final available_balance = responseData['user']['available_balance'];

        print("user================================  : $user");
        // print("Email  : $email");
        setState(() {
          _isLoggedIn = token != null;
          _userName = username ?? 'N/A';
          _name = name ?? 'N/A';
          _email = email ?? 'N/A';
          _phone = phone ?? 'N/A';
          _gender = gender ?? 'N/A';
          _dob = dob ?? 'N/A';
          _nationality = nationality ?? 'N/A';
          _whtsapp = whtsapp ?? 'N/A';
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Personal Details', style: TextStyle(color: mainColor)),
        centerTitle: true,
        backgroundColor: secondaryColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ProfilePage()));
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
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/dots-three-vertical.svg',
              color: Colors.white,
              height: 25,
              width: 25,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditDetails(
                    username: _userName ?? 'N/A',
                    fullName:
                        _name ?? 'N/A', // Replace if there's a fullName field
                    email: _email ?? 'N/A',
                    phone: _phone ?? 'N/A',
                    gender: _gender ?? 'N/A',
                    dob: _dob ?? 'N/A',
                    nationality: _nationality ?? 'N/A',
                    whatsapp: _whtsapp ?? 'N/A',
                  ),
                ),
              );
            },
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _infoTile('Username', _userName),
            _infoTile('Name', _name),
            _infoTile('Email Address', _email),
            _infoTile('Phone', _phone),
            // _infoTile('Gender', _gender),
            // _infoTile('Date of Birth', _dob),
            // _infoTile('Nationality', _nationality),
            _infoTile('WhatsApp', _whtsapp),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String title, String? value) {
    return Container(
      color: secondaryColor,
      // elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: const TextStyle(color: Colors.white, fontSize: 16)),
            Text(value ?? 'N/A',
                style: const TextStyle(
                    color: mainColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class EditDetails extends StatefulWidget {
  final String username;
  final String fullName;
  final String email;
  final String phone;
  final String gender;
  final String dob;
  final String nationality;
  final String whatsapp;

  const EditDetails({
    super.key,
    required this.username,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.gender,
    required this.dob,
    required this.nationality,
    required this.whatsapp,
  });

  @override
  _EditDetailsState createState() => _EditDetailsState();
}

class _EditDetailsState extends State<EditDetails> {
  late TextEditingController _usernameController;
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _genderController;
  late TextEditingController _dobController;
  late TextEditingController _nationalityController;
  late TextEditingController _whatsappController;

  String gender = "Male"; // Dropdown value
  String nationality = "American"; // Dropdown value

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.username);
    _fullNameController = TextEditingController(text: widget.fullName);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    _genderController = TextEditingController(text: widget.gender);
    _dobController = TextEditingController(text: widget.dob);
    _nationalityController = TextEditingController(text: widget.nationality);
    _whatsappController = TextEditingController(text: widget.whatsapp);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    _dobController.dispose();
    _nationalityController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  // Options for dropdowns
  final List<String> genderOptions = ['Male', 'Female'];
  final List<String> nationalityOptions = ['American', 'Canadian', 'British'];

  Future<void> _saveDetails() async {
    final token = await _secureStorage.read(key: 'access_token');
    final url =
        Uri.parse('https://api.totomonkey.com/api/auth/updateprofileUsers');

    final Map<String, String> body = {
      "username": _usernameController.text,
      "name": _fullNameController.text,
      "email": _emailController.text,
      "phone": _phoneController.text,
      // "gender": _genderController.text,
      // "nationality": nationality,
      "whtsapp": _whatsappController.text,
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Profile updated successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(),
          ));
      print("Profile updated successfully: ${response.body}");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update profile!"),
          backgroundColor: Colors.red,
        ),
      );
      print("Failed to update profile: ${response.statusCode}");
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Edit Details', style: TextStyle(color: Colors.white)),
        backgroundColor: secondaryColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
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
      ),
      backgroundColor: primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildTextField('Username', _usernameController),
            _buildTextField('Full Name', _fullNameController),
            _buildTextField('Email Address', _emailController),
            _buildTextField('Phone', _phoneController),
            _buildTextField('Whatsapp', _whatsappController),
            // _buildTextField('Date of Birth', _dobController),
            // _buildDropdownField('Gender', gender, genderOptions, (value) {
            //   setState(() {
            //     gender = value!;
            //   });
            // }),
            // _buildDropdownField('Nationality', nationality, nationalityOptions,
            //     (value) {
            //   setState(() {
            //     nationality = value!;
            //   });
            // }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor, // Set the button color
              ),
              child: const Text(
                'Update',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white), // Text color
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white), // Label color
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white), // Border color
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.white), // Border color when enabled
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.white), // Border color when focused
          ),
          filled: true,
          fillColor: secondaryColor, // Background color
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, String selectedValue,
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
        decoration: InputDecoration(
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
        ),
        dropdownColor: secondaryColor, // Background color of the dropdown
      ),
    );
  }
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
