import 'dart:convert';

class Alarm {
  final String title;
  final String time;
  final bool isActive;

  Alarm({required this.title, required this.time, required this.isActive});

  // 🔹 JSON 변환을 위한 메서드 추가
  Map<String, dynamic> toJson() => {
    'title': title,
    'time': time,
    'isActive': isActive,
  };

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      title: json['title'],
      time: json['time'],
      isActive: json['isActive'],
    );
  }
}
