import 'package:flutter/material.dart';
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
              title: const Text('로그아웃'),
              trailing: const Icon(Icons.arrow_forward_ios), // Optional: Add a navigation icon
              onTap: () {
                // Navigate to the LoadingScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
            const SizedBox(height: 16), // Now this is fine
            ListTile(
              title: const Text('알람 관리'),
              trailing: const Icon(Icons.arrow_forward_ios), // Optional: Add a navigation icon
              onTap: () {
                // Navigate to the LoadingScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoadingScreen()),
                );
              },
            ),
            const SizedBox(height: 16), // Now this is fine

            ListTile(
              title: const Text('즐겨찾기'),
              trailing: const Icon(Icons.arrow_forward_ios), // Optional: Add a navigation icon
              onTap: () {
                // Navigate to the LoadingScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoadingScreen()),
                );
              },
            ),
            const SizedBox(height: 16), // Now this is fine
            ListTile(
              title: const Text('고객 센터'),
              trailing: const Icon(Icons.arrow_forward_ios), // Optional: Add a navigation icon
              onTap: () {
                // Navigate to the LoadingScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoadingScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}