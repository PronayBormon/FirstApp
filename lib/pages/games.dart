import 'package:flutter/material.dart';
import 'package:homepage_project/helper/constant.dart';
import 'package:homepage_project/pages/HomePage.dart';
import 'package:homepage_project/pages/components/Sidebar.dart';
import 'package:homepage_project/pages/game_list.dart';
import 'package:homepage_project/pages/hoster-list.dart';
import 'package:homepage_project/pages/play-Game.dart';
import 'package:homepage_project/pages/user/profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const primaryColor = Color.fromRGBO(35, 38, 38, 1);
const secondaryColor = Color.fromRGBO(41, 45, 46, 1);

class Game {
  final int id;
  final String name;
  final String imagePath;
  final String slug;

  Game({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.slug,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      name: json['name'],
      imagePath: json['imagepath'],
      slug: json['slug'],
    );
  }
}

class GamesPage extends StatefulWidget {
  const GamesPage({super.key});

  @override
  _GamesPageState createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  late Future<List<Game>> _futureGames;
  final int _selectedIndex = 1;
  String _selectedFilter = "All";

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
    _futureGames = fetchAllGames();
  }

  Future<List<Game>> fetchAllGames() async {
    final response = await http.get(
      Uri.parse('https://api.totomonkey.com/api/public/getPublicAllGames'),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        var data = jsonResponse['data'];
        if (data is List) {
          return data.map((json) => Game.fromJson(json)).toList();
        } else {
          throw Exception(
              'Expected data to be a list but got ${data.runtimeType}');
        }
      } else {
        throw Exception('Failed to fetch games: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to load games: ${response.statusCode}');
    }
  }

  Future<List<Game>> fetchFilteredGames(String filter) async {
    final response = await http.get(
      Uri.parse(
          'https://api.totomonkey.com/api/public/gameTypeWiseCategory/$filter'),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        var data = jsonResponse['data'];
        if (data is List) {
          return data.map((json) => Game.fromJson(json)).toList();
        } else {
          throw Exception(
              'Expected data to be a list but got ${data.runtimeType}');
        }
      } else {
        throw Exception('Failed to fetch games: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to load games: ${response.statusCode}');
    }
  }

  void _onGameTapped(Game game) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HtmlPage(gameCode: game.slug),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Games', style: TextStyle(color: mainColor)),
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
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: mainColor,
          unselectedItemColor: Colors.black54,
          backgroundColor: Colors.transparent,
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedFilter = "All";
                        _futureGames = fetchAllGames();
                      });
                    },
                    child: const Text("All"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedFilter = "pg";
                        _futureGames = fetchFilteredGames("pg");
                      });
                    },
                    child: const Text("PG"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedFilter = "jili";
                        _futureGames = fetchFilteredGames("jili");
                      });
                    },
                    child: const Text("JILI"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedFilter = "pp_max";
                        _futureGames = fetchFilteredGames("pp_max");
                      });
                    },
                    child: const Text("PP Max"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedFilter = "omg_min";
                        _futureGames = fetchFilteredGames("omg_min");
                      });
                    },
                    child: const Text("OMG Man"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedFilter = "mini_game";
                        _futureGames = fetchFilteredGames("mini_game");
                      });
                    },
                    child: const Text("MINI GAME"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedFilter = "omg_crypto";
                        _futureGames = fetchFilteredGames("omg_crypto");
                      });
                    },
                    child: const Text("OMG Crypto"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedFilter = "hacksaw";
                        _futureGames = fetchFilteredGames("hacksaw");
                      });
                    },
                    child: const Text("Hacksaw"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedFilter = "pp";
                        _futureGames = fetchFilteredGames("pp");
                      });
                    },
                    child: const Text("PP"),
                  ),
                ],
              ),
            ),
          ),

          // Simple loading indicator while data is loading
          Expanded(
            child: FutureBuilder<List<Game>>(
              future: _futureGames,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                          CircularProgressIndicator()); // Show loading indicator
                } else if (snapshot.hasError) {
                  // Display error in a SnackBar
                  Future.delayed(Duration.zero, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${snapshot.error}')),
                    );
                  });

                  // Or show an AlertDialog for a more prominent error message
                  Future.delayed(Duration.zero, () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Error"),
                        content: Text('Error: ${snapshot.error}'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close dialog
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  });

                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final games = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: .90,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 0,
                    ),
                    itemCount: games.length,
                    itemBuilder: (context, index) {
                      final game = games[index];
                      return GestureDetector(
                        onTap: () => _onGameTapped(game),
                        child: Card(
                          color: primaryColor,
                          elevation: 0,
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
