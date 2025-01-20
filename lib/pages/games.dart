import 'package:flutter/material.dart';
import 'package:homepage_project/helper/constant.dart';
import 'package:homepage_project/pages/HomePage.dart';
import 'package:homepage_project/pages/authentication/signin.dart';
import 'package:homepage_project/pages/game_list.dart';
import 'package:homepage_project/pages/hoster-list.dart';
import 'package:homepage_project/pages/play-Game.dart';
import 'package:homepage_project/pages/reels.dart';
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
  bool _isLoggedIn = false; // Simple boolean state

  @override
  void initState() {
    super.initState();
    _futureGameTypes = fetchGameTypes();
    _futureGames = fetchGamesByType(_selectedFilter);
    _checkLoginStatus();
  }

  Future<List<GameType>> fetchGameTypes() async {
    final response = await http.get(
      Uri.parse('https://api.totomonkey.com/api/public/allGamesType'),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        var data = jsonResponse['data'];
        if (data is List) {
          return data.map((json) => GameType.fromJson(json)).toList();
        }
      }
    }
    throw Exception('Failed to load game types');
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: secondaryColor,
        toolbarHeight: 80,
        leading: Padding(
          padding: const EdgeInsets.only(left: 0), // Adjust padding for logo
          child: Container(
            margin: EdgeInsets.only(left: 15),
            child: Image.asset(
              'assets/images/logo-Old.png', // Replace with your logo path
              // fit: BoxFit.contain,
              // height: 200, // Larger logo size
              // width: 80,
            ),
          ),
        ),
        actions: [
          _isLoggedIn
              ? Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Balance:",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            "\$00.00",
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProfilePage()),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/Avatar_image.png'),
                            radius: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: GestureDetector(
                            onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignIn(),
                                  ))
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        ],
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
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.25,
                crossAxisSpacing: 3,
                mainAxisSpacing: 3,
              ),
              delegate: SliverChildListDelegate(
                [
                  GestureDetector(
                    onTap: () => {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PersonalDetails(),
                        ),
                      ),
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return pinkGradient.createShader(bounds);
                          },
                          child: const Icon(Icons.person,
                              size: 25, color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        const Text("Personal Details",
                            textAlign:
                                TextAlign.center, // Align text to the center
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            )),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WalletPage(),
                        ),
                      ),
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return pinkGradient.createShader(bounds);
                          },
                          child: const Icon(Icons.account_balance_wallet,
                              size: 25, color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        const Text("Wallet",
                            textAlign:
                                TextAlign.center, // Align text to the center
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            )),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DepositPage(),
                        ),
                      ),
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return pinkGradient.createShader(bounds);
                          },
                          child: const Icon(Icons.download,
                              size: 25, color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        const Text("Deposit",
                            textAlign:
                                TextAlign.center, // Align text to the center
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            )),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WithdrawPage(),
                        ),
                      ),
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return pinkGradient.createShader(bounds);
                          },
                          child: const Icon(Icons.upload,
                              size: 25, color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        const Text("Withdraw",
                            textAlign:
                                TextAlign.center, // Align text to the center
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            )),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Transection(),
                        ),
                      ),
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return pinkGradient.createShader(bounds);
                          },
                          child: const Icon(Icons.history,
                              size: 25, color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        const Text("Transections",
                            textAlign:
                                TextAlign.center, // Align text to the center
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            )),
                      ],
                    ),
                  ),
                ],
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
            padding: const EdgeInsets.all(20),
            sliver: FutureBuilder<List<GameType>>(
              future: _futureGameTypes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
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
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white10, // Set the background color here
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            gameTypes.length,
                            (index) {
                              final gameType = gameTypes[index];
                              return _buildGameTypeItem(gameType);
                            },
                          ),
                        ),
                      ),
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
                    childAspectRatio: .90,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final game = games[index];
                      return GestureDetector(
                        onTap: () => _onGameTapped(game),
                        child: Container(
                          decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                child: Container(
                                  color: Colors.white,
                                  child: Image.network(
                                    game.imagePath,
                                    fit: BoxFit.cover,
                                    height: 85,
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

  Widget _buildGameTypeList(List<GameType> gameTypes) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: gameTypes.length,
        itemBuilder: (context, index) {
          final gameType = gameTypes[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = gameType.id;
                _futureGames = fetchGamesByType(_selectedFilter);
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 4,
              ),
              decoration: BoxDecoration(
                gradient: _selectedFilter == gameType.id ? pinkGradient : null,
                borderRadius: BorderRadius.circular(16),
                color: _selectedFilter == gameType.id
                    ? null
                    : Colors.grey.shade800,
              ),
              child: Center(
                child: Text(
                  gameType.name,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGameTypeItem(GameType gameType) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedFilter = gameType.id;
              _futureGames = fetchGamesByType(_selectedFilter);
            });
          },
          child: Column(
            children: [
              Container(
                width: 80,
                child: Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  width: 50, // Set a fixed width for the image
                  height: 50, // Set a fixed height for the image
                  child: ClipOval(
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
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
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
