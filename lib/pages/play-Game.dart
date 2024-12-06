import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:homepage_project/methods/gameApi.dart'; // Adjusted class name
import 'package:homepage_project/pages/HomePage.dart';
import 'package:homepage_project/pages/authentication/signin.dart';
import 'package:homepage_project/pages/components/Sidebar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homepage_project/pages/games.dart';
import 'package:homepage_project/pages/hoster-list.dart';
import 'package:homepage_project/pages/user/profile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  final String gameCode;

  const HtmlPage({super.key, required this.gameCode});

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
    _futureGame = fetchGame(widget.gameCode); // This now returns Future<Game>
    _checkTokenAndRedirect();
  }

  // Check if access token exists and redirect
  void _checkTokenAndRedirect() async {
    final token = await _secureStorage.read(key: 'access_token');
    final userdata = await _secureStorage.read(key: 'userdata');

    print('Token: $token'); // Debug log
    // print('UserData: $userdata'); // Debug log

    if (token == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignIn()),
      );
    }
  }

  // This now returns a Future<Game>
  Future<Game> fetchGame(String gameCode) async {
    final data = {'slug': gameCode};
    try {
      final result = await GameApiService()
          .postRequestData(route: "/games/requesttoGame", data: data);

      final response = jsonDecode(result.body);
      final url = response["url"];

      print(
          '==============================================================================Server Response: $url');

      // If URL is found, return the Game object
      if (url != null) {
        return Game(url: url); // Return the Game object
      } else {
        throw Exception("Game URL not found in response");
      }
    } catch (e) {
      print("Error fetching game: $e");
      // Handle any errors (you can show a dialog or message here)
      throw Exception("Error fetching game: $e");
    }
  }

  void _onItemTapped(int index) {
    final pages = [
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

  // Function to show a popup (AlertDialog) when there's an error
  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("OK"),
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
      body: FutureBuilder<Game>(
        future: _futureGame, // Use the future that returns Game
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Show error dialog on error
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showErrorDialog('Error: ${snapshot.error}');
            });
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            // When the data is fetched successfully, display the web view
            gameUrl = snapshot.data?.url; // Get the URL from the fetched data

            return InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(gameUrl!),
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
