import 'package:flutter/material.dart';
import 'package:untitled1/screens/webview_screen.dart';

class AIConsultationScreen extends StatelessWidget {
  const AIConsultationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI 건강상담')),
      body:Padding(
        padding: const EdgeInsets.only(top: 100), // 위쪽 여백 추가
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCustomButton(
              context,
              title: '진료예약',
              color: Colors.cyan,
              onTap: () {

              },
            ),
            const SizedBox(height: 20),
            _buildCustomButton(
              context,
              title: 'AI 건강상담',
              color: Colors.grey,
              onTap: () {

              },
            ),
          ],
        ),
      ),
    );
  }
}


Widget _buildCustomButton(BuildContext context, {required String title, required Color color, required VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: 180, // 버튼 크기 조절
      height: 77,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(0), // 각진 모서리 (약간 둥글게)
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

