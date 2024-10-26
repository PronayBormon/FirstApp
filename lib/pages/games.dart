import 'package:flutter/material.dart';
import 'package:homepage_project/helper/constant.dart';
import 'package:homepage_project/pages/HomePage.dart';
import 'package:homepage_project/pages/components/Sidebar.dart';
import 'package:homepage_project/pages/hoster-list.dart';
import 'package:homepage_project/pages/user/profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const primaryColor = Color.fromRGBO(35, 38, 38, 1);
const secondaryColor = Color.fromRGBO(41, 45, 46, 1);

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
      imagePath: json['imagepath'],
      code: json['code'], // Ensure this matches your API response
    );
  }
}

class GameCategory {
  final int id;
  final String name;
  List<Game>? games;

  GameCategory({required this.id, required this.name, this.games});

  factory GameCategory.fromJson(Map<String, dynamic> json) {
    return GameCategory(
      id: json['id'],
      name: json['name'],
      games: [],
    );
  }
}

class GamesPage extends StatefulWidget {
  const GamesPage({Key? key}) : super(key: key);

  @override
  _GamesPageState createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  late Future<List<GameCategory>> _futureCategories;
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
    _futureCategories = fetchGameCategories();
  }

  Future<List<GameCategory>> fetchGameCategories() async {
    final response = await http
        .get(Uri.parse('http://api.totomonkey.com/api/public/allGamesType'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      List<GameCategory> categories = [];

      for (var json in jsonData) {
        GameCategory category = GameCategory.fromJson(json);
        category.games = await fetchGamesByCategory(category.name);
        categories.add(category);
      }

      return categories;
    } else {
      throw Exception('Failed to load game categories');
    }
  }

  Future<List<Game>> fetchGamesByCategory(String slug) async {
    try {
      final response = await http.get(Uri.parse(
          'http://api.totomonkey.com/api/public/gameTypeWiseCategory/$slug'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse);
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
    } catch (e) {
      print('Error fetching games: $e');
      throw Exception('Error fetching games: $e');
    }
  }

  void _onGameTapped(Game game) {
    print('Tapped on game: ${game.code}');
    // Navigator.push(context, MaterialPageRoute(builder: (context) => GameDetailPage(game: game)));
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
      body: FutureBuilder<List<GameCategory>>(
        future: _futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final categories = snapshot.data!;

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, categoryIndex) {
              final category = categories[categoryIndex];
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        category.name,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: .56,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 0,
                      ),
                      itemCount: category.games!.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, gameIndex) {
                        final game = category.games![gameIndex];
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
                                    height: 150,
                                    width: double.infinity,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    game.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
