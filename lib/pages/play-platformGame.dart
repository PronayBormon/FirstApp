import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:homepage_project/methods/gameApi.dart'; // Adjusted class name
import 'package:homepage_project/pages/HomePage.dart';
import 'package:homepage_project/pages/authentication/signin.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homepage_project/pages/games.dart';
import 'package:homepage_project/pages/hoster-list.dart';
import 'package:homepage_project/pages/reels.dart';
import 'package:homepage_project/pages/user/profile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:homepage_project/pages/user/wallet.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_inappwebview/flutter_inappwebview.dart'; // Import WebUri

// Define colors
const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const primaryColor = Color.fromRGBO(35, 38, 38, 1);
const secondaryColor = Color.fromRGBO(41, 45, 46, 1);
const _secureStorage = FlutterSecureStorage();

// Game class for single data
class Game {
  final String url;

  Game({required this.url});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      url: json['url'],
    );
  }
}

class playGames extends StatefulWidget {
  final int slug;
  const playGames({super.key, required this.slug});

  @override
  _playGamesState createState() => _playGamesState();
}

class _playGamesState extends State<playGames> {
  late Future<Game> _futureGame; // Type should be Future<Game>
  late InAppWebViewController _webViewController;
  String? gameUrl; // Variable to hold the game URL

  final int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _futureGame = fetchGame(widget.slug); // Initialize the future here
    _checkTokenAndRedirect();
  }

  // Check if access token exists and redirect
  void _checkTokenAndRedirect() async {
    final token = await _secureStorage.read(key: 'access_token');
    final userdata = await _secureStorage.read(key: 'userdata');

    if (token == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignIn()),
      );
    }
  }

  Future<Game> fetchGame(int slug) async {
    final url = Uri.parse('https://api.totomonkey.com/api/games/requesttoGame');
    final token = await _secureStorage.read(key: 'access_token');

    if (token == null) {
      throw Exception("Token is not available");
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'slug':
              slug, // Make sure the key is a string and the value is the variable
        }),
      );

      final responseData = jsonDecode(response.body);

      final String? gameUrl = responseData['response_url']['data']['url'];
      print("+++++++==========++++++++ $responseData");

      if (gameUrl != null) {
        return Game(url: gameUrl); // Return the Game object with the URL
      } else {
        throw Exception("Error fetching game");
      }
    } catch (e) {
      throw Exception("Error fetching game: $e");
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
        title: Text("Game", style: const TextStyle(color: mainColor)),
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
        future: _futureGame, // Use the future that returns Game
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Image.asset('assets/images/logo_game.png'),
            );
          } else if (snapshot.hasError) {
            String errorMessage = snapshot.error.toString();
            if (errorMessage.contains("Exception: ")) {
              errorMessage = errorMessage.split("Exception: ").last;
            }

            return Builder(
              builder: (context) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage.trim()),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 4),
                    ),
                  );
                });

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GamesPage()),
                          );
                        },
                        child: const Text('Back to games'),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasData) {
            final gameUrl = snapshot.data?.url;
            if (gameUrl == null || gameUrl.isEmpty) {
              return const Center(child: Text('No game URL found'));
            }

            // Convert game URL string to WebUri
            final WebUri webUri = WebUri(gameUrl);

            return InAppWebView(
              initialUrlRequest: URLRequest(
                url: webUri, // Use WebUri here
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                _webViewController = controller;
              },
              onLoadStart: (InAppWebViewController controller, WebUri? url) {
                print("Page Started: $url");
              },
              onLoadStop:
                  (InAppWebViewController controller, WebUri? url) async {
                print("Page Loaded: $url");
              },
            );
          } else {
            return const Center(child: Text('No game URL found'));
          }
        },
      ),
    );
  }
}
