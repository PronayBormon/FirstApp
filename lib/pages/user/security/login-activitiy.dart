import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const primaryColor = Color.fromRGBO(35, 38, 38, 1);
const secondaryColor = Color.fromRGBO(41, 45, 46, 1);

class LoginActivityPage extends StatelessWidget {
  const LoginActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Activity', style: TextStyle(color: mainColor)),
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
        child: ListView.builder(
          itemCount: loginActivity.length,
          itemBuilder: (context, index) {
            return _loginActivityTile(loginActivity[index]);
          },
        ),
      ),
    );
  }

  Widget _loginActivityTile(LoginActivity activity) {
    return Card(
      color: secondaryColor,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${activity.date}',
                style: const TextStyle(color: Colors.white)),
            Text('Time: ${activity.time}',
                style: const TextStyle(color: Colors.white)),
            Text('Device: ${activity.device}',
                style: const TextStyle(color: Colors.white)),
            Text('Location: ${activity.location}',
                style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

// Sample login activity data
class LoginActivity {
  final String date;
  final String time;
  final String device;
  final String location;

  LoginActivity(
      {required this.date,
      required this.time,
      required this.device,
      required this.location});
}

// Sample data for demonstration
final List<LoginActivity> loginActivity = [
  LoginActivity(
      date: "2024-10-01",
      time: "10:00 AM",
      device: "iPhone 12",
      location: "New York, USA"),
  LoginActivity(
      date: "2024-10-02",
      time: "02:30 PM",
      device: "MacBook Pro",
      location: "California, USA"),
  LoginActivity(
      date: "2024-10-03",
      time: "11:15 AM",
      device: "Samsung Galaxy",
      location: "London, UK"),
  LoginActivity(
      date: "2024-10-04",
      time: "09:45 PM",
      device: "Windows PC",
      location: "Tokyo, Japan"),
];
