import 'package:flutter/material.dart';
import 'package:homepage_project/main-copy.dart';
import 'package:homepage_project/pages/HomePage.dart';
import 'package:homepage_project/pages/components/Sidebar.dart';
import 'package:homepage_project/pages/games.dart';
import 'package:homepage_project/pages/hoster-list.dart';
import 'package:homepage_project/pages/user/profile.dart';
import 'dart:convert'; // For JSON handling
import 'package:http/http.dart' as http; // For HTTP requests
import 'package:flutter_svg/flutter_svg.dart';

// Constants for color themes
const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const primaryColor = Color.fromRGBO(35, 38, 38, 1);
const secondaryColor = Color.fromRGBO(41, 45, 46, 1);

// Game model class
class Game {
  final int id;
  final String code;
  final String name;
  final String imagePath;

  Game({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.code,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      name: json['name'],
      imagePath: json['img'], // Adjust your API response key if necessary
      code: json['code'], // Ensure this matches your API response
    );
  }
}

class GameListPage extends StatefulWidget {
  final String gameCode;

  const GameListPage({super.key, required this.gameCode});

  @override
  _GameListPageState createState() => _GameListPageState();
}

class _GameListPageState extends State<GameListPage> {
  late Future<Game> _futureGame;
  final int _selectedIndex = 1;

  void _onItemTapped(int index) {
    List<Widget> pages = [
      const Homepage(),
      const GamesPage(),
      const HosterListPage(),
      const ProfilePage(),
    ];

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => pages[index]),
    );
  }

  @override
  void initState() {
    super.initState();
    // Fetch the game when the page is initialized
    // _futureGame = fetchGameByCode(widget.gameCode);
  }

  // Future<Game> fetchGameByCode(String gameCode) async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse(
  //           'https://api.totomonkey.com/api/public/checkGameData?slug=$gameCode'), // Dynamically use the gameCode
  //     );

  //     if (response.statusCode == 200) {
  //       var data = json.decode(response.body);
  //       print("===========" +
  //           jsonEncode(data)); // Print the gameCode for debugging

  //       if (data['success']) {
  //         var gameData = data['data'];

  //         // Ensure the data is a map (a single game) and return a Game object
  //         if (gameData is Map<String, dynamic>) {
  //           return Game.fromJson(gameData);
  //         } else {
  //           throw Exception(
  //               'Expected data to be a map, but got ${gameData.runtimeType}');
  //         }
  //       } else {
  //         throw Exception('Failed to load game: ${data['message']}');
  //       }
  //     } else {
  //       throw Exception('Failed to load game: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error fetching game: $e');
  //     rethrow; // Re-throw the error after logging
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gameCode, style: const TextStyle(color: mainColor)),
        centerTitle: true,
        backgroundColor: secondaryColor,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset('assets/icons/chevron-left.svg',
                color: Colors.white, height: 25, width: 25),
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: SvgPicture.asset('assets/icons/menu.svg',
                  color: Colors.white, height: 25, width: 25),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ],
      ),
      drawer: const OffcanvasMenu(),
      bottomNavigationBar: ClipRRect(
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: mainColor,
          unselectedItemColor: Colors.black54,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.sports_esports), label: 'Games'),
            BottomNavigationBarItem(
                icon: Icon(Icons.play_circle), label: 'Betting'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          onTap: _onItemTapped,
        ),
      ),
      backgroundColor: primaryColor,
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Homepage()),
            );
          },
          child: const Text('Go to MyApp'),
        ),
      ),
    );
  }
}
