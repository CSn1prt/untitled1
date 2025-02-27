import 'package:flutter/material.dart';
import '../screens/login_screen.dart'; // Import your LoginScreen

class LoggedOutScreen extends StatelessWidget {
  const LoggedOutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logged Out'),
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You are logged out.',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the login screen
                LoginScreen();
              },
              child: const Text('Log In'),
            ),
            // Optional: Add a Sign Up button here
          ],
        ),
      ),
    );
  }
}