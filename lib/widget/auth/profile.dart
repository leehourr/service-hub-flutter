import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:service_hub/widget/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatelessWidget {
  const Profile({super.key, required this.name, required this.number});

  final String name;
  final String number;

  @override
  Widget build(BuildContext context) {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    var logger = Logger();

    void navigateToHome() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      );
    }

    Future<void> _signOut() async {
      try {
        final SharedPreferences prefs = await _prefs;
        await prefs.remove('jwt_token');
        navigateToHome();
      } catch (e) {
        logger.e('Error signing out: $e');
      }
    }

    // Mock data - Replace with actual data from token
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            color: Color.fromARGB(255, 221, 221, 221),
            height: .5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Circular black background with 'L' in the center
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  name[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // User info - Replace with data from token
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(number),

            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Account Settings',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Edit profile button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Add functionality for editing profile
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                label: const Text(
                  'Edit Profile',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),
            // const Spacer(),
            // Sign out clickable text
            GestureDetector(
              onTap: _signOut,
              child: const Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color:
                      Color.fromARGB(255, 122, 29, 141), // Customize the color
                ),
              ),
            ),
            const SizedBox(height: 8),

            // App version
            const Text(
              'Service Hub v1.0.0',
              style: TextStyle(fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }
}
