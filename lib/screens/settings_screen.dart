// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import '../screens/webview_screen.dart';
import '../models/user_settings.dart';
import '../repositories/user_repository.dart';
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

  @override
  Widget build(BuildContext context) {
    print('Building SettingsScreen');
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
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
                SwitchListTile(
                  title: const Text('계정 정보'),
                  value: false, // You no longer need to bind this to a setting
                  onChanged: (_) {
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
                SwitchListTile(
                  title: const Text('기기 접근 권한'),
                  value: _userSettings!.notificationsEnabled,
                  onChanged: (value)  {
                    final newSettings = UserSettings(
                      theme: _userSettings!.theme,
                          bluetoothEnabled: value,
                    );
                    _saveUserSettings(newSettings);
                  }


                ),
                TextButton(
                  onPressed: () {
                    // 웹페이지로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WebViewScreen(url: 'https://www.law.go.kr/%EB%B2%95%EB%A0%B9/%EA%B0%9C%EC%9D%B8%EC%A0%95%EB%B3%B4%EB%B3%B4%ED%98%B8%EB%B2%95'),
                      ),
                    );
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
    );
  }
}
