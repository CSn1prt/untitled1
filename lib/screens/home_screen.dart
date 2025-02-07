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
      appBar: AppBar(
        title: const Text('홈 화면'),
      ),
      body: Center(
        child: Column( // Use Column to hold multiple children
          mainAxisAlignment: MainAxisAlignment.center, // Center the Column vertically
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the LoadingScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoadingScreen()),
                );
              },
              child: const Text('로딩 스크린'),
            ),
            const SizedBox(height: 16), // Now this is fine
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text('로그인'),
            ),
            const SizedBox(height: 16), // Now this is fine
            ElevatedButton(
              onPressed: () {
                print("setting pressed");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
              child: const Text('설정'),
            ),
          ],
        ),
      ),
    );
  }
}