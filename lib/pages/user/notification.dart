import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homepage_project/pages/HomePage.dart';
import 'package:homepage_project/pages/components/Sidebar.dart';
import 'package:homepage_project/pages/hoster-list.dart';
import 'package:homepage_project/pages/user/deposit.dart';
import 'package:homepage_project/pages/user/profile.dart';
import 'package:homepage_project/pages/user/transections.dart';
import 'package:homepage_project/pages/user/wallet.dart';
import 'package:homepage_project/pages/user/withdraw.dart';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const primaryColor = Color.fromRGBO(35, 38, 38, 1);
const secondaryColor = Color.fromRGBO(41, 45, 46, 1);

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int _selectedIndex = 3;

  final List<Map<String, String>> notifications = [
    {
      'title': 'New message from John',
      'date': '5 minutes ago',
      'details':
          'You have received a new message from John. Check your inbox for more details.',
    },
    {
      'title': 'Your withdrawal was successful',
      'date': '10 minutes ago',
      'details':
          'Your withdrawal request has been processed successfully. The funds are now in your account.',
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation logic
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Homepage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WalletPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HosterListPage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
        break;
    }
  }

  void _showNotificationDetails(
      BuildContext context, String title, String details) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            NotificationDetailPage(title: title, details: details),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(color: mainColor)),
        centerTitle: true,
        elevation: 2.0,
        shadowColor: Colors.black,
        backgroundColor: const Color.fromRGBO(41, 45, 46, 1),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
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
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
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
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Notifications',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _showNotificationDetails(
                        context,
                        notifications[index]['title']!,
                        notifications[index]['details']!),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          notifications[index]['title']!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          notifications[index]['date']!,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationDetailPage extends StatelessWidget {
  final String title;
  final String details;

  const NotificationDetailPage(
      {super.key, required this.title, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: mainColor)),
        backgroundColor: secondaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(color: Colors.white, fontSize: 24)),
            const SizedBox(height: 20),
            Text(details,
                style: const TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
