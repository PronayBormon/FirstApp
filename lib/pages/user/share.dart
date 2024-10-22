import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const primaryColor = Color.fromRGBO(35, 38, 38, 1);
const secondaryColor = Color.fromRGBO(41, 45, 46, 1);

class SharePage extends StatelessWidget {
  const SharePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Page', style: TextStyle(color: mainColor)),
        centerTitle: true,
        backgroundColor: secondaryColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset('assets/icons/chevron-left.svg',
                color: Colors.white, height: 25, width: 25),
          ),
        ),
      ),
      backgroundColor: primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const Text(
              'Earn up to 10 tokens for every registered user and 500 tokens for users who broadcast (broadcasters must earn 20.00 before they qualify).',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              'Please send to Chaturbate using one of the link codes below:',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            _buildLinkTile(
              context,
              title: 'Share Hasin052024\'s Cam',
              link:
                  'https://chaturbate.com/in/?tour=7Bge&campaign=HBrh8&track=default',
            ),
            _buildLinkTile(
              context,
              title: 'Share Chaturbate.com',
              link:
                  'https://chaturbate.com/in/?tour=OT2s&campaign=HBrh8&track=default',
            ),
            _buildLinkTile(
              context,
              title: 'Embed Hasin052024\'s Cam on Your Webpage',
              link:
                  "<iframe src='https://cbxyz.com/in/?tour=SHBY&campaign=HBrh8&track=embed&room=hasin052024' height='528' width='850' style='border: none;'></iframe>",
            ),
            _buildLinkTile(
              context,
              title: 'Embed Chaturbate\'s Top Cam on Your Webpage',
              link:
                  "<iframe src='https://cbxyz.com/in/?tour=SHBY&campaign=HBrh8&track=embed&room=hasin052024' height='528' width='850' style='border: none;'></iframe>",
            ),
            const SizedBox(height: 20),
            const Text(
              'See details about tokens earned in the affiliate program stats.',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkTile(BuildContext context,
      {required String title, required String link}) {
    return Card(
      color: secondaryColor,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(link, style: const TextStyle(color: Colors.grey)),
        trailing: IconButton(
          icon: const Icon(Icons.copy, color: mainColor),
          onPressed: () {
            _copyToClipboard(context, link);
          },
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String link) {
    Clipboard.setData(ClipboardData(text: link)).then((_) {
      // Show a snackbar to indicate that the link has been copied
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Successfully copied to clipboard!'),
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }
}
