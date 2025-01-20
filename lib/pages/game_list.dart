import 'package:flutter/material.dart';
import 'package:homepage_project/pages/HomePage.dart';
import 'package:homepage_project/pages/games.dart';
import 'package:homepage_project/pages/hoster-list.dart';
import 'package:homepage_project/pages/reels.dart';
import 'package:homepage_project/pages/user/profile.dart';
import 'package:homepage_project/pages/user/wallet.dart';
import 'dart:convert'; // For JSON handling
import 'package:http/http.dart' as http; // For HTTP requests
import 'package:flutter_svg/flutter_svg.dart';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const primaryColor = Color.fromRGBO(35, 38, 38, 1);
const secondaryColor = Color.fromRGBO(41, 45, 46, 1);
const pinkGradient = LinearGradient(
  colors: [Color.fromRGBO(228, 62, 229, 1), Color.fromRGBO(229, 15, 112, 1)],
);

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
      code: json['code'],
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

  @override
  void initState() {
    super.initState();
    _futureGame = fetchGameByCode(widget.gameCode); // Fetch game data
  }

  Future<Game> fetchGameByCode(String gameCode) async {
    final response = await http.get(
      Uri.parse(
          'https://api.totomonkey.com/api/public/checkGameData?slug=$gameCode'),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['success']) {
        return Game.fromJson(data['data']);
      } else {
        throw Exception('Failed to load game: ${data['message']}');
      }
    } else {
      throw Exception('Failed to load game: ${response.statusCode}');
    }
  }

  void _onItemTapped(int index) {
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
      body: FutureBuilder<Game>(
        future: _futureGame,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show placeholder while loading
            return Center(
              child: Image.asset('assets/images/placeholder.jpg'),
            );
          } else if (snapshot.hasError) {
            // Show fallback image on error
            return Center(
              child: Image.asset('assets/images/placeholder.jpg'),
            );
          } else if (snapshot.hasData) {
            // Show game image when loaded
            return Center(
              child: FadeInImage.assetNetwork(
                placeholder:
                    'assets/images/placeholder.jpg', // Placeholder image
                image: snapshot.data!.imagePath, // Game image URL
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                      'assets/images/placeholder.jpg'); // Fallback image
                },
              ),
            );
          } else {
            return const Center(
              child: Text('No data available'),
            );
          }
        },
      ),
    );
  }
}
