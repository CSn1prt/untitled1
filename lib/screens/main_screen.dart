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
      WebViewScreen(
        url: 'http://210.121.223.5:11101/Demo/Pages/Treatment/BaseAuth.html',
        onLoadingChanged: _setLoadingState, // 콜백 전달
      ), // 이건 나중에 '진료예약'으로 바뀔 예정
      const HomeScreen(),
      const UserInfoScreen()
    ]);
  }

  // Titles for each tab
  final List<String> _titles = ['홈', '진료예약', '메뉴', '내 정보'];

  void _onItemTapped(int index) {
    if (index == 2) { // 메뉴 버튼에 해당하는 인덱스
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent, // 투명 배경을 원한다면
        builder: (BuildContext context) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('진료/검사 예약'),
                  onTap: () {
                    Navigator.pop(context); // 모달 시트 닫기
                    // 예를 들어, '메뉴' 탭이 index 1이라고 가정
                    _navigatorKeys[1].currentState!.push(
                      MaterialPageRoute(
                        builder: (context) => WebViewScreen(
                          url: 'https://www.naver.com',
                          onLoadingChanged: _setLoadingState,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text('진로상담/병원안내'),
                  onTap: () {
                    // 메뉴 항목 2에 대한 동작 구현
                    Navigator.pop(context);
                  },
                ),
                // 추가 메뉴 항목들...
                ListTile(
                  title: const Text('건강검진 예약'),
                  onTap: () {
                    // 메뉴 항목 2에 대한 동작 구현
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('증명서 발급'),
                  onTap: () {
                    // 메뉴 항목 2에 대한 동작 구현
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('기타'),
                  onTap: () {
                    // 메뉴 항목 2에 대한 동작 구현
                    Navigator.pop(context);
                  },
                ),
                
              ],
            ),
          );
        },
      );
    } else {
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