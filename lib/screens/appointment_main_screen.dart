import 'package:flutter/material.dart';
import 'treatment_reservation_screen.dart';
import 'ai_consultation_screen.dart';

class AppointmentMainScreen extends StatelessWidget {
  const AppointmentMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            // 상단에 두 버튼 배치
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCustomButton(
                context,
                title: '진료예약',
                color: Colors.purple,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TreatmentReservationScreen()),
                  );
                },
              ),
              const SizedBox(width: 0),  // 여기를 height에서 width로 변경
              _buildCustomButton(
                context,
                title: 'AI 상담',
                color: Colors.grey,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AIConsultationScreen()),
                  );
                },
              ),
            ],
          ),
        ]
      ),
      ),
    );
  }

  Widget _buildCustomButton(BuildContext context, {required String title, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 180, // 버튼 크기 조절
        height: 44,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(0), // 각진 모서리
          border: Border(
            bottom: BorderSide(
              color: color, // 텍스트 색상과 동일하게 설정
              width: 4, // 밑줄 두께 (원하는 값으로 조절)
            ),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style:  TextStyle(
            color: color, // 텍스트 색상
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

Widget _buildCustomButton_with_underline(BuildContext context, {required String title, required Color color, required VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: 180, // 버튼 크기 조절
      height: 35,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(0), // 각진 모서리 (약간 둥글게)
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
}