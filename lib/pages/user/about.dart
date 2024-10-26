import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const primaryColor = Color.fromRGBO(35, 38, 38, 1);
const secondaryColor = Color.fromRGBO(41, 45, 46, 1);
const pinkGradient = LinearGradient(
  colors: [Color.fromRGBO(228, 62, 229, 1), Color.fromRGBO(229, 15, 112, 1)],
);

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About', style: TextStyle(color: mainColor)),
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
      backgroundColor: const Color.fromRGBO(35, 38, 38, 1),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About This Software',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'This software is designed to provide users with an intuitive and engaging experience. Our main features include:',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 8),
            BulletPoint(text: 'User-friendly interface'),
            BulletPoint(text: 'Real-time notifications'),
            BulletPoint(text: 'Secure data handling'),
            BulletPoint(text: 'Comprehensive support'),
            SizedBox(height: 16),
            Text(
              'Our Mission:',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'To empower users with innovative tools that enhance productivity and promote engagement.',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Contact Us:',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Email: support@example.com',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            Text(
              'Website: www.example.com',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.circle, size: 8, color: Colors.white),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
