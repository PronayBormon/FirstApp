import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:homepage_project/pages/HomePage.dart';
import 'package:homepage_project/pages/hoster-list.dart';
import 'package:homepage_project/pages/user/profile.dart';
import 'package:homepage_project/pages/user/wallet.dart';
import './components/Sidebar.dart';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

class GamesPage extends StatefulWidget {
  const GamesPage({super.key});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamesPage> {
  int _selectedIndex = 1; // Default to Home

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
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Games',
            style: TextStyle(
              color: mainColor,
            )),
        centerTitle: true,
        elevation: 2.0,
        shadowColor: Colors.black,
        backgroundColor: const Color.fromRGBO(41, 45, 46, 1),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Uncomment to enable back function
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
      // Drawer here
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
        child: Column(
          children: [
            //like a banner or card
            Container(
              // height: 300,
              margin: const EdgeInsets.only(
                top: 30,
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black12,
              ),
              child: Center(
                  child: CarouselSlider(
                options: CarouselOptions(),
                items: imgList
                    .map((item) => Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromRGBO(41, 45, 46, 1)),
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: Image.network(item, fit: BoxFit.cover),
                        ))
                    .toList(),
              )),
            ),
            const ContainerTitle(title: 'Games'),

            Container(
              // color: Colors.white, // Set the background color of the container
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              padding: const EdgeInsets.only(
                top: 5.0,
                bottom: 5.0,
                left: 20.0,
                right: 20.0,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Allow horizontal scrolling
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _allItems('all'),
                    const SizedBox(width: 5),
                    // You can add more items here if needed
                    _allItems('Casino'),
                    const SizedBox(width: 5),
                    // You can add more items here if needed
                    _allItems('Hoster'),
                    const SizedBox(width: 5),
                    // You can add more items here if needed
                    _allItems('Live'),
                    const SizedBox(width: 5),
                    // You can add more items here if needed
                    _allItems('Auto Roletee'),
                    const SizedBox(width: 5),
                    // You can add more items here if needed
                    _allItems('Teenpatti'),
                    const SizedBox(width: 5),
                    // You can add more items here if needed
                    _allItems('Soccer'),
                    const SizedBox(width: 5),
                    // You can add more items here if needed
                    _allItems('Live'),
                    const SizedBox(width: 5),
                    // You can add more items here if needed
                  ],
                ),
              ),
            ),

            // GridView of Posts
            Container(
              // padding: EdgeInsets.all(5.0), // Padding inside the container
              margin: const EdgeInsets.only(
                top: 5,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              decoration: BoxDecoration(
                // color: Colors.white, // Container background color
                borderRadius: BorderRadius.circular(20), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 3), // Shadow position
                  ),
                ],
              ),

              child: GridView.builder(
                shrinkWrap: true, // Ensures GridView takes only necessary space
                physics:
                    const NeverScrollableScrollPhysics(), // Disables scrolling inside GridView
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of columns
                  crossAxisSpacing: 5, // Spacing between columns
                  mainAxisSpacing: 5, // Spacing between rows
                  childAspectRatio: 0.8, // Adjust item height/width ratio
                ),
                itemCount: 102, // Number of grid items (posts)
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Define action on post tap (e.g., navigate to a detailed view)
                      print("Post $index tapped!");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            Colors.blueAccent[100], // Color for each post card
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                          image: NetworkImage(
                              'https://via.placeholder.com/150'), // Placeholder image
                          fit: BoxFit
                              .cover, // Cover the whole container with the image
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Post #$index', // Placeholder text for each post
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _allItems(String catName) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      elevation: 2,
      backgroundColor: Colors.teal, // Use 'backgroundColor' for Flutter 2.5+
    ),
    onPressed: () {
      // Add your onPressed function here
    },
    child: Text(
      catName,
      style: const TextStyle(color: Colors.white),
    ),
  );
}

class ContainerTitle extends StatelessWidget {
  final String title;

  const ContainerTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(
        top: 8.0,
        left: 20.0,
        right: 20.0,
        bottom: 1.0,
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: mainColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
