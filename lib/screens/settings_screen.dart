// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:untitled1/screens/navigation_bar_screen.dart';
import '../screens/webview_screen.dart';
import '../models/user_settings.dart';
import '../repositories/user_repository.dart';
import 'Lower_navigation_bar.dart';
import 'app_bar_screen.dart';
import 'favorites_list_screen.dart';
import 'loading_screen.dart';
import 'user_info.dart';
import '../models/login_state.dart';



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
          // 예: 홈 화면으로 보내기
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>MainScreen(),),
          );
          return false; // pop 동작 방지
        },
        child:
         Scaffold(
      appBar: CustomAppBar(),
      // appBar: AppBar(
      //   leading: BackButton(),  // 뒤로가기 버튼 강제 표시
      //   title: const Text('설정'),
      // ),

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
                // 제목 추가
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: const Text(
                    '설정',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),


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
                  value: _userSettings?.autoLogoutEnabled ?? false, // 실제 설정 값 사용
                  onChanged: (value) {
                    setState(() {
                      _userSettings = UserSettings(
                        theme: _userSettings!.theme,
                        notificationsEnabled: _userSettings!.notificationsEnabled,
                        autoLogoutEnabled: value, // 자동 로그아웃 설정 업데이트
                      );


                    }

                    );
                    _saveUserSettings(_userSettings!);
                  },
                ),
                ListTile(
                  title: const Text('알람 관리'),
                  trailing: const Icon(Icons.arrow_forward_ios), // Optional: Add a navigation icon
                  onTap: () {
                    // Navigate to the LoadingScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoadingScreen()),
                    );
                  },
                ),
                //const SizedBox(height: 16), // Now this is fine

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
                //const SizedBox(height: 16), // Now this is fine

                ListTile(
                  title: const Text('고객 센터'),
                  trailing: const Icon(Icons.arrow_forward_ios), // Optional: Add a navigation icon
                  onTap: () {
                    // Navigate to the LoadingScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoadingScreen()),
                    );
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
