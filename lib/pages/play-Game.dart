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

class HtmlPage extends StatefulWidget {
  final String platType;
  final String gameType;

  const HtmlPage({super.key, required this.platType, required this.gameType});

  @override
  _HtmlPageState createState() => _HtmlPageState();
}

class _HtmlPageState extends State<HtmlPage> {
  late Future<Game> _futureGame; // Type should be Future<Game>
  late InAppWebViewController _webViewController;
  String? gameUrl; // Variable to hold the game URL

  final int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _futureGame = fetchGame(
        widget.platType,
        widget
            .gameType); // This should call the fetchGame method with parameters
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

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Please Login.'),
      //     backgroundColor: Colors.red,
      //     duration: Duration(seconds: 3),
      //   ),
      // );
    }
  }

  // This now returns a Future<Game>
  Future<Game> fetchGame(String platType, String gameType) async {
    final data = {'platType': platType, 'gameType': gameType};
    try {
      final result = await GameApiService()
          .postRequestData(route: "/games/platformTypeGames", data: data);

      final response = jsonDecode(result.body);
      final url = response["url"];
      final code = response["code"];

      if (url != null) {
        return Game(url: url); // Return the Game object
      } else {
        // Handle specific error codes
        switch (code) {
          case 10001:
            throw ("This platform is currently under maintenance. We'll be back shortly. Thank you for your patience!");
          case 10004:
          case 10005:
            throw Exception(
                "This platform is currently under maintenance. We'll be back shortly. Thank you for your patience!");
          case 10006:
            throw Exception(
                "This platform is currently under maintenance. We'll be back shortly. Thank you for your patience!");
          case 10007:
            throw Exception(
                "This platform is currently under maintenance. We'll be back shortly. Thank you for your patience!");
          case 10405:
            throw Exception(
                "This platform is currently under maintenance. We'll be back shortly. Thank you for your patience!");
          case 10407:
            throw Exception(
                "This platform is currently under maintenance. We'll be back shortly. Thank you for your patience!");
          case 10408:
            throw Exception(
                "This platform is currently under maintenance. We'll be back shortly. Thank you for your patience!");
          case 10409:
            throw Exception(
                "This platform is currently under maintenance. We'll be back shortly. Thank you for your patience!");
          default:
            throw Exception("Unknown error occurred (code: $code)");
        }
      }
    } catch (e) {
      // print("Error fetching game: $e");
      // throw Exception("Error fetching game: $e");
      throw "Please complete your login before Play game"; // Directly rethrowing the original error instead of wrapping it
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

  // Function to show a popup (AlertDialog) when there's an error
  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Error",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Game is under upgrade. Please try again later.",
            style: TextStyle(
              color: mainColor,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Row(
                children: [
                  Text("OK"),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GamesPage()),
                      );
                    },
                    child: Text('Back'),
                  )
                ],
              ),
            ),
          ],
        );
      },
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
            // Extract error message from the Exception
            String errorMessage = snapshot.error.toString();
            if (errorMessage.contains("Exception: ")) {
              errorMessage = errorMessage
                  .split("Exception: ")
                  .last; // Get the clean message
            }

            return Builder(
              builder: (context) {
                // Show SnackBar after the frame is built
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
                      Image.asset('assets/images/logo_game.png'),
                      const SizedBox(height: 16),
                      Text(
                        errorMessage, // Show only the cleaned-up error message
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

            // Convert String to WebUri safely
            final WebUri webUri = WebUri(gameUrl);

            return InAppWebView(
              initialUrlRequest: URLRequest(
                url: webUri, // Use WebUri instead of Uri
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
