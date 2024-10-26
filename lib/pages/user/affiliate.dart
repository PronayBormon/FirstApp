import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const primaryColor = Color.fromRGBO(35, 38, 38, 1);
const secondaryColor = Color.fromRGBO(41, 45, 46, 1);

class AffiliatePage extends StatelessWidget {
  const AffiliatePage({super.key});

  @override
  Widget build(BuildContext context) {
    const double myAffiliateAmount = 150.0; // Sample amount
    const String affiliateLink = 'https://example.com/affiliate?ref=yourcode';

    // Sample list of affiliate users
    final List<Map<String, dynamic>> affiliateUsers = [
      {'name': 'User A', 'amount': 50.0, 'Reg_date': '2024-10-12'},
      {'name': 'User B', 'amount': 75.0, 'Reg_date': '2024-10-12'},
      {'name': 'User C', 'amount': 100.0, 'Reg_date': '2024-10-12'},
      {'name': 'User D', 'amount': 120.0, 'Reg_date': '2024-10-12'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Affiliate Earnings',
            style: TextStyle(color: mainColor)),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
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
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: Card(
                  color: secondaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(45.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Your Affiliate Earnings',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                        const SizedBox(height: 10),
                        Text('${myAffiliateAmount.toStringAsFixed(2)} Tokens',
                            style: const TextStyle(
                                color: mainColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 30),
                        const Text('Your Affiliate Link:',
                            style: TextStyle(color: Colors.white)),
                        const SizedBox(height: 5),
                        const Text(affiliateLink,
                            style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            _copyToClipboard(context, affiliateLink);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: mainColor),
                          child: const Text('Copy Link',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Affiliate User List
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                alignment: Alignment.centerLeft, // Align the text to the right
                child: const Text(
                  'Affiliate Users',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                  top: 0, bottom: 15, left: 15, right: 15),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: affiliateUsers.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5), // Margin between items
                        decoration: BoxDecoration(
                          color:
                              secondaryColor, // Background color for the item
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(2, 2), // Position of the shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            affiliateUsers[index]['name'],
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, // Align items on both ends
                            children: [
                              Text(
                                '${affiliateUsers[index]['amount']} Tokens',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              Text(
                                'Reg: ${affiliateUsers[index]['Reg_date']}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String link) {
    Clipboard.setData(ClipboardData(text: link)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Link copied to clipboard!',
                style: TextStyle(color: Colors.white))),
      );
    });
  }
}
