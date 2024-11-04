import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const primaryColor = Color.fromRGBO(35, 38, 38, 1);
const secondaryColor = Color.fromRGBO(41, 45, 46, 1);

class Video {
  final int videoId;
  final String title;
  final String thumbSrc;
  final String url;

  Video(
      {required this.videoId,
      required this.title,
      required this.thumbSrc,
      required this.url});

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      videoId: json['video_id'],
      title: json['title'],
      thumbSrc: json['thumb_src'],
      url: json['url'],
    );
  }
}

class VideoListPage extends StatefulWidget {
  const VideoListPage({Key? key}) : super(key: key);

  @override
  _VideoListPageState createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  late Future<List<Video>> _futureVideos;

  @override
  void initState() {
    super.initState();
    _futureVideos = fetchVideos();
  }

  Future<List<Video>> fetchVideos() async {
    final response = await http.get(
        Uri.parse('https://api.totomonkey.com/api/public/getMobileAllHosters'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body)['data'];
      return List<Video>.from(jsonData.map((video) => Video.fromJson(video)));
    } else {
      throw Exception('Failed to load videos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Videos', style: TextStyle(color: mainColor)),
        centerTitle: true,
        backgroundColor: secondaryColor,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset('assets/icons/chevron-left.svg',
                color: Colors.white, height: 25, width: 25),
          ),
        ),
      ),
      backgroundColor: primaryColor,
      body: FutureBuilder<List<Video>>(
        future: _futureVideos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final videos = snapshot.data!;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];

              return GestureDetector(
                onTap: () {
                  // You can navigate to the video detail page or open the video URL
                  // For now, we will just print the URL
                  print('Navigating to: ${video.url}');
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          video.thumbSrc,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                                child: Icon(Icons
                                    .error)); // Error icon if loading fails
                          },
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        video.title,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
