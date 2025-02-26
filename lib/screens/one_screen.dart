import 'package:flutter/material.dart';
import 'webview_screen.dart'; // 프로젝트 내 WebViewScreen 경로를 import

class OneScreen extends StatelessWidget {
  const OneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 상단 앱바
      appBar: AppBar(
        title: const Text('OneScreen'),
      ),
      // 전체 세로 레이아웃
      body: Column(
        children: [
          // (1) 상단 배너
          Container(
            width: double.infinity,
            height: 150, // 원하는 높이
            decoration: BoxDecoration(
              color: Colors.blue[100],
              image: const DecorationImage(
                image: NetworkImage('https://via.placeholder.com/600x300'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              color: Colors.black.withOpacity(0.3),
              child: const Text(
                'Visual Agent가\n쉽고 빠르게 도와 드려요.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // (2) PNG 이미지가 들어간 버튼 박스 3개
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                // 첫 번째 박스
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // TODO: 원하는 동작
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('진료예약 탭됨')),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 4.0),
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      // PNG + 텍스트를 세로 정렬
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/box1.png',
                            width: 36,
                            height: 36,
                          ),
                          const SizedBox(height: 4),
                          const Text('진료예약'),
                        ],
                      ),
                    ),
                  ),
                ),
                // 두 번째 박스
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // TODO: 원하는 동작
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('AI 건강상담 탭됨')),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/box2.png',
                            width: 36,
                            height: 36,
                          ),
                          const SizedBox(height: 4),
                          const Text('AI 건강상담'),
                        ],
                      ),
                    ),
                  ),
                ),
                // 세 번째 박스
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // TODO: 원하는 동작
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('기타 기능 탭됨')),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 4.0),
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/box3.png',
                            width: 36,
                            height: 36,
                          ),
                          const SizedBox(height: 4),
                          const Text('기타 기능'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // (3) 웹뷰를 아래에 확장
          // Expanded(
          //   child: WebViewScreen(
          //     url: 'http://210.121.223.5:11101/',11101
          //   ),
          // ),
        ],
      ),
    );
  }
}
