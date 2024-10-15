import 'dart:convert';
import 'package:homepage_project/pages/games.dart';

import '../model/category.dart';
import './components/Sidebar.dart';
import './games.dart'; // Import the GamesPage
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/flutter_svg.dart';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);

class AllCats extends StatefulWidget {
  const AllCats({super.key});

  @override
  _AllCatsState createState() => _AllCatsState();
}

class _AllCatsState extends State<AllCats> {
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    final String response =
        await rootBundle.loadString('assets/categories.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      categories = data.map((json) => Category.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories', style: TextStyle(color: mainColor)),
        centerTitle: true,
        elevation: 2.0,
        shadowColor: Colors.black,
        backgroundColor: Color.fromRGBO(41, 45, 46, 1),
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
      drawer: OffcanvasMenu(),
      backgroundColor: Color.fromRGBO(35, 38, 38, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ContainerTitle(title: 'All Categories'),
            ...categories.map((category) {
              return ExpansionTile(
                title:
                    Text(category.name, style: TextStyle(color: Colors.white)),
                children: (category.subcategories != null &&
                        category.subcategories!.isNotEmpty)
                    ? category.subcategories!.map((subcategory) {
                        return ListTile(
                          title: Text(subcategory.name,
                              style: TextStyle(color: Colors.white70)),
                          onTap: () {
                            // Navigate to GamesPage with subcategory name
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GamesPage(
                                  subcategoryName: subcategory.name,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList()
                    : [
                        ListTile(
                          title: Text('No Subcategories',
                              style: TextStyle(color: Colors.white70)),
                        ),
                      ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class ContainerTitle extends StatelessWidget {
  final String title;

  const ContainerTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(20.0),
      child: Text(
        title,
        style: TextStyle(
          color: mainColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
