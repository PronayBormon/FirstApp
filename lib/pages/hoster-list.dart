import 'package:flutter/material.dart';
import 'package:homepage_project/methods/appbar.dart';
import 'package:homepage_project/pages/HomePage.dart';
import 'package:homepage_project/pages/authentication/signin.dart';
import 'package:homepage_project/pages/games.dart';
import 'package:homepage_project/pages/play-video.dart';
import 'package:homepage_project/pages/reels.dart';
import 'package:homepage_project/pages/user/affiliate.dart';
import 'package:homepage_project/pages/user/profile.dart';
import 'package:marquee/marquee.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const primaryColor = Color.fromRGBO(35, 38, 38, 1);
const secondaryColor = Color.fromRGBO(41, 45, 46, 1);
const _secureStorage = FlutterSecureStorage();

class Hoster {
  final int videoId;
  final String title;
  final String thumbSrc;
  final String embed;

  Hoster({
    required this.videoId,
    required this.title,
    required this.thumbSrc,
    required this.embed,
  });

  factory Hoster.fromJson(Map<String, dynamic> json) {
    return Hoster(
      videoId: json['video_id'] ?? 0,
      title: json['title'] ?? 'Untitled',
      thumbSrc: json['thumb_src'] ?? 'assets/images/placeholder.jpg',
      embed: json['embed'] ?? '',
    );
  }
}

class HosterListPage extends StatefulWidget {
  const HosterListPage({super.key});

  @override
  _HosterListPageState createState() => _HosterListPageState();
}

class _HosterListPageState extends State<HosterListPage> {
  final int _selectedIndex = 0;
  late Future<List<Hoster>> _futureHosters;
  bool _isLoggedIn = false; // Simple boolean state

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _futureHosters = _fetchHosters();
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
      const HosterListPage(),
      const ProfilePage(),
    ];

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => pages[index]),
    );
  }

  Future<List<Hoster>> _fetchHosters() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.totomonkey.com/api/public/getAllHosters?page=1'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return List<Hoster>.from(
          jsonData['data'].map((hoster) => Hoster.fromJson(hoster)),
        );
      } else {
        throw Exception('Failed to load hosters');
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.grey,
        unselectedItemColor:
            Colors.grey, // Optionally, adjust unselected item color
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle),
            label: 'Reels',
            backgroundColor: secondaryColor,
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.sports_esports), label: 'Games'),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Wallet',
            backgroundColor: secondaryColor,
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: _onItemTapped,
      ),
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Red Container (Placeholder for any section)
            Container(
              padding: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 5),
              child: GestureDetector(
                onTap: () => {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AffiliatePage()),
                  )
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/refer.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
            ),
            // const SizedBox(height: 10),
            Padding(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
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

            // Additional Container for Visual Effect Section
            Container(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              // height: 50,
              width: MediaQuery.of(context)
                  .size
                  .width, // Corrected way to get screen width
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Featured Hosters',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            // const SizedBox(height: 3),

            // Hoster Grid Section with Shimmer Effect while loading
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: FutureBuilder<List<Hoster>>(
                future: _futureHosters,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: secondaryColor,
                          highlightColor: Colors.grey[300]!,
                          child: Container(
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final hosters = snapshot.data ?? [];
                  return GridView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(), // Prevent GridView from scrolling on its own
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: hosters.length,
                    itemBuilder: (context, index) {
                      final hoster = hosters[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  playVideoPage(videoUrl: hoster.embed),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  children: [
                                    // Network Image
                                    Image.network(
                                      hoster.thumbSrc,
                                      fit: BoxFit.cover,
                                      height: 85,
                                      width: double.infinity,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images/placeholder.jpg',
                                          fit: BoxFit.cover,
                                          height: 85,
                                          width: double.infinity,
                                        );
                                      },
                                    ),
                                    Positioned.fill(
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 5.0, sigmaY: 5.0),
                                        child: Container(
                                          color: Colors.black.withOpacity(0.1),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 25),
                                      child: Center(
                                        child: Icon(
                                          Icons.remove_red_eye,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  hoster.title,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
