import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 2.0,
        shadowColor: Colors.black,
        backgroundColor: Color.fromRGBO(41, 45, 46, 1),
        // Color.fromRGBO(255, 31, 104, 1.0), // Full opacity (1.0)
        leading: Container(
          decoration: BoxDecoration(
            // color: Colors.amber[100],
            borderRadius: BorderRadius.circular(5),
          ),
          child: Image.asset(
            'assets/images/logo.png',
            height: 90, // Set the height of the image
            width: 90, // Set the width of the image
            fit: BoxFit.contain,
          ),
        ),
      ),
      // body: weigets,
    );
  }
}
