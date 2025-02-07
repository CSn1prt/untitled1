// lib/models/user_settings.dart

class UserSettings {
  final String theme;
  final bool notificationsEnabled;

  UserSettings({required this.theme, required this.notificationsEnabled});

  // JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'theme': theme,
      'notificationsEnabled': notificationsEnabled,
    };
  }

  // JSON에서 객체로 변환
  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      theme: json['theme'],
      notificationsEnabled: json['notificationsEnabled'],
    );
  }
}