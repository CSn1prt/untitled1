// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:untitled1/screens/main_screen.dart';
import '../screens/webview_screen.dart';
import '../models/user_settings.dart';
import '../repositories/user_repository.dart';
import 'lower_navigation_bar.dart';
import 'app_bar_screen.dart';
import 'favorites_list_screen.dart';
import 'loading_screen.dart';
import 'user_info.dart';
import '../models/login_state.dart';
import 'package:url_launcher/url_launcher.dart';

void showFullScreenSettingsOverlay(BuildContext context) {
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned.fill(
      child: Material(
        color: Colors.black.withOpacity(0.5), // 반투명 배경 효과
        child: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                // 상단 타이틀 및 닫기 버튼
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
                          overlayEntry.remove();
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
                          overlayEntry.remove();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const UserInfoScreen()),
                          );
                        },
                      ),
                      SwitchListTile(
                        title: const Text('다크 모드'),
                        value: false, // 실제 상태 값과 연결
                        onChanged: (value) {
                          // 다크 모드 상태 업데이트
                        },
                      ),
                      SwitchListTile(
                        title: const Text('알람 활성화'),
                        value: false, // 실제 상태 값과 연결
                        onChanged: (value) {
                          // 알람 활성화 상태 업데이트
                        },
                      ),
                      // 추가 옵션들...
                      ListTile(
                        title: const Text('기기 접근 권한'),
                        onTap: () {
                          overlayEntry.remove();
                          // 권한 설정 화면으로 이동 또는 처리
                        },
                      ),
                      ListTile(
                        title: const Text('자동 로그아웃 설정'),
                        onTap: () {
                          // 자동 로그아웃 설정 처리
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Overlay.of(context)?.insert(overlayEntry);
}
