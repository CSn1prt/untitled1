import 'package:flutter/material.dart';
import 'package:untitled1/screens/navigation_bar_screen.dart';
import 'package:untitled1/screens/login_screen.dart';
import 'package:untitled1/models/login_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: FutureBuilder<bool>(
        future: LoginStateManager().isLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')),
            );
          } else {
            final isLoggedIn = snapshot.data ?? false;
            return isLoggedIn ? const MainScreen() : const LoginScreen();
          }
        },
      ),
    );
  }
}
