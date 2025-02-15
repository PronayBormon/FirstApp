import 'package:flutter/material.dart';
import 'package:homepage_project/helper/constant.dart';
import 'package:homepage_project/methods/appbar.dart';
import 'package:homepage_project/pages/HomePage.dart';
import 'package:homepage_project/pages/authentication/signin.dart';
import 'package:homepage_project/pages/gamePlatforms.dart';
import 'package:homepage_project/pages/game_list.dart';
import 'package:homepage_project/pages/hoster-list.dart';
import 'package:homepage_project/pages/play-Game.dart';
import 'package:homepage_project/pages/reels.dart';
import 'package:homepage_project/pages/user/affiliate.dart';
import 'package:homepage_project/pages/user/deposit.dart';
import 'package:homepage_project/pages/user/personal-details.dart';
import 'package:homepage_project/pages/user/profile.dart';
import 'package:homepage_project/pages/user/transections.dart';
import 'package:homepage_project/pages/user/wallet.dart';
import 'package:homepage_project/pages/user/withdraw.dart';
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

class GameType {
  final String id;
  final String name;
  final String imagepath; // Explicitly defining the type as String

  GameType({
    required this.id,
    required this.name,
    required this.imagepath,
  });

  factory GameType.fromJson(Map<String, dynamic> json) {
    return GameType(
      id: json['id'].toString(),
      name: json['name'],
      imagepath: json[
          'imagepath'], // Assuming imagepath is a string (URL or file path)
    );
  }
}

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
  final int _selectedIndex = 1;
  late Future<List<Game>> _futureGames;
  late Future<List<GameType>> _futureGameTypes;
  String _selectedFilter = "4"; // Default game type ID
  String? _searchText; // Default game type ID
  bool _isLoggedIn = false; // Simple boolean state
  Future<List<GameplatformsList>>? _futureProviders;

  @override
  void initState() {
    super.initState();
    _futureGameTypes = fetchGameTypes();
    _futureGames = fetchGamesByType(_selectedFilter);
    _checkLoginStatus();
    _futureProviders = _fetchGameTypes(); // Fetch providers dynamically
    _checkTokenAndRedirect();
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
          content: Text('Please Complete Your Login.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

// Fetch game platforms (providers)
  Future<List<GameplatformsList>> _fetchGameTypes() async {
    final url = Uri.parse('https://api.totomonkey.com/api/games/gamePltfmAll');
    final token = await _secureStorage.read(key: 'access_token');

    if (token == null) return []; // Return an empty list if no token

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final data = responseData["data"] as List?;
        print(data);
        return data?.map((json) => GameplatformsList.fromJson(json)).toList() ??
            [];
      }
    } catch (e) {
      print('Error fetching game types: $e');
    }
    return []; // Return empty list on error
  }

// Fetch all game types
  Future<List<GameType>> fetchGameTypes() async {
    final response = await http.get(
      Uri.parse('https://api.totomonkey.com/api/public/allGamesType'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        final data = jsonResponse['data'] as List?;
        return data?.map((json) => GameType.fromJson(json)).toList() ?? [];
      }
    }
    throw Exception('Failed to load game types');
  }

// Fetch games by type and search filter
  Future<List<Game>> fetchGamesByTypeSearch(
      String gameTypeId, String slug) async {
    final response = await http.get(
      Uri.parse(
          'https://api.totomonkey.com/api/public/gameTypeWisePlatformList?game_type_id=$gameTypeId&slug=$slug'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        final data = jsonResponse['data'] as List?;
        if (data != null) {
          print("********************* $data");
          setState(() {
            _futureGames =
                Future.value(data.map((json) => Game.fromJson(json)).toList());
          });
        }
      }
    }
    return Future.value([]); // Return an empty list if no results
  }

  Future<List<Game>> fetchGamesByType(String gameTypeId) async {
    final response = await http.get(
      Uri.parse(
          'https://api.totomonkey.com/api/public/gameTypeWisePlatformList?game_type_id=$gameTypeId'),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        var data = jsonResponse['data'];
        if (data is List) {
          return data.map((json) => Game.fromJson(json)).toList();
        }
      }
    }
    throw Exception('Failed to load games');
  }

  // Check if the token exists and update state
  Future<void> _checkLoginStatus() async {
    final token = await _secureStorage.read(key: 'access_token');
    setState(() {
      _isLoggedIn = token != null;
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

  void _onGameTapped(Game game) {
    // print("${game.slug}, $_selectedFilter");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            HtmlPage(platType: game.slug, gameType: _selectedFilter),
      ),
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
            padding:
                const EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 5),
            sliver: SliverToBoxAdapter(
              child: GestureDetector(
                onTap: () {
                  // Navigate to AffiliatePage when tapped
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AffiliatePage()),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: double.infinity,
                    height: 150, // Adjust the height as needed
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/bonusBannar.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
            sliver: SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 30, // Ensure the height is defined
                child: Marquee(
                  text:
                      "'Welcome to FansGame! 🎮Join a vibrant community of gamers, enjoy thrilling challenges, and explore endless entertainment. Play, compete, and connect with fellow fans from around the world! 🌍🔥",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                  scrollAxis: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(right: 10),
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Dropdown for Providers (Fetched from API)
                    Container(
                      alignment: Alignment(0, 0),
                      width: deviceWidth(context) *
                          .4, // Adjust the width as needed
                      height: 60,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white, // Border color
                          width: 1, // Border width
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: FutureBuilder<List<GameplatformsList>>(
                          future: _futureProviders,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text("Error loading providers"));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Center(
                                  child: Text("No providers available"));
                            }

                            List<GameplatformsList> providers = snapshot.data!;
                            return DropdownButton<String>(
                              value: 'All Provider',
                              items: [
                                DropdownMenuItem(
                                  value: 'All Provider',
                                  child: Text(
                                    'All Provider',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                ...providers.map((provider) {
                                  return DropdownMenuItem<String>(
                                    value: provider.slug,
                                    child: Text(
                                      provider.name,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                }).toList(),
                              ],
                              onChanged: (newValue) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            GamesPlatform(dSlug: newValue)));
                                // print("Selected Provider: $newValue");
                              },
                              dropdownColor: secondaryColor,
                              underline: SizedBox(), // Remove the underline
                              icon: Icon(Icons.arrow_drop_down,
                                  color: Colors.white),
                            );
                          },
                        ),
                      ),
                    ),

                    // Search TextField with Button
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        width: deviceWidth(context) * .5,
                        height: 60,
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white, // Border color
                            width: 1, // Border width
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Search provider",
                                  hintStyle: TextStyle(color: Colors.white60),
                                  filled: true,
                                  fillColor: secondaryColor,
                                  border:
                                      InputBorder.none, // Removes the border
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                ),
                                style: TextStyle(color: Colors.white),
                                onChanged: (value) {
                                  setState(() {
                                    _searchText = value;
                                  });
                                  // Handle text change (optional for live search)
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.search, color: Colors.white),
                              onPressed: () {
                                print(
                                    "$_selectedFilter ++++++++++++++ $_searchText");
                                if (_selectedFilter?.isNotEmpty == true &&
                                    _searchText?.isNotEmpty == true) {
                                  fetchGamesByTypeSearch(
                                      _selectedFilter!, _searchText!);
                                } else {
                                  // Show a message or handle empty input case
                                  print("Please enter a valid search query");
                                }
                                print(
                                    "$_searchText ============= $_selectedFilter");
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: FutureBuilder<List<GameType>>(
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
                      childCount: 4,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text('Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red)),
                    ),
                  );
                } else if (snapshot.hasData) {
                  final gameTypes = snapshot.data!;
                  return SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Container(
                          // padding: EdgeInsets.all(10),
                          // decoration: BoxDecoration(
                          //   color:
                          //       Colors.white10, // Set the background color here
                          //   borderRadius: BorderRadius.circular(10),
                          // ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                gameTypes.length,
                                (index) {
                                  final gameType = gameTypes[index];
                                  return Column(
                                    children: [
                                      if (_selectedFilter == gameType.id)
                                        Container(
                                          margin: EdgeInsets.only(right: 10),
                                          decoration: BoxDecoration(
                                            color: mainColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _selectedFilter = gameType.id;
                                                  _futureGames =
                                                      fetchGamesByType(
                                                          _selectedFilter);
                                                });
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: 50,
                                                    child: Container(
                                                      // padding: EdgeInsets.only(left: 15, right: 15),
                                                      width:
                                                          50, // Set a fixed width for the image
                                                      height:
                                                          50, // Set a fixed height for the image
                                                      child: ClipOval(
                                                        child: Container(
                                                          height:
                                                              double.infinity,
                                                          width: 25,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                          ),
                                                          child: Image.network(
                                                            gameType.imagepath,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    gameType.name,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      else
                                        Container(
                                          margin: EdgeInsets.only(right: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white12,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _selectedFilter = gameType.id;
                                                  _futureGames =
                                                      fetchGamesByType(
                                                          _selectedFilter);
                                                });
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: 50,
                                                    child: Container(
                                                      // padding: EdgeInsets.only(left: 15, right: 15),
                                                      width:
                                                          50, // Set a fixed width for the image
                                                      height:
                                                          50, // Set a fixed height for the image
                                                      child: ClipOval(
                                                        child: Container(
                                                          height:
                                                              double.infinity,
                                                          width: 25,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                          ),
                                                          child: Image.network(
                                                            gameType.imagepath,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    gameType.name,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SliverFillRemaining(
                    child: Center(child: Text('No game types available.')),
                  );
                }
              },
            ),
          ),
          SliverToBoxAdapter(
              child: Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 0,
              bottom: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Providers",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: FutureBuilder<List<Game>>(
              future: _futureGames,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: .89,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Container(
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
                      childCount: 10,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text('Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red)),
                    ),
                  );
                }

                final games = snapshot.data!;
                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: .75,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final game = games[index];
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () => _onGameTapped(game),
                            child: Container(
                              // decoration: BoxDecoration(
                              //   color: secondaryColor,
                              //   // borderRadius: BorderRadius.circular(10),
                              // ),
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
                                      child: Image.network(
                                        game.imagePath,
                                        fit: BoxFit.cover,
                                        // height: 65,
                                        // width: 60,
                                        width: double.infinity,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      game.name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    },
                    childCount: games.length,
                  ),
                );
              },
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(10),
          ),
        ],
      ),
    );
  }
}
