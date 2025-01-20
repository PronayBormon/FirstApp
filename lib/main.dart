import 'package:flutter/material.dart';
import 'package:homepage_project/index.dart';
import 'package:homepage_project/pages/HomePage.dart';
import 'package:homepage_project/pages/games.dart';
import 'package:homepage_project/pages/play-Game.dart';
import 'package:homepage_project/pages/reels.dart';
import 'package:homepage_project/pages/slider.dart';

void main() {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter plugins are initialized
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: reelsPage(),
      title: 'FansGames',
    );
  }
}
