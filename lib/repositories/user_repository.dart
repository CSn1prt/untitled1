// lib/repositories/user_repository.dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_settings.dart';

class UserRepository {
  Future<void> saveUserSettings(UserSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userSettings', json.encode(settings.toJson()));
  }

  Future<UserSettings> getUserSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString('userSettings');
    if (settingsJson != null) {
      return UserSettings.fromJson(json.decode(settingsJson));
    }
    return UserSettings(theme: 'light', notificationsEnabled: false);
  }
}