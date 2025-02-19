import 'package:flutter/material.dart';
import 'package:untitled1/screens/favorites_list_screen.dart';
import 'package:untitled1/screens/user_info.dart';
//import '../screens/settings_screen.dart';
import 'settings_screen.dart';
import 'loading_screen.dart';
import 'login_screen.dart';
import 'webview_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key}); // Add a constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column( // Use Column to hold multiple children
          //mainAxisAlignment: MainAxisAlignment.center, // Center the Column vertically
          children: [
            ListTile(
              title: const Text('로그인'),
              trailing: const Icon(Icons.arrow_forward_ios), // Optional: Add a navigation icon
              onTap: () {
                // Navigate to the LoadingScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserInfoScreen()),
                );
              },
            ),
            const SizedBox(height: 16), // Now this is fine




          ],
        ),
      ),
    );
  }
}