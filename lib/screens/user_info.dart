import 'package:flutter/material.dart';
import '../models/login_state.dart';
import 'login_screen.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: LoginStateManager().isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 로그인 상태 확인 중 로딩 표시
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData && snapshot.data == true) {
          // 사용자가 로그인 되어 있을 경우, 저장된 사용자 이메일을 불러옴
          return FutureBuilder<String?>(
            future: LoginStateManager().getUserEmail(), // 실제 저장된 이메일 호출
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              // 저장된 이메일이 없으면 기본값 사용
              String userEmail = userSnapshot.data ?? 'johndoe@example.com';
              // (이 부분에서 실제 사용자 이름이나 다른 정보도 함께 불러올 수 있음)
              return Scaffold(
                appBar: AppBar(
                  title: const Text('계정 정보'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // 프로필 편집 화면으로 이동하는 로직 추가
                      },
                    ),
                  ],
                ),
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 프로필 사진 (예시)
                        const CircleAvatar(
                          radius: 60,
                          backgroundImage:
                          NetworkImage('https://via.placeholder.com/150'),
                        ),
                        const SizedBox(height: 20),
                        // 사용자 이름 (현재는 고정값, 필요 시 동적으로 변경 가능)
                        const Text(
                          'AAA',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        // 저장된 사용자 이메일 표시
                        Text(
                          userEmail,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        // 프로필 편집 버튼
                        ElevatedButton(
                          onPressed: () {
                            // 프로필 편집 화면으로 이동하는 로직
                          },
                          child: const Text('프로필 편집'),
                        ),
                        const SizedBox(height: 10),
                        // 로그아웃 버튼
                        OutlinedButton(
                          onPressed: () {
                            _showLogoutConfirmationDialog(context);
                          },
                          child: const Text('로그아웃'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          // 로그인되어 있지 않은 경우, 로그인 화면으로 이동
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          });
          return const Scaffold();
        }
      },
    );
  }

  // 로그아웃 확인 다이얼로그
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
                Navigator.pop(context); // 다이얼로그 닫기
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                await LoginStateManager().setLoggedIn(false);
                Navigator.pop(context); // 다이얼로그 닫기
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text('로그아웃'),
            ),
          ],
        );
      },
    );
  }
}
