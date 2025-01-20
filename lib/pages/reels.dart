import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:homepage_project/helper/constant.dart';
import 'package:homepage_project/pages/HomePage.dart';
import 'package:homepage_project/pages/authentication/signin.dart';
import 'package:homepage_project/pages/games.dart';
import 'package:homepage_project/pages/hoster-list.dart';
import 'package:homepage_project/pages/user/profile.dart';
import 'package:homepage_project/pages/user/wallet.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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

class reelsPage extends StatefulWidget {
  const reelsPage({super.key});

  @override
  _reelsPageState createState() => _reelsPageState();
}

class _reelsPageState extends State<reelsPage> {
  late InAppWebViewController _webViewController;
  late PageController _pageController;
  final _secureStorage = FlutterSecureStorage();
  List<String> _videoUrls = []; // Store the video URLs
  int currentPage = 1; // Start with page 1
  bool isLoading = false; // Flag to prevent multiple requests at once
  bool _isLoggedIn = false; // Flag to prevent multiple requests at once
  final int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(); // Initialize the PageController
    _loadVideos();
    _checkLoginStatus();
    bool _isLoggedIn = false; // Simple boolean state
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

  // Fetch video URLs from the API for a specific page
  Future<void> _loadVideos() async {
    setState(() {
      isLoading = true;
    });

    final url =
        'https://api.totomonkey.com/api/public/getShortVideos?page=$currentPage'; // API URL with page parameter

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> videos = data['data'];

        setState(() {
          _videoUrls =
              videos.map((video) => video['files'].toString()).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load videos');
      }
    } catch (e) {
      print('Error fetching videos: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Next button handler
  void _loadNextPage() {
    if (!isLoading) {
      setState(() {
        currentPage++; // Increment current page
      });
      _loadVideos(); // Fetch new page of videos
    }
  }

  // Prev button handler
  void _loadPrevPage() {
    if (!isLoading && currentPage > 1) {
      setState(() {
        currentPage--; // Decrement current page
      });
      _loadVideos(); // Fetch new page of videos
    }
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _videoUrls.isEmpty
              ? const Center(child: Text('No videos available'))
              : PageView.builder(
                  scrollDirection: Axis.vertical,
                  controller: _pageController,
                  itemCount: _videoUrls.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          // Video Player (InAppWebView)
                          InAppWebView(
                            initialUrlRequest: URLRequest(
                              url: WebUri(_videoUrls[index]),
                            ),
                            initialSettings: InAppWebViewSettings(
                              javaScriptEnabled: true,
                            ),
                            onWebViewCreated: (controller) {
                              _webViewController = controller;
                            },
                            onLoadStop: (controller, url) async {
                              // Inject JavaScript for play/pause controls only
                              await _webViewController
                                  .evaluateJavascript(source: """
                                    document.querySelectorAll('video').forEach(video => {
                                      video.controls = false; // Disable all default controls
                                      video.autoplay = true;  // Enable autoplay
                                      video.loop = true;      // Enable looping
                                      video.muted = true;      // Enable looping

                                      // Add custom play/pause functionality
                                      video.addEventListener('click', () => {
                                        if (video.paused) {
                                          video.play();
                                        } else {
                                          video.pause();
                                        }
                                      });
                                    });
                                  """);
                            },
                            onLoadStart: (controller, url) {
                              print("Page Started: $url");
                            },
                          ),

                          // Prev Button Positioned at the Middle Left
                          Positioned(
                            top: MediaQuery.of(context).size.height / 2 -
                                50, // Center vertically
                            left: 0, // Align to the left
                            child: GestureDetector(
                              onTap:
                                  _loadPrevPage, // Load prev page when tapped
                              child: Container(
                                  height: 50,
                                  width: 50, // Adjust width as needed
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          54, 255, 31, 106),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Icon(Icons.chevron_left,
                                      color: Colors.white)),
                            ),
                          ),
                          // Next Button Positioned at the Middle Right
                          Positioned(
                            top: MediaQuery.of(context).size.height / 2 -
                                50, // Center vertically
                            right: 0, // Align to the right
                            child: GestureDetector(
                              onTap:
                                  _loadNextPage, // Load next page when tapped
                              child: Container(
                                  height: 50,
                                  width: 50, // Adjust width as needed
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          54, 255, 31, 106),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
