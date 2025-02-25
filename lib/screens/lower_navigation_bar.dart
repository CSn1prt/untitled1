import 'package:flutter/material.dart';
import 'menu_screen.dart';
import 'settings_screen.dart';
import 'app_bar_screen.dart';
import 'webview_screen.dart';

// 커스텀 BottomNavigationBar 위젯
class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_sharp),
          label: '진료예약',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: '메뉴',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '내 정보',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.blue[800],
      onTap: onItemTapped,
    );
  }
}