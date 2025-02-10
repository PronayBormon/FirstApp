import 'package:flutter/material.dart';
import 'package:homepage_project/helper/constant.dart';
import 'package:homepage_project/pages/HomePage.dart';
import 'package:homepage_project/pages/authentication/signin.dart';
import 'package:homepage_project/pages/game_list.dart';
import 'package:homepage_project/pages/games.dart';
import 'package:homepage_project/pages/hoster-list.dart';
import 'package:homepage_project/pages/play-Game.dart';
import 'package:homepage_project/pages/reels.dart';
import 'package:homepage_project/pages/user/affiliate.dart';
import 'package:homepage_project/pages/user/deposit.dart';
import 'package:homepage_project/pages/user/profile.dart';
import 'package:homepage_project/pages/user/share.dart';
import 'package:homepage_project/pages/user/transections.dart';
import 'package:homepage_project/pages/user/wallet.dart';
import 'package:homepage_project/pages/user/withdraw.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquee/marquee.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _secureStorage = FlutterSecureStorage();

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const primaryColor = Color.fromRGBO(35, 38, 38, 1);
const secondaryColor = Color.fromRGBO(41, 45, 46, 1);
const pinkGradient = LinearGradient(
  colors: [
    Color.fromRGBO(228, 62, 229, 1),
    Color.fromRGBO(229, 15, 112, 1),
  ],
);

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

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<List<Game>> _futureGamess;
  final int _selectedIndex = 0;
  final String _selectedFilter = "All";
  bool _isLoggedIn = false; // Simple boolean state

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
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
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: secondaryColor,
                ),
                height: 150,
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  childAspectRatio: 1.35,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                  children: const [
                    _PageOptions(
                      icon: Icons.account_balance_wallet,
                      title: "Wallet",
                      page: WalletPage(),
                    ),
                    _PageOptions(
                      icon: Icons.download,
                      title: "Deposit",
                      page: DepositPage(),
                    ),
                    _PageOptions(
                      icon: Icons.upload,
                      title: "Withdraw",
                      page: WithdrawPage(),
                    ),
                    _PageOptions(
                      icon: Icons.history,
                      title: "Transection",
                      page: Transection(),
                    ),
                    _PageOptions(
                      icon: Icons.share,
                      title: "Share",
                      page: SharePage(),
                    ),
                    _PageOptions(
                      icon: Icons.group,
                      title: "Affiliate",
                      page: DepositPage(),
                    ),
                    _PageOptions(
                      icon: Icons.star,
                      title: "Bonus",
                      page: DepositPage(),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GamesPage(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width *
                              0.42, // 45% of screen width
                          height: 170,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: secondaryColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Stack(
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Games",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: mainColor,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Text(
                                      "Games",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 10,
                                  child: SizedBox(
                                    height: 70,
                                    child: Image.asset(
                                      'assets/images/game_play.gif',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const HosterListPage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: (MediaQuery.of(context).size.width *
                                              0.45 -
                                          10) /
                                      2, // Adjust width
                                  height: 85,
                                  margin: const EdgeInsets.only(
                                      right: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: secondaryColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        ClipOval(
                                          child: Image.asset(
                                            'assets/images/18ban.png',
                                            height: 40,
                                            width: 40,
                                          ),
                                        ),
                                        const Text(
                                          "Hosters",
                                          style: TextStyle(
                                            color: mainColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const GamesPage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: (MediaQuery.of(context).size.width *
                                              0.45 -
                                          10) /
                                      2, // Adjust width
                                  height: 85,
                                  margin: const EdgeInsets.only(bottom: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: secondaryColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        ClipOval(
                                          child: Image.asset(
                                            'assets/images/jili.png',
                                            height: 40,
                                            width: 40,
                                          ),
                                        ),
                                        const Text(
                                          "Jili games",
                                          style: TextStyle(
                                            color: mainColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const GamesPage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: (MediaQuery.of(context).size.width *
                                              0.45 -
                                          10) /
                                      2, // Adjust width
                                  height: 85,
                                  margin: const EdgeInsets.only(
                                      right: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: secondaryColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        ClipOval(
                                          child: Image.asset(
                                            'assets/images/pp.jpeg',
                                            height: 40,
                                            width: 40,
                                          ),
                                        ),
                                        const Text(
                                          "PP Games",
                                          style: TextStyle(
                                            color: mainColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const GamesPage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: (MediaQuery.of(context).size.width *
                                              0.45 -
                                          10) /
                                      2, // Adjust width
                                  height: 85,
                                  margin: const EdgeInsets.only(bottom: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: secondaryColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        ClipOval(
                                          child: Image.asset(
                                            'assets/images/pg.png',
                                            height: 40,
                                            width: 40,
                                          ),
                                        ),
                                        const Text(
                                          "PG Games",
                                          style: TextStyle(
                                            color: mainColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: 20,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/refferal.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageOptions extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget page; // Corrected: page should be a Widget, not a String

  const _PageOptions({
    super.key,
    required this.icon,
    required this.title,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page), // Corrected type
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return pinkGradient.createShader(bounds);
              },
              child: Icon(icon, size: 25, color: Colors.white),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              textAlign: TextAlign.center, // Align text to the center
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
