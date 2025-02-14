// lib/models/user_settings.dart

import 'dart:convert';

class UserSettings {
  final String theme;
  final bool notificationsEnabled;
  final bool autoLogoutEnabled;

  UserSettings({
    required this.theme,
    required this.notificationsEnabled,
    this.autoLogoutEnabled = false
  });

  // JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'theme': theme,
      'notificationsEnabled': notificationsEnabled,
      'autoLogoutEnabled': autoLogoutEnabled, // 저장할 필드 추가
    };
  }

  // JSON에서 객체로 변환
  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      theme: json['theme'],
      notificationsEnabled: json['notificationsEnabled'],
      autoLogoutEnabled: json['autoLogoutEnabled'] as bool? ?? false, // 추가된 필드 반영
    );
  }
}