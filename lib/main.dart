import 'package:flutter/material.dart';
import 'package:untitled1/screens/Lower_navigation_bar.dart';
import 'package:untitled1/screens/app_bar_screen.dart';
import 'screens/webview_screen.dart';
import 'screens/login_screen.dart';
import 'models/login_state.dart';
import 'screens/main_screen.dart';
import 'package:untitled1/screens/main_screen.dart';


void main() {
  runApp(MyApp());
}



class MyApp extends StatelessWidget {

  // int _selectedIndex = 0;
  // bool _isLoading = false;
  // final List<Widget> _screens = [];
  //
  // void _onItemTapped(int index) {
  //   if (index < _screens.length) { // 잘못된 인덱스 방지
  //     setState(() {
  //       _selectedIndex = index;
  //     });
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: FutureBuilder<bool>(
        future: LoginStateManager().isLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')),
            );
          } else {
            final isLoggedIn = snapshot.data ?? false;
            if (isLoggedIn) {
              return FutureBuilder<String?>(
                future: LoginStateManager().getUserEmail(),
                builder: (BuildContext context, AsyncSnapshot<String?> userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return Scaffold(body: Center(child: CircularProgressIndicator()));
                  } else {
                    final userEmail = userSnapshot.data;
                    if (userEmail != null) {
                      return Scaffold(
                          body: MainScreen(),

                      );// 이메일이 저장되어 있으면 자동 로그인 성공
                    } else {
                      return LoginScreen(); // 로그인 정보 없음 -> 로그인 화면
                    }
                  }
                },
              );
            } else {
              return LoginScreen();
            }
          }
        },
      ),
    );
  }
}
