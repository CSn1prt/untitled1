import 'package:flutter/material.dart';
import 'package:untitled1/screens/user_info.dart';

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
                        title: const Text('계정 정보'),
                        onTap: () {
                          widget.onClose();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const UserInfoScreen()),
                          );
                        },
                      ),
                      SwitchListTile(
                        title: const Text('다크 모드'),
                        value: false, // 실제 상태 값 연결 필요
                        onChanged: (value) {
                          // 다크 모드 변경 로직
                        },
                      ),
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
