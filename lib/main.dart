import 'package:flutter/material.dart';
import 'package:untitled1/screens/navigation_bar_screen.dart';
import 'package:untitled1/screens/login_screen.dart';
import 'package:untitled1/models/login_state.dart';
import 'utils/user_activity_listner.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light, // 기본 테마 (라이트 모드)
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark, // 다크 모드 지원
      ),
      themeMode: ThemeMode.system, // 시스템 설정에 따라 다크/라이트 모드 자동 변경
      home: UserActivityListener(
        enableListener: false, // 자동 로그아웃 기능 활성화
        child: FutureBuilder<bool>(
          future: LoginStateManager().isLoggedIn(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen(); // 스플래시 화면 추가
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
      ),
      // 사용자가 `go_router` 같은 네비게이션을 원한다면 `MaterialApp.router` 사용 가능
      // routerConfig: appRouter, // 네비게이션 관리 시
    );
  }
}