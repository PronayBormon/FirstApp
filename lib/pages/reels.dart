import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:homepage_project/methods/appbar.dart';
import 'package:homepage_project/pages/authentication/signin.dart';
import 'package:homepage_project/pages/games.dart';
import 'package:homepage_project/pages/user/profile.dart';
import 'package:homepage_project/pages/user/wallet.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _secureStorage = FlutterSecureStorage();

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const primaryColor = Color.fromRGBO(35, 38, 38, 1);
const secondaryColor = Color.fromRGBO(41, 45, 46, 1);

class reelsPage extends StatefulWidget {
  const reelsPage({Key? key}) : super(key: key);

  @override
  _ReelsPageState createState() => _ReelsPageState();
}

class _ReelsPageState extends State<reelsPage> {
  late InAppWebViewController _webViewController;
  late PageController _pageController;
  final _secureStorage = FlutterSecureStorage();
  List<String> _videoUrls = []; // Store the video URLs
  int currentPage = 1; // Start with page 1
  bool isLoading = false; // Flag to prevent multiple requests at once
  bool _isLoggedIn = false; // Flag to prevent multiple requests at once
  final int _selectedIndex = 0;

  int _currentPage = 1;
  int _lastPage = 1;
  bool _isLoading = false;

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

  Future<void> _loadVideos() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final url =
        'https://api.totomonkey.com/api/public/getShortVideosMobile?page=$_currentPage';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> videos = data['data'];

        setState(() {
          _videoUrls.addAll(videos.map((video) => video['files'].toString()));
          _currentPage = data['current_page'];
          _lastPage = data['last_page'];
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load videos');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching videos: $e');
    }
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
      body: _isLoading && _videoUrls.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _videoUrls.isEmpty
              ? const Center(
                  child: Text(
                    'No videos available',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : PageView.builder(
                  scrollDirection: Axis.vertical,
                  controller: _pageController,
                  itemCount:
                      _videoUrls.length + (_currentPage < _lastPage ? 1 : 0),
                  onPageChanged: (index) {
                    if (index == _videoUrls.length - 1 &&
                        _currentPage < _lastPage) {
                      _currentPage++;
                      _loadVideos();
                    }
                  },
                  itemBuilder: (context, index) {
                    if (index == _videoUrls.length) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return InAppWebView(
                      initialUrlRequest:
                          URLRequest(url: WebUri(_videoUrls[index])),
                      initialSettings: InAppWebViewSettings(
                        javaScriptEnabled: true,
                      ),
                      onLoadStop: (controller, url) async {
                        await controller.evaluateJavascript(source: """
                          document.querySelectorAll('video').forEach(video => {
                            video.controls = false;
                            video.autoplay = true;
                            video.loop = true;
                            video.muted = false;

                            video.addEventListener('click', () => {
                              if (video.paused) video.play();
                              else video.pause();
                            });
                          });
                        """);
                      },
                    );
                  },
                ),
    );
  }
}
