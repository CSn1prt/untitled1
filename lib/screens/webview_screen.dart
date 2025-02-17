import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool isLoading = true;
  bool isFavorite = false;
  final FavoritesRepository _favoritesRepository = FavoritesRepository();

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
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (await _controller?.canGoBack() ?? false) {
                _controller?.goBack();
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
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
            if (isLoading)
              const FullScreenSplash(),
          ],
        ),
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