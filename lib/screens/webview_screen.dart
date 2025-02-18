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
  final Function(bool) onLoadingChanged; // 추가: 로딩 상태 변경 콜백

  const WebViewScreen({
    Key? key,
    required this.url,
    required this.onLoadingChanged, // 추가
  }) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  InAppWebViewController? _controller;
  bool isLoading = false;
  bool isFavorite = false;
  final FavoritesRepository _favoritesRepository = FavoritesRepository();
  int _selectedIndex = 0; // Add this

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate based on the selected index
    switch (index) {
      case 0:
      // Stay on current WebView
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
    if (_controller != null) {
      if (await _controller!.canGoBack()) {
        _controller!.goBack();
        return false;
      }
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
          child: FloatingActionButton(
            onPressed: () async {
              String? url = (await _controller?.getUrl())?.toString();
              if (url != null) {
                bool isAlreadyFavorite = await _favoritesRepository.isFavorite(url);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                if (!isAlreadyFavorite) {
                  await _favoritesRepository.addFavorite(url);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('즐겨찾기에 추가되었습니다!')),
                  );
                  setState(() {
                    isFavorite = true;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('이미 즐겨찾기에 있습니다.')),
                  );
                }
              }
            },
            child: Icon(isFavorite ? Icons.bookmark : Icons.bookmark_border),
          ),
        ),
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(widget.url)),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  javaScriptEnabled: true,
                  userAgent: "Mozilla/5.0 (Linux; Android 10; SM-G973N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.92 Mobile Safari/537.36",
                ),
              ),
              onWebViewCreated: (controller) => _controller = controller,
              onLoadStart: (controller, url) => setState(() => isLoading = true),
              onLoadStop: (controller, url) => setState(() => isLoading = false),
              onLoadError: (controller, url, code, message) => setState(() => isLoading = false),
            ),


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

// 전체 화면 스플래시 위젯 추가
class FullScreenSplash extends StatelessWidget {
  const FullScreenSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // 순수 흰색 배경
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