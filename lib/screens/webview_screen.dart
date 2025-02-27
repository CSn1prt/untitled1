import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/app_constants.dart';
import 'package:untitled1/screens/settings_screen.dart';
import '../repositories/favorites_repository.dart';
import 'Lower_navigation_bar.dart';
import 'app_bar_screen.dart';
import 'menu_screen.dart';
import 'splash_screen.dart';
import 'menu_screen.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final bool showFloatingButton;
  final Function(bool) onLoadingChanged; // 로딩 상태 변경 콜백

  const WebViewScreen({
    Key? key,
    required this.url,
    required this.onLoadingChanged,
    this.showFloatingButton = true, // 기본값 true
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
  bool _showSpeechBubble = false; // 초기에는 숨김 상태로 시작
  Timer? _speechBubbleTimer;

  // 로딩 상태를 변경하는 콜백 함수
  void _setLoadingState(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  @override
  void initState() {
    super.initState();
    // 웹뷰 화면 진입 후 3초 후 말풍선을 표시
    _speechBubbleTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showSpeechBubble = true;
          print("말풍선 상태 변경: $_showSpeechBubble"); // 디버깅용
        });

        // 10초 후에 말풍선 자동 숨김
        Timer(const Duration(seconds: 10), () {
          if (mounted) {
            setState(() {
              _showSpeechBubble = false;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _speechBubbleTimer?.cancel();
    super.dispose();
  }

  void _onItemTapped(int index) {
    // 기존 코드 유지
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
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const SettingsScreen()),
        // );
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

  // Future<bool> _handleWillPop() async {
  //   final currentUrl = await _controller?.currentUrl();
  //   // A 사이트의 하위 페이지 URL에 대한 식별자 예시 (예: 특정 쿼리스트링, 경로 등)
  //   if (currentUrl != null && currentUrl.contains("sub_item_identifier")) {
  //     // A 사이트 메인 페이지 URL로 강제 로드
  //     _controller!.loadRequest(Uri.parse("http://210.121.223.5:11101/"));
  //     return false; // 뒤로가기 대신 부모 페이지 로드
  //   }
  //   if (await _controller!.canGoBack()) {
  //     _controller!.goBack();
  //     return false;
  //   }
  //   return true;
  // }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await _controller!.canGoBack()) {
          _controller?.goBack();
          return false; // 앱 전체 종료 대신 웹뷰 내에서 뒤로가기 수행
        }
        return true;
      },
      child: Scaffold(
        floatingActionButton: widget.showFloatingButton
            ? Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: Stack(
            alignment: Alignment.bottomRight,
            clipBehavior: Clip.none, // 중요: 말풍선이 Stack 경계를 넘어갈 수 있도록 함
            children: [
              FloatingActionButton(
                backgroundColor: Colors.blue,
                elevation: 4,
                onPressed: () {
                  // AI 챗봇 웹뷰로 이동 (FloatingButton 클릭)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewScreen(
                        url:
                            AppConstants.aiChatUrl,
                        onLoadingChanged: _setLoadingState,
                        showFloatingButton: false, // 챗봇 웹뷰에서는 버튼 숨김
                      ),
                    ),
                  );
                },
                child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
              ),
              if (_showSpeechBubble)
                Positioned(
                  right: 70,
                  bottom: 10,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        // 말풍선 클릭 시 챗봇 웹뷰로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WebViewScreen(
                              url:
                              AppConstants.aiChatUrl,
                              onLoadingChanged: _setLoadingState,
                              showFloatingButton: false, // 챗봇 웹뷰에서는 버튼 숨김
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        child: Row(
                          children: [
                            const Text(
                              AppConstants.speechBubbleMessage,
                              style: TextStyle(fontSize: 12, color: Colors.black),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showSpeechBubble = false;
                                });
                              },
                              child: const Icon(Icons.close, size: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        )
            : null, // showFloatingButton이 false이면 FloatingButton 숨김

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
            if (isLoading) WaitingScreen(), // 로딩 화면 표시
          ],
        ),
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
              AppConstants.pleaseWait,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}