import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:untitled1/models/login_state.dart'; // 로그인 상태 관리 모듈 경로에 맞게 수정

// Scaffold 없이 웹뷰만 표시하는 위젯
class InlineWebView extends StatefulWidget {
  final String url;
  const InlineWebView({Key? key, required this.url}) : super(key: key);

  @override
  State<InlineWebView> createState() => _InlineWebViewState();
}

class _InlineWebViewState extends State<InlineWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    final PlatformWebViewControllerCreationParams params =
    PlatformWebViewControllerCreationParams();
    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}

class TreatmentReservationScreen extends StatefulWidget {
  const TreatmentReservationScreen({super.key});

  @override
  State<TreatmentReservationScreen> createState() =>
      _TreatmentReservationScreenState();
}

class _TreatmentReservationScreenState extends State<TreatmentReservationScreen> {
  // 0: 방문병원, 1: 진료예약
  int _selectedIndex = 0;

  Widget _buildCustomButton({required String title, required int index}) {
    // 선택된 버튼은 cyan, 나머지는 grey
    Color buttonColor = _selectedIndex == index ? Colors.cyan : Colors.grey;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        width: 180,
        height: 40,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(0),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('진료예약')),
      body: Column(
        children: [
          // 상단 버튼 영역
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCustomButton(title: '방문병원', index: 0),
                const SizedBox(width: 0),
                _buildCustomButton(title: '진료예약', index: 1),
              ],

            ),

          ),
          // 하단 영역: 로그인 상태에 따라 다른 화면 표시
          Expanded(

            child: FutureBuilder<bool>(
              future: LoginStateManager().isLoggedIn(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  bool isLoggedIn = snapshot.data ?? false;
                  if (!isLoggedIn) {
                    // 로그인 안된 경우: 안내 메시지와 로그인 버튼 표시
                    return Center(
                      child: Column(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "로그인이 필요합니다",
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              // 로그인 화면으로 이동 (경로는 실제 라우팅에 맞게 수정)
                              Navigator.pushNamed(context, '/login');
                            },
                            child: const Text("로그인 하러가기"),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // 로그인 된 경우: 선택된 버튼에 따라 지정된 웹뷰 화면 표시
                    String url = _selectedIndex == 0
                        ? "http://210.121.223.5:11101/"
                        : "http://210.121.223.5:11101/Demo/Pages/Treatment/BaseAuth.html";
                    return InlineWebView(url: url);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
