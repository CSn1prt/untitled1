import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/screens/settings_screen.dart';
import '../repositories/favorites_repository.dart';
import 'Lower_navigation_bar.dart';
import 'app_bar_screen.dart';
import 'menu_screen.dart';
import 'splash_screen.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final Function(bool) onLoadingChanged; // 로딩 상태 변경 콜백

  const WebViewScreen({
    Key? key,
    required this.url,
    required this.onLoadingChanged,
  }) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  InAppWebViewController? _controller;
  bool isLoading = false;
  bool isFavorite = false;
  final FavoritesRepository _favoritesRepository = FavoritesRepository();
  int _selectedIndex = 0;
  bool _showSpeechBubble = true; // 말풍선 표시 여부

  // 로딩 상태를 변경하는 콜백 함수
  void _setLoadingState(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  @override
  void initState() {
    super.initState();
    // 웹뷰 화면 진입 후 18초 후 말풍선을 표시
    Timer(const Duration(seconds: 4), () {
      setState(() {
        _showSpeechBubble = true;
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // 선택한 인덱스에 따라 화면 이동
    switch (index) {
      case 0:
      // 현재 웹뷰 유지
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SettingsScreen()),
        );
        break;
    }
  }

  Future<bool> _onWillPop() async {
    if (_controller != null && await _controller!.canGoBack()) {
      _controller!.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        // appBar: CustomAppBar(),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              FloatingActionButton(
                onPressed: () {
                  // AI 챗봇 웹뷰로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewScreen(
                        url:
                        'https://exona.kr/aichat/aichat_sjh01.html?tenantid=sjh01&tenantname=%EC%9D%B8%EC%B2%9C%EC%84%B8%EC%A2%85%EB%B3%91%EC%9B%90',
                        onLoadingChanged: _setLoadingState,
                      ),
                    ),
                  );
                },
                child: const Icon(Icons.chat_bubble_outline),
              ),
              // 18초 후 말풍선 표시
              if (_showSpeechBubble)
                Positioned(
                  right: 70, // FAB 옆에 위치 (필요시 값 조정)
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      '혹시 물어보실 것은 없으신가요?😊',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                ),
            ],
          ),
        ),
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(widget.url)),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  javaScriptEnabled: true,
                  userAgent:
                  "Mozilla/5.0 (Linux; Android 10; SM-G973N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.92 Mobile Safari/537.36",
                ),
              ),
              onWebViewCreated: (controller) => _controller = controller,
              onLoadStart: (controller, url) {
                setState(() {
                  isLoading = true;
                });
              },
              onLoadStop: (controller, url) {
                setState(() {
                  isLoading = false;
                });
              },
              onLoadError: (controller, url, code, message) {
                setState(() {
                  isLoading = false;
                });
              },
            ),
            // 로딩 중이면 WaitingScreen 표시
            if (isLoading) const WaitingScreen(),
          ],
        ),
        // bottomNavigationBar: CustomBottomNavigationBar(
        //   selectedIndex: _selectedIndex,
        //   onItemTapped: _onItemTapped,
        // ),
      ),
    );
  }
}

// 전체 화면 로딩 위젯
class WaitingScreen extends StatelessWidget {
  const WaitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // 흰색 배경
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              '잠시만 기다려주세요...',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
