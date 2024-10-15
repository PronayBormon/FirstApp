import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../HomePage.dart';
import '../components/Sidebar.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Signup',
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
      drawer: OffcanvasMenu(),
      backgroundColor: Color.fromRGBO(35, 38, 38, 1),
      body: Center(
        child: Text(
          'Welcome to Register Page',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
