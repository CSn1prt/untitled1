import 'package:flutter/material.dart';
import 'package:untitled1/app_constants.dart';
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
          label: AppConstants.home,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_sharp),
          label: AppConstants.menu,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: AppConstants.treatment,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: AppConstants.userInfo,
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.blue[800],
      onTap: onItemTapped,
    );
  }
}