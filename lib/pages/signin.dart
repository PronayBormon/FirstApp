import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Signin',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 2.0,
        shadowColor: Colors.black,
        backgroundColor: Color.fromRGBO(41, 45, 46, 1), // Custom dark color
        leading: GestureDetector(
          onTap: () {
            // Back function
            Navigator.pop(
                context); // This will pop the current screen off the stack and go back
          },
          child: Padding(
            padding: const EdgeInsets.all(
                8.0), // Add padding around the leading icon
            child: SvgPicture.asset(
              'assets/icons/chevron-left.svg', // Example SVG asset for back button
              color: Colors.white,
              height: 25,
              width: 25,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              // Define your action here
              print("Menu tapped!");
              // You can navigate to another screen here, for example:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SignIn()), // Example navigation to a "MenuPage"
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: SvgPicture.asset(
                'assets/icons/menu.svg', // Example SVG asset for menu
                color: Colors.white,
                height: 25,
                width: 25,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome to Signin Page'),
      ),
    );
  }
}
