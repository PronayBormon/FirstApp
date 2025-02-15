import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:homepage_project/methods/appbar.dart';
import 'package:homepage_project/pages/authentication/signin.dart';
import 'package:homepage_project/pages/games.dart';
import 'package:homepage_project/pages/play-platformGame.dart';
import 'package:homepage_project/pages/reels.dart';
import 'package:homepage_project/pages/user/profile.dart';
import 'package:homepage_project/pages/user/wallet.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquee/marquee.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const primaryColor = Color.fromRGBO(35, 38, 38, 1);
const secondaryColor = Color.fromRGBO(41, 45, 46, 1);
const pinkGradient = LinearGradient(
  colors: [
    Color.fromRGBO(228, 62, 229, 1),
    Color.fromRGBO(229, 15, 112, 1),
  ],
);
const _secureStorage = FlutterSecureStorage();
const baseImageUrl =
    'https://api.totomonkey.com'; // Your base API URL for images

// const _secureStorage = FlutterSecureStorage();

class GamesPlatform extends StatefulWidget {
  final dSlug;
  const GamesPlatform({super.key, required this.dSlug});

  @override
  _GamesPlatformState createState() => _GamesPlatformState();
}

class GameplatformsList {
  final String id;
  final String name;
  final String slug;
  final String imagepath; // Explicitly defining the type as String

  GameplatformsList({
    required this.id,
    required this.name,
    required this.slug,
    required this.imagepath,
  });

  factory GameplatformsList.fromJson(Map<String, dynamic> json) {
    return GameplatformsList(
      id: json['id'].toString(),
      name: json['name'],
      slug: json['slug'],
      imagepath: '$baseImageUrl${json['image']}', // Prepending base URL
    );
  }
}

class Game {
  final String id;
  final String name;
  final String slug;
  final String imagepath;

  Game({
    required this.id,
    required this.name,
    required this.slug,
    required this.imagepath,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'].toString(),
      name: json['name'],
      slug: json['slug'],
      imagepath: '$baseImageUrl${json['image']}',
    );
  }
}

class _GamesPlatformState extends State<GamesPlatform> {
  final int _selectedIndex = 1;
  bool _isLoggedIn = false; // Simple boolean state
  Future<List<GameplatformsList>>? _futureGameTypes;
  Future<List<dynamic>>? _futureGamesList;
  String? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _selectedFilter = widget.dSlug; // Default game type slug
    _checkTokenAndRedirect();
    _futureGameTypes =
        _fetchGameTypes(); // Initialize the future with the fetched game types

    _futureGamesList = _fetchGamesForPlatform(
        _selectedFilter ?? ""); // Fetch games for default platform
  }

  void _checkTokenAndRedirect() async {
    final token = await _secureStorage.read(key: 'access_token');

    if (token == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignIn()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please Complate Your Login.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // Fetch the list of available game types (platforms)
  Future<List<GameplatformsList>> _fetchGameTypes() async {
    final url = Uri.parse('https://api.totomonkey.com/api/games/gamePltfmAll');
    final token = await _secureStorage.read(key: 'access_token');

    if (token == null)
      return []; // Return an empty list if token is not available

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final data = responseData["data"];

        if (data != null && data is List) {
          return data
              .map((platformData) => GameplatformsList.fromJson(platformData))
              .toList();
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching game types: $e');
      return [];
    }
  }

  // Fetch the list of games for the selected platform (using its slug)
  Future<List<dynamic>> _fetchGamesForPlatform(String slug) async {
    if (slug.isEmpty) {
      print('Error: Slug is empty');
      return []; // Return empty list if the slug is invalid
    }

    final url = Uri.parse(
        'https://api.totomonkey.com/api/public/pltformWiseGame?slug=$slug');
    final token = await _secureStorage.read(key: 'access_token');

    if (token == null) return []; // Return empty if token is not available

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData["data"] ?? []; // Return the list of games
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching games for platform: $e');
      return [];
    }
  }

  // Check if the user is logged in
  Future<void> _checkLoginStatus() async {
    final token = await _secureStorage.read(key: 'access_token');
    setState(() {
      _isLoggedIn = token != null;
    });
  }

  // Handle platform click
  void _onPlatformClick(String slug) {
    print('Selected platform slug: $slug');
    setState(() {
      _selectedFilter = slug; // Update the selected platform slug
      _futureGamesList =
          _fetchGamesForPlatform(slug); // Fetch games for the selected platform
    });
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
      appBar: AppBarWidget(),
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
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context), // Navigate back
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: GestureDetector(
                onTap: () {
                  // Navigate to AffiliatePage when tapped
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const GamesPage()),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: double.infinity,
                    // height: 200, // Adjust the height as needed
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/bonusBannar.jpg',
                      fit: BoxFit.fill,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              // top: 10,
              left: 20,
              right: 20,
              bottom: 8,
            ),
            sliver: SliverToBoxAdapter(
              child: Text(
                "Games by Providers",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            sliver: FutureBuilder<List<GameplatformsList>>(
              future: _futureGameTypes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Container(
                        padding: EdgeInsets.all(5),
                        child: Center(
                          child: Shimmer.fromColors(
                            baseColor: secondaryColor,
                            highlightColor:
                                const Color.fromARGB(255, 94, 93, 93),
                            child: Container(
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                      childCount: 5, // Number of shimmer boxes
                    ),
                  );
                } else if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: Center(child: Text('Error: ${snapshot.error}')),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(child: Text('No game platforms available.')),
                  );
                } else {
                  // Data is available, display clickable platforms
                  final gameTypes = snapshot.data!;
                  return SliverToBoxAdapter(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: gameTypes.map((gameType) {
                          return GestureDetector(
                              onTap: () => _onPlatformClick(gameType.slug),
                              child: Column(
                                children: [
                                  // Conditional widget rendering based on the selected filter
                                  if (_selectedFilter == gameType.slug)
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 3, vertical: 10),
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: mainColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.all(5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ClipOval(
                                            child: Container(
                                              color: Colors.white,
                                              child: gameType
                                                      .imagepath.isNotEmpty
                                                  ? Image.network(
                                                      gameType.imagepath,
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Icon(Icons.image, size: 50),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            gameType.name,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    )
                                  // Else block to show something when the condition is false
                                  else
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 3, vertical: 10),
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white24,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.all(5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ClipOval(
                                            child: Container(
                                              color: Colors.white,
                                              child: gameType
                                                      .imagepath.isNotEmpty
                                                  ? Image.network(
                                                      gameType.imagepath,
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Icon(Icons.image, size: 50),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            gameType.name,
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    )
                                ],
                              ));
                        }).toList(),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          // Display games for the selected platform
          SliverPadding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            sliver: FutureBuilder<List<dynamic>>(
              future: _futureGamesList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Container(
                        padding: EdgeInsets.all(5),
                        child: Center(
                          child: Shimmer.fromColors(
                            baseColor: secondaryColor,
                            highlightColor:
                                const Color.fromARGB(255, 94, 93, 93),
                            child: Container(
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                      childCount: 15, // Number of shimmer boxes
                    ),
                  );
                } else if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: Center(child: Text('Error: ${snapshot.error}')),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                        child: Text('No games available for this platform.')),
                  );
                } else {
                  final games = snapshot.data!;
                  return SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: .81,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final game = games[index];
                        return GestureDetector(
                          onTap: () {
                            // Handle game click (optional, could navigate to game details page)
                            // print(game['id']);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => playGames(
                                  slug: game['id'],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            // padding: EdgeInsets.all(8),
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              // color: Colors.white24,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          10), // Match the container's border radius
                                      child: Image(
                                        // Check if the image URL is valid
                                        image: (game['image'] != null &&
                                                game['image'].isNotEmpty)
                                            ? NetworkImage(game['image'])
                                            : AssetImage(
                                                    'assets/images/logo_game.png')
                                                as ImageProvider, // Fallback to asset image
                                        // width: 70,
                                        // height: 70,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  game['name'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1, // Limit to a single line
                                  overflow: TextOverflow
                                      .ellipsis, // Adds ellipsis (...) if text overflows
                                ),
                                // Text(
                                //   game['image'],
                                //   textAlign: TextAlign.center,
                                //   style: TextStyle(
                                //     color: Colors.white,
                                //     fontSize: 12,
                                //   ),
                                // ),
                                // Text(
                                //   game['slug'],
                                //   textAlign: TextAlign.center,
                                //   style: TextStyle(
                                //     color: Colors.white,
                                //     fontSize: 12,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: games.length,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
