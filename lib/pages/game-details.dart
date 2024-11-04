import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GamesDetailPage extends StatelessWidget {
  final String slug;

  const GamesDetailPage({super.key, required this.slug});

  Future<List<dynamic>> fetchGamesByCategory() async {
    print('Fetching games for category slug: $slug');

    try {
      final response = await http.get(Uri.parse(
          'http://api.totomonkey.com/api/public/gameTypeWiseCategory/$slug'));

      // Print the response status code
      print('Response status: ${response.statusCode}');

      // Check if the request was successful
      if (response.statusCode == 200) {
        print('Response data: ${response.body}');
        final jsonResponse = json.decode(response.body);

        // Print the entire JSON response for debugging
        print('Full JSON response: $jsonResponse');

        // Check if the response indicates success
        if (jsonResponse['success']) {
          // Access the data field
          var data = jsonResponse['data'];
          print('Data field: $data'); // Print the data field

          // Ensure that data is indeed a List
          if (data is List) {
            return data; // Return the list directly
          } else {
            throw Exception(
                'Expected data to be a list but got ${data.runtimeType}');
          }
        } else {
          throw Exception('Failed to fetch games: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Failed to load games: ${response.statusCode}');
      }
    } catch (e) {
      // Log the error
      print('Error fetching games: $e');
      throw Exception('Error fetching games: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            '$slug Games',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: const Color.fromRGBO(41, 45, 46, 1),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchGamesByCategory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final games = snapshot.data!;

          return ListView.builder(
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              return ListTile(
                leading:
                    Image.network(game['imagepath'], width: 50, height: 50),
                title: Text(game['name']),
                onTap: () {
                  // Navigate to a detailed game page or perform an action
                },
              );
            },
          );
        },
      ),
      backgroundColor: const Color.fromRGBO(35, 38, 38, 1),
    );
  }
}
