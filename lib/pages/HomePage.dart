import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'signin.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    List<int> list = [1, 2, 3, 4, 5];
    return Scaffold(
      appBar: AppBar(
        title: Text('Home', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 2.0,
        shadowColor: Colors.black,
        backgroundColor: Color.fromRGBO(41, 45, 46, 1),
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
      drawer: Drawer(
        // backgroundColor: Color.fromRGBO(41, 45, 46, 1),

        backgroundColor: Color.fromRGBO(35, 38, 38, 1),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
                padding: const EdgeInsets.only(
              top: 30.0,
              left: 15.0,
              right: 15.0,
              bottom: 10.0,
            )),
            ListTile(
              title: const Text('Home'),
              textColor: Colors.white,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Homepage()), // Example navigation to a "MenuPage"
                );
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              textColor: Colors.white,
              onTap: () {
                // Handle Item 2 tap
              },
            ),
          ],
        ),
      ),
      backgroundColor: Color.fromRGBO(35, 38, 38, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search Field
            Container(
              margin: EdgeInsets.only(
                top: 30,
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding:
                        const EdgeInsets.all(10), // Adjust padding for icon
                    child: SvgPicture.asset(
                      'assets/icons/search.svg',
                      color: Color.fromRGBO(255, 31, 104, 1.0),
                      height: 20, // Increased icon size for visibility
                      width: 20,
                    ),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      print('Search');
                    },
                    child: Container(
                      child: ElevatedButton(
                        onPressed: () {
                          print("object");
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          backgroundColor: Colors.white,
                          textStyle: const TextStyle(
                            color: Color.fromRGBO(255, 31, 104, 1),
                          ),
                        ),
                        child: const Text('Search'),
                      ),
                      padding: EdgeInsets.only(left: 10, right: 10),
                    ),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Placeholder for some content (like a banner or card)
            Container(
              // height: 300,
              margin: EdgeInsets.only(
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
                          child: Image.network(item, fit: BoxFit.cover),
                          // color: Color.fromRGBO(255, 31, 104, 1.0),
                          // color: Colors.amber[50],
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color.fromRGBO(41, 45, 46, 1)),
                          margin: EdgeInsets.only(left: 10, right: 10),
                        ))
                    .toList(),
              )),
            ),
            Container(
              // color: Colors.blue, // Set your desired background color here
              width: 1000,
              margin: const EdgeInsets.only(top: 10),
              padding: EdgeInsets.only(
                top: 8.0,
                left: 20.0,
                right: 8.0,
                bottom: 8.0,
              ), // Optional: add padding for better spacing
              child: Text(
                'Games',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // GridView of Posts
            Container(
              // padding: EdgeInsets.all(5.0), // Padding inside the container
              margin: EdgeInsets.only(
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
                    offset: Offset(0, 3), // Shadow position
                  ),
                ],
              ),

              child: GridView.builder(
                shrinkWrap: true, // Ensures GridView takes only necessary space
                physics:
                    NeverScrollableScrollPhysics(), // Disables scrolling inside GridView
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of columns
                  crossAxisSpacing: 10, // Spacing between columns
                  mainAxisSpacing: 10, // Spacing between rows
                  childAspectRatio: 0.8, // Adjust item height/width ratio
                ),
                itemCount: 12, // Number of grid items (posts)
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
                        image: DecorationImage(
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
                            style: TextStyle(
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
