import 'package:flutter/material.dart';
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

  Game(
      {required this.id,
      required this.name,
      required this.imagePath,
      required this.code});

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

  const GameListPage({required this.gameCode});

  @override
  _GameListPageState createState() => _GameListPageState();
}

class _GameListPageState extends State<GameListPage> {
  late Future<List<Game>> _futureGamesList;
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
    _futureGamesList = fetchGamesByCode(widget.gameCode);
  }

  // Function to fetch games by gameCode
  Future<List<Game>> fetchGamesByCode(String gameCode) async {
    final response = await http.get(Uri.parse(
        'http://api.totomonkey.com/api/public/gameCategoryGame/$gameCode')); // Your API URL

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['success'] == true && data['data'] != null) {
        List<dynamic> gamesData = data['data']
            ['allGames']; // Extracting list of games from 'allGames'
        return gamesData
            .map((json) => Game.fromJson(json))
            .toList(); // Mapping to Game objects
      } else {
        throw Exception('Failed to load games');
      }
    } else {
      throw Exception('Failed to load games: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' ${widget.gameCode}', style: TextStyle(color: mainColor)),
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
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
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
      body: FutureBuilder<List<Game>>(
        future: _futureGamesList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Game> games = snapshot.data!;

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 columns for the grid
                childAspectRatio: .99, // Adjusting item aspect ratio
                crossAxisSpacing: 5,
                mainAxisSpacing: 0,
              ),
              itemCount: games.length,
              itemBuilder: (context, index) {
                Game game = games[index];

                return GestureDetector(
                  onTap: () {
                    // Navigate to a detailed page for the selected game (if you have one)
                    // For now, we simply show the game's name
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(game.name),
                          content: Text('More details about ${game.name}'),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Card(
                    color: primaryColor,
                    elevation: 0.0,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.network(
                            game.imagePath,
                            fit: BoxFit.cover,
                            height: 90,
                            width: double.infinity,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            game.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No games available'));
          }
        },
      ),
    );
  }
}
