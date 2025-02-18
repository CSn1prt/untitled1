import 'package:flutter/material.dart';
import '../models/login_state.dart';
import 'login_screen.dart';

class UserInfoScreen extends StatefulWidget {
  //사용자 정보 백엔드 연결 예정
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    String? email = await LoginStateManager().getUserEmail();
    setState(() {
      userEmail = email ?? "이메일 없음";
    });
  }

  void _logout() async {
    await LoginStateManager().logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('계정 정보')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
            const SizedBox(height: 20),
            Text(
              userEmail ?? "이메일 로딩 중...",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () { _showLogoutConfirmationDialog(context);},
              child: const Text('로그아웃'),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to show a logout confirmation dialog
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('로그아웃'),
          content: const Text('정말로 로그아웃 하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                // Perform logout logic here
                // For example, clear user session and navigate to login screen
                Navigator.pop(context); // Close the dialog
                Navigator.pushReplacementNamed(context, '/login');
                await LoginStateManager().logout();
              },
              child: const Text('로그아웃'),
            ),
          ],
        );
      },
    );
  }

}


