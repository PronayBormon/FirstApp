import 'package:flutter/material.dart';
import 'package:homepage_project/pages/HomePage.dart';
import 'package:homepage_project/pages/components/Sidebar.dart';
import 'package:homepage_project/pages/games.dart';
import 'package:homepage_project/pages/==========hoster-profile.dart';
import 'package:homepage_project/pages/play-video.dart';
import 'package:homepage_project/pages/user/profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const primaryColor = Color.fromRGBO(35, 38, 38, 1);
const secondaryColor = Color.fromRGBO(41, 45, 46, 1);

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
  final List<Hoster> _hosters = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;
  final int _selectedIndex = 2;

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
    _fetchHosters(_currentPage);
  }

  Future<void> _fetchHosters(int page) async {
    if (_isLoading || page > _totalPages) return;
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(
      Uri.parse(
          'https://api.totomonkey.com/api/public/getAllHosters?page=$page'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        _hosters.addAll(List<Hoster>.from(
          jsonData['data'].map((hoster) => Hoster.fromJson(hoster)),
        ));
        _currentPage = jsonData['current_page'];
        _totalPages = jsonData['last_page'];
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load hosters');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hosters', style: TextStyle(color: mainColor)),
        centerTitle: true,
        backgroundColor: secondaryColor,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'assets/icons/chevron-left.svg',
              color: Colors.white,
              height: 25,
              width: 25,
            ),
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: SvgPicture.asset(
                'assets/icons/menu.svg',
                color: Colors.white,
                height: 25,
                width: 25,
              ),
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
          topLeft: Radius.circular(0.0),
          topRight: Radius.circular(0.0),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: mainColor,
          unselectedItemColor: Colors.black54,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.sports_esports), label: 'Games'),
            BottomNavigationBarItem(
                icon: Icon(Icons.play_circle), label: 'Hoster'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          onTap: _onItemTapped,
        ),
      ),
      backgroundColor: primaryColor,
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!_isLoading &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _fetchHosters(_currentPage + 1);
          }
          return false;
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: .9,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: _hosters.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _hosters.length) {
                return const Center(child: CircularProgressIndicator());
              }

              final hoster = _hosters[index];

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
                    borderRadius: BorderRadius.circular(10),
                    color: primaryColor,
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          hoster.thumbSrc,
                          height: 75,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/placeholder.jpg',
                              height: 75,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        hoster.title.isEmpty
                            ? 'No Title Available'
                            : hoster.title,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
