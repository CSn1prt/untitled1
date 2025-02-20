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

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final UserRepository _userRepository = UserRepository();
  UserSettings? _userSettings;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    print('initState SettingsScreen');
    _loadUserSettings();
  }

  Future<void> _loadUserSettings() async {
    final settings = await _userRepository.getUserSettings();
    setState(() {
      _userSettings = settings;
    });
  }

  Future<void> _saveUserSettings(UserSettings settings) async {
    await _userRepository.saveUserSettings(settings);
    _loadUserSettings();
  }

  // 웹뷰 관련 _controller 코드를 삭제합니다.
  // (원래 아래 코드는 웹뷰 전용이므로 제거)
  // Future<bool> _onWillPop() async {
  //   if (_controller != null && await _controller!.canGoBack()) {
  //     _controller!.goBack();
  //     return false;
  //   }
  //   return true;
  // }

  // 로딩 상태를 변경하는 콜백 함수
  void _setLoadingState(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Building SettingsScreen');
    return WillPopScope(
      onWillPop: () async {
        // 뒤로가기 시 MainScreen으로 전환
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
        return false; // 기본 pop 동작 방지
      },
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(), // 뒤로가기 버튼 강제 표시
          title: const Text('설정'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // 검색 액션 처리
              },
            ),
          ],
          flexibleSpace: Container(
            color: Colors.blue, // AppBar 뒤에 표시할 위젯
          ),
        ),
        body: FutureBuilder<UserSettings>(
          future: _userRepository.getUserSettings(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              _userSettings = snapshot.data;
              return ListView(
                children: [
                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  //   child: const Text(
                  //     '설정',
                  //     style: TextStyle(
                  //       fontSize: 24,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  ListTile(
                    title: const Text('계정 정보'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UserInfoScreen()),
                      );
                    },
                  ),
                  SwitchListTile(
                    title: const Text('다크 모드'),
                    value: _userSettings!.theme == 'dark',
                    onChanged: (value) {
                      final newSettings = UserSettings(
                        theme: value ? 'dark' : 'light',
                        notificationsEnabled: _userSettings!.notificationsEnabled,
                      );
                      _saveUserSettings(newSettings);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('알람 활성화'),
                    value: _userSettings!.notificationsEnabled,
                    onChanged: (value) {
                      final newSettings = UserSettings(
                        theme: _userSettings!.theme,
                        notificationsEnabled: value,
                      );
                      _saveUserSettings(newSettings);
                    },
                  ),
                  ListTile(
                    title: const Text('기기 접근 권한'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UserInfoScreen()),
                      );
                    },
                  ),
                  SwitchListTile(
                    title: const Text('자동 로그아웃 설정'),
                    value: _userSettings?.autoLogoutEnabled ?? false,
                    onChanged: (value) {
                      setState(() {
                        _userSettings = UserSettings(
                          theme: _userSettings!.theme,
                          notificationsEnabled: _userSettings!.notificationsEnabled,
                          autoLogoutEnabled: value,
                        );
                      });
                      _saveUserSettings(_userSettings!);
                    },
                  ),
                  ListTile(
                    title: const Text('알람 관리'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoadingScreen()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('즐겨찾기'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FavoritesListScreen()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('고객 센터'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () async {
                      final Uri telUri = Uri(
                        scheme: 'tel',
                        path: '1599-2745',
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
                      // 개인정보처리방침 보기 (예: 웹페이지 이동)
                    },
                    child: const Text(
                      '개인정보처리방침 보기',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('No data found'));
            }
          },
        ),
      ),
    );
  }
}
