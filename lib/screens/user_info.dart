import 'package:flutter/material.dart';

class UserInfoScreen extends StatelessWidget {
  // 사용자 예시 (백엔드 연결 예정)
  final String userName = '홍길동';
  final String userEmail = 'johndoe@example.com';
  final String profileImageUrl =
      'https://via.placeholder.com/150'; // Placeholder image URL

  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('계정 정보'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit profile screen
              // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
            },
          ),
        ],
      ),
      body: Center(  // Center 위젯 추가
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Column을 내용 크기에 맞춤
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(profileImageUrl),
              ),
              const SizedBox(height: 20),

              // User Name
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // User Email
              Text(
                userEmail,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),

              // Edit Profile Button
              ElevatedButton(
                onPressed: () {
                  // Navigate to edit profile screen
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
                },
                child: const Text('프로필 편집'),
              ),
              const SizedBox(height: 10),

              // Logout Button
              OutlinedButton(
                onPressed: () {
                  // Handle logout logic
                  _showLogoutConfirmationDialog(context);
                },
                child: const Text('로그아웃'),
              ),
            ],
          ),
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
              onPressed: () {
                // Perform logout logic here
                // For example, clear user session and navigate to login screen
                Navigator.pop(context); // Close the dialog
                Navigator.pushReplacementNamed(context, '/login'); // Navigate to login screen
              },
              child: const Text('로그아웃'),
            ),
          ],
        );
      },
    );
  }
}