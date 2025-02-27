import 'package:flutter/material.dart';
import 'treatment_reservation_screen.dart';
import 'ai_consultation_screen.dart';

class AppointmentMainScreen extends StatelessWidget {
  const AppointmentMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('진료예약 시스템')),
      body: Padding(
        padding: const EdgeInsets.only(top: 100), // 위쪽 여백 추가
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCustomButton(
              context,
              title: '진료예약',
              color: Colors.grey,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TreatmentReservationScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildCustomButton(
              context,
              title: 'AI 상담',
              color: Colors.blueGrey,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AIConsultationScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomButton(BuildContext context, {required String title, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 180, // 버튼 크기 조절
        height: 180,
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
}
