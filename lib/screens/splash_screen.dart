import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 일정 시간 후 홈 화면으로 이동
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경색 설정
      body: Center(
        child: Image.asset(
          'assets/images/__siteIcon__.png', // 지정한 로고 이미지
          width: 150, // 원하는 크기로 조정
          height: 150,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
