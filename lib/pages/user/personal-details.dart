import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homepage_project/pages/HomePage.dart';
import 'package:homepage_project/pages/components/Sidebar.dart';
import 'package:homepage_project/pages/hoster-list.dart';
import 'package:homepage_project/pages/user/wallet.dart';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const primaryColor = Color.fromRGBO(35, 38, 38, 1);
const secondaryColor = Color.fromRGBO(41, 45, 46, 1);
const pinkGradient = LinearGradient(
  colors: [Color.fromRGBO(228, 62, 229, 1), Color.fromRGBO(229, 15, 112, 1)],
);

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  _PersonalDetailsState createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  int _selectedIndex = 3;

  // Sample user data
  final String userId = "123456";
  final String username = "johndoe";
  final String fullName = "John Doe";
  final String email = "johndoe@example.com";
  final String phone = "+1 234 567 890";
  final String gender = "Male";
  final String dob = "1990-01-01";
  final String nationality = "American";

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation logic
    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Homepage()));
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const WalletPage()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HosterListPage()));
        break;
      case 3:
        // Stay on the profile page
        break;
    }
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
                    username: username,
                    fullName: fullName,
                    email: email,
                    phone: phone,
                    gender: gender,
                    dob: dob,
                    nationality: nationality,
                  ),
                ),
              );
            },
          ),
        ],
      ),
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
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.sports_esports), label: 'Games'),
            BottomNavigationBarItem(
                icon: Icon(Icons.play_circle), label: 'Model'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          onTap: _onItemTapped,
        ),
      ),
      backgroundColor: primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _infoTile('Username', username),
            _infoTile('Full Name', fullName),
            _infoTile('Email Address', email),
            _infoTile('Phone', phone),
            _infoTile('Gender', gender),
            _infoTile('Date of Birth', dob),
            _infoTile('Nationality', nationality),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Card(
      color: secondaryColor,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: const TextStyle(color: Colors.white, fontSize: 16)),
            Text(value,
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

  const EditDetails({
    super.key,
    required this.username,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.gender,
    required this.dob,
    required this.nationality,
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
    super.dispose();
  }

  // Options for dropdowns
  final List<String> genderOptions = ['Male', 'Female'];
  final List<String> nationalityOptions = ['American', 'Canadian', 'British'];

  void _saveDetails() {
    print(_usernameController.text);
    print(_fullNameController.text);
    print(_emailController.text);
    print(_phoneController.text);
    print(_genderController.text);
    print(gender);
    print(nationality);
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
            _buildTextField('Date of Birth', _dobController),
            _buildDropdownField('Gender', gender, genderOptions, (value) {
              setState(() {
                gender = value!;
              });
            }),
            _buildDropdownField('Nationality', nationality, nationalityOptions,
                (value) {
              setState(() {
                nationality = value!;
              });
            }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor, // Set the button color
              ),
              child: const Text(
                'Save Changes',
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
