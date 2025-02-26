import 'package:flutter/material.dart';
import 'package:untitled1/screens/appointment_main_screen.dart';
import 'package:untitled1/screens/one_screen.dart';
import 'package:untitled1/screens/treatment_reservation_screen.dart';
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
        url: 'http://210.121.223.5:11101/Demo/Pages/HealthInfo/index_app.html',
        onLoadingChanged: _setLoadingState, // 콜백 전달
      ),
      WebViewScreen(
        url: "http://210.121.223.5:11101/Demo/Pages/HealthInfo/index_app_reservation_1.html"
,
        onLoadingChanged: _setLoadingState, // 콜백 전달
      ),
      //'진료예약'으로 바뀔 예정
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
        isScrollControlled: true, // 오버레이의 높이를 조절할 수 있게 함
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Stack(
              clipBehavior: Clip.none, // 메뉴 박스 밖의 위치도 표시
              children: [
                // 메뉴 박스 바깥의 x 버튼
                // Positioned(
                //   top: -38, // 컨테이너 위쪽 밖으로 빼내기 위해 음수 값 사용
                //   right: 16, // 위치는 필요에 따라 조정
                //   child: InkWell(
                //     onTap: () {
                //       Navigator.pop(context);
                //     },
                //     child: Container(
                //       decoration: const BoxDecoration(
                //         color: Colors.grey,
                //         shape: BoxShape.circle,
                //       ),
                //       padding: const EdgeInsets.all(8),
                //       child: const Icon(
                //         Icons.close,
                //         size: 20,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // ),
           Padding(
            // 네비게이션 바 높이만큼의 하단 여백 추가
            padding: EdgeInsets.only(
              // bottom: kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom,
            ),
            //메뉴화면을 (네비게이션 바 + SafeArea) 높이만큼 올려주기
            child: Container(
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





                  // 닫기 버튼을 ListTile 형태로 커스터마이징
                  ListTile(
                    leading: const Icon(Icons.close, color: Colors.black),
                    title: const Text(
                      '닫기',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    tileColor: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
             const Divider(), // 메뉴와 닫기 버튼 사이에 구분선 추가

                  ListTile(
                    title: const Text('진료/검사 예약'),
                    onTap: () {
                      Navigator.pop(context); // 바텀 시트 닫기
                      setState(() {
                        _selectedIndex = 2; // 진료예약 탭으로 이동

                      });
                      _navigatorKeys[2].currentState!.push(
                        MaterialPageRoute(
                          builder: (context) => WebViewScreen(
                            url: 'http://210.121.223.5:11101/Main?PatientType=N',
                            onLoadingChanged: _setLoadingState,
                          ),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('진료상담/병원안내'),
                    onTap: () {
                      Navigator.pop(context); // 바텀 시트 닫기
                      setState(() {
                        _selectedIndex = 2; // 진료예약 탭으로 이동

                      });
                      _navigatorKeys[2].currentState!.push(
                        MaterialPageRoute(
                          builder: (context) => WebViewScreen(
                            url: "http://210.121.223.5:11101/Error/001?ReturnUrl=%2FHospitalInfo%2FSD%3FDHM%3D0%26CodeSeq%3D1",
                            onLoadingChanged: _setLoadingState,
                          ),
                        ),
                      );
                    },
                  ),
                  // 추가 메뉴 항목들...
                  ListTile(
                    title: const Text('건강검진 예약'),
                    onTap: () {
                      Navigator.pop(context); // 바텀 시트 닫기
                      setState(() {
                        _selectedIndex = 2; // 진료예약 탭으로 이동

                      });
                      _navigatorKeys[2].currentState!.push(
                        MaterialPageRoute(
                          builder: (context) => WebViewScreen(
                            url: 'http://210.121.223.5:11101/Demo/Pages/Treatment/BaseAuth.html',
                            onLoadingChanged: _setLoadingState,
                          ),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('증명서 발급'),
                    onTap: () {
                      Navigator.pop(context); // 바텀 시트 닫기
                      setState(() {
                        _selectedIndex = 2; // 진료예약 탭으로 이동

                      });
                      _navigatorKeys[2].currentState!.push(
                        MaterialPageRoute(
                          builder: (context) => WebViewScreen(
                            url: "https://clinic.mycerti.com/",
                            onLoadingChanged: _setLoadingState,
                          ),
                        ),
                      );
                    },
                  ),





                ],
              ),
            ),
          ),
          ],
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