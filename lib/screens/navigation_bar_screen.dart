import 'package:flutter/material.dart';
import 'package:untitled1/screens/user_info.dart';
//import '../screens/webview_screen.dart';
import 'menu_screen.dart';
import 'settings_screen.dart';
import 'app_bar_screen.dart';
import 'loading_screen.dart';
import 'webview_screen.dart';
import 'lower_navigation_bar.dart';
import 'splash_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _isLoading = false;
  //web view 의 로딩 상태를 상위 컴포넌트인 MainScreen로 이동

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  // 로딩 상태를 변경하는 콜백 함수
  void _setLoadingState(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      WebViewScreen(
        url: 'http://210.121.223.5:11101/',
        onLoadingChanged: _setLoadingState, // 콜백 전달
      ),
      const HomeScreen(),
      WebViewScreen(
        url: 'http://210.121.223.5:11101/Demo/Pages/Treatment/BaseAuth.html',
        onLoadingChanged: _setLoadingState, // 콜백 전달
      ), // 이건 나중에 '진료예약'으로 바뀔 예정
      const UserInfoScreen()
    ]);
  }

  // Titles for each tab
  final List<String> _titles = ['홈', '메뉴', '진료예약', '내 정보'];

  void _onItemTapped(int index) {
    if (index < _screens.length) { // 잘못된 인덱스 방지
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 로딩 중일 때는 SplashScreen만 표시
    if (_isLoading && _selectedIndex == 0) {
      return SplashScreen();
    }

    return Scaffold(
      appBar: CustomAppBar(), // Dynamic title
      body: WillPopScope(
        onWillPop: () async {
          final isFirstRouteInCurrentTab =
          !await _navigatorKeys[_selectedIndex].currentState!.maybePop();
          return isFirstRouteInCurrentTab;
        },
        child: IndexedStack(
          index: _selectedIndex,
          children: _screens.map((screen) {
            return Navigator(
              key: _navigatorKeys[_screens.indexOf(screen)],
              onGenerateRoute: (RouteSettings settings) {
                return MaterialPageRoute(
                  builder: (context) => screen,
                );
              },
            );
          }).toList(),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
      selectedIndex: _selectedIndex,
      onItemTapped: _onItemTapped,
      ),
    );
  }
}
