// lib/repositories/user_repository.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_settings.dart';
import 'package:permission_handler/permission_handler.dart';

class UserRepository {
  UserSettings? _userSettings;

  Future<void> saveUserSettings(UserSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userSettings', json.encode(settings.toJson()));
    _userSettings = settings; // 내부 상태 업데이트
  }

  Future<UserSettings> getUserSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString('userSettings');
      if (settingsJson != null) {
        _userSettings = UserSettings.fromJson(json.decode(settingsJson));
      } else {
        _userSettings = UserSettings(theme: 'light', notificationsEnabled: false);
      }
    } catch (e) {
      _userSettings = UserSettings(theme: 'light', notificationsEnabled: false);
      print('Error loading user settings: $e');
    }
    return _userSettings!;
  }

  //블루투스 등 기기 접근 권한 관리
  Future<void> _requestBluetoothPermission() async {
    final status = await Permission.bluetooth.request();

    bool bluetoothEnabled = status.isGranted;
    if (status.isPermanentlyDenied) {
      openAppSettings();
    }

    if (_userSettings != null) {
      final newSettings = UserSettings(
        theme: _userSettings!.theme,
        notificationsEnabled: _userSettings!.notificationsEnabled,
        //bluetoothEnabled: bluetoothEnabled,
      );
      await saveUserSettings(newSettings);
    }
  }
}
