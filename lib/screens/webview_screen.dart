import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/favorites_repository.dart';

class WebViewScreen extends StatefulWidget {
  final String url;

  const WebViewScreen({Key? key, required this.url}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  InAppWebViewController? _controller;
  bool isLoading = true; // ✅ 로딩 상태 추가
  final FavoritesRepository _favoritesRepository = FavoritesRepository();
  //List<String> favorites = _favoritesRepository.getFavorites();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? url = (await _controller.getCurrentUrl()) as String?;
          if (url != null) {
            print('URL issss: $url');
            bool isAlreadyFavorite = await _favoritesRepository.isFavorite(url);
            //List<String> favorites = prefs.getStringList('favorites') ?? [];

            // 이전 스낵바 숨기기
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            if (!isAlreadyFavorite) {

              //favorites.add(url);
              await _favoritesRepository.addFavorite(url);
              //await prefs.setStringList('favorites', favorites);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('즐겨찾기에 추가되었습니다!')),
              );
            } else {
              //await _favoritesRepository.addFavorite(url);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('이미 즐겨찾기에 있습니다.')),
              );
            }
          }
        },
        child: Icon(Icons.bookmark),
      ),


      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.url)), // ✅ FIXED
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                javaScriptEnabled: true, // ✅ JavaScript 허용
                userAgent: "Mozilla/5.0 (Linux; Android 10; SM-G973N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.92 Mobile Safari/537.36",
              ),
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              _controller = controller;
            },
            onLoadStart: (controller, url) {
              setState(() {
                isLoading = true;
              });
            },
            onLoadStop: (controller, url) async {
              setState(() {
                isLoading = false;
              });
            },

          ),

          // ✅ WebView가 로드 중일 때 추가적인 로딩 인디케이터 표시
          if (isLoading)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white.withOpacity(0.7),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}

extension WebViewControllerExtensions on InAppWebViewController? {
  Future<WebUri?> getCurrentUrl() async {
    return this != null ? await this!.getUrl() : null;
  }
}