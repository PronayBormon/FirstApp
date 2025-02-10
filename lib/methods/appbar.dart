import 'package:flutter/material.dart';
import 'package:homepage_project/pages/authentication/signin.dart';
import 'package:homepage_project/pages/user/profile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  AppBarWidget({Key? key})
      : preferredSize = Size.fromHeight(80),
        super(key: key);

  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  bool _isLoggedIn = false;
  String? _userName;
  String? _email;
  double? _availableBalance;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Check if the token exists and update state
  Future<void> _checkLoginStatus() async {
    final token = await _secureStorage.read(key: 'access_token');
    final username = await _secureStorage.read(key: 'username');
    final email = await _secureStorage.read(key: 'email');
    final available_balance =
        await _secureStorage.read(key: 'available_balance');

    setState(() {
      _isLoggedIn = token != null;
      _userName = username;
      _email = email;
      _availableBalance =
          available_balance != null ? double.tryParse(available_balance) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: secondaryColor,
      toolbarHeight: 80,
      leading: Padding(
        padding: const EdgeInsets.only(left: 0), // Adjust padding for logo
        child: Container(
          margin: EdgeInsets.only(left: 15),
          child: Image.asset(
            'assets/images/logo-Old.png', // Replace with your logo path
          ),
        ),
      ),
      actions: [
        _isLoggedIn
            ? Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Balance:",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),

                        // Showing the balance dynamically
                        Text(
                          "\$${_availableBalance?.toStringAsFixed(2) ?? '00.00'}",
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfilePage()),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/Avatar_image.png'),
                          radius: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: GestureDetector(
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignIn(),
                                ))
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ],
    );
  }
}
