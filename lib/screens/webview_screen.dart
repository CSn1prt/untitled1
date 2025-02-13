import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class WebViewScreen extends StatefulWidget {
  final String url;

  const WebViewScreen({Key? key, required this.url}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  WebViewController? _controller; // ✅ null safety 적용
  bool isLoading = true; // ✅ 로딩 상태 추가

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      _initializeWebView(widget.url); // ✅ URL을 인자로 전달
    });
  }

  Future<void> _initializeWebView(String url) async {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // ✅ JavaScript 허용
      ..setUserAgent(
          "Mozilla/5.0 (Linux; Android 10; SM-G973N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.92 Mobile Safari/537.36"
      ) // ✅ 크롬처럼 인식
      ..loadRequest(Uri.parse('http://210.121.223.5:11101/Demo/Pages/HealthInfo/index_group1.html')) // ✅ URL을 함수 내에서 처리
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true; // ✅ 페이지 로드 시작 시 로딩 표시
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false; // ✅ 페이지 로드 완료되면 로딩 상태 해제
            });
          },
        ),
      );

    setState(() {
      _controller = controller; // ✅ 컨트롤러 초기화 완료
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          // ✅ WebView가 초기화되지 않았다면 로딩 화면만 보여줌
          if (_controller == null)
            Center(child: CircularProgressIndicator()) // ✅ WebView가 준비될 때까지 로딩 화면 표시
          else
            WebViewWidget(controller: _controller!), // ✅ WebView가 준비되면 렌더링

          // ✅ WebView가 로드 중일 때 추가적인 로딩 인디케이터 표시
          if (isLoading)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white.withOpacity(0.7), // ✅ 배경을 반투명하게 설정
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}
