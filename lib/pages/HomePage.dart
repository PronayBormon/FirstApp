import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:homepage_project/pages/components/Carousel_loading.dart';
import 'package:homepage_project/pages/hoster-list.dart';
import 'package:homepage_project/pages/user/profile.dart';
import 'package:homepage_project/pages/user/wallet.dart';
import 'games.dart';
import './components/Sidebar.dart';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const primaryColor = Color.fromRGBO(35, 38, 38, 1);
const secondaryColor = Color.fromRGBO(41, 45, 46, 1);
const pinkGradient = LinearGradient(
  colors: [Color.fromRGBO(228, 62, 229, 1), Color.fromRGBO(229, 15, 112, 1)],
);

final List<String> list = [
  'Item 1',
  'Item 2',
  'Item 3',
  'Item 4',
  'Item 5',
];

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation logic
    switch (index) {
      case 0:
        // Navigate to Wallet page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Homepage()),
        );
        break;
      case 1:
        // Stay on Homepage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GamesPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const HosterListPage()), // Example for Profile
        );
        break;
      case 3:
        // Navigate to Settings page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
        break;
      case 4:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2.0,
        shadowColor: Colors.black,
        backgroundColor: const Color.fromRGBO(41, 45, 46, 1),
        leading: GestureDetector(
          onTap: () {
            // Handle back action if needed
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/logo.png',
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
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: mainColor,
          unselectedItemColor: Colors.black54,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_esports),
              label: 'Games',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.play_circle),
              label: 'Model',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          onTap: _onItemTapped,
        ),
      ),
      backgroundColor: const Color.fromRGBO(35, 38, 38, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //like a banner or card
            Container(
              child: const SafeArea(child: CarouselLoading()),
            ),
          ],
        ),
      ),
    );
  }
}
