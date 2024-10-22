import 'package:flutter/material.dart';
import 'package:homepage_project/pages/HomePage.dart';
import 'package:homepage_project/pages/slider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
      title: 'Your App Title',
    );
  }
}
