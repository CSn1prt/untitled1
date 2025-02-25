import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled1/screens/user_info.dart';
import 'package:url_launcher/url_launcher.dart';

import 'favorites_list_screen.dart';

class FullScreenSettingsOverlay extends StatefulWidget {
  final VoidCallback onClose;
  const FullScreenSettingsOverlay({Key? key, required this.onClose})
      : super(key: key);

  @override
  _FullScreenSettingsOverlayState createState() => _FullScreenSettingsOverlayState();
}

class _FullScreenSettingsOverlayState extends State<FullScreenSettingsOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, 1), // 시작 위치: 화면 아래
      end: Offset.zero, // 최종 위치: 원래 위치(화면 채움)
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Material(
        color: Colors.black.withOpacity(0.5), // 반투명 배경
        child: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                // 헤더 영역 (타이틀 + 닫기 버튼)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '설정',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          _controller.reverse().then((value) {
                            widget.onClose();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                // 설정 옵션 리스트
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        title: const Text('기기 설정 권한'),
                        onTap: () async {
                          widget.onClose();


                          await openAppSettings();

                        },
                      ),
                      SwitchListTile(
                        title: const Text('다크 모드'),
                        value: false, // 실제 상태 값 연결 필요
                        onChanged: (value) {
                          // 다크 모드 변경 로직
                        },
                      ),

                      ListTile(
                        title: const Text('즐겨찾기'),
                        trailing: const Icon(Icons.arrow_forward_ios), // Optional: Add a navigation icon
                        onTap: () {
                          // Navigate to the LoadingScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FavoritesListScreen()),
                          );
                        },
                      ),

                      ListTile(
                        title: const Text('고객 센터'),
                        trailing: const Icon(Icons.arrow_forward_ios), // Optional: Add a navigation icon
                        onTap: () async {
                          final Uri telUri = Uri(
                            scheme: 'tel',
                            path: '1599-2745', // 실제 고객센터 전화번호로 변경하세요.
                          );
                          if (await canLaunchUrl(telUri)) {
                            await launchUrl(telUri);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("전화 연결을 할 수 없습니다.")),
                            );
                          }
                        },
                      ),

                      TextButton(
                        onPressed: () {
                          // 웹페이지로 이동
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const WebViewScreen(url: 'https://www.law.go.kr/%EB%B2%95%EB%A0%B9/%EA%B0%9C%EC%9D%B8%EC%A0%95%EB%B3%B4%EB%B3%B4%ED%98%B8%EB%B2%95', onLoadingChanged: false,),
                          //   ),
                          // );
                        },
                        child: const Text(
                          '개인정보처리방침 보기',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue, // 링크처럼 보이도록 설정
                          ),
                        ),
                      ),

                      //const SizedBox(height: 16),
                      //
                      //
                      // Now this is fine
                      //
                      // 추가 옵션들을 여기에 추가...
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showFullScreenSettingsOverlay(BuildContext context) {
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => FullScreenSettingsOverlay(
      onClose: () {
        overlayEntry.remove();
      },
    ),
  );

  Overlay.of(context)?.insert(overlayEntry);
}
