import 'package:flutter/material.dart';
import 'dart:async';
import 'package:untitled1/screens/Lower_navigation_bar.dart';
import 'package:untitled1/screens/app_bar_screen.dart';
import 'app_constants.dart';
import 'screens/webview_screen.dart';
import 'screens/login_screen.dart';
import 'models/login_state.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 3초 후에 다음 화면으로 이동
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthCheckScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/android-compact-2.png'),
            fit: BoxFit.cover, // 이미지가 화면을 꽉 채우도록 설정
          ),
        ),
      ),
    );
  }
}

// 인증 상태를 확인하는 별도의 위젯
class AuthCheckScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
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
                    return MainScreen(); // 이메일이 저장되어 있으면 자동 로그인 성공
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
    );
  }
}