import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/login_screen.dart';

/// ✅ 전역적으로 사용자 입력을 감지하고 자동 로그아웃을 처리하는 위젯
class UserActivityListener extends StatefulWidget {
  final Widget child;
  const UserActivityListener({Key? key, required this.child}) : super(key: key);

  @override
  _UserActivityListenerState createState() => _UserActivityListenerState();
}

class _UserActivityListenerState extends State<UserActivityListener> {
  Timer? _logoutTimer;
  static const Duration timeoutDuration = Duration(minutes: 10);

  @override
  void initState() {
    super.initState();
    _resetLogoutTimer();
    _startListeningForUserActivity();
  }

  /// ✅ 타이머를 리셋하여 자동 로그아웃을 연장
  Future<void> _resetLogoutTimer() async {
    _logoutTimer?.cancel();
    _logoutTimer = Timer(timeoutDuration, _handleAutoLogout);
  }

  /// ✅ 자동 로그아웃 처리
  void _handleAutoLogout() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  /// ✅ 사용자 입력 감지 (터치, 키보드 입력, 앱 복귀)
  void _startListeningForUserActivity() {
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(resumeCallBack: _resetLogoutTimer),
    );

    // 터치 감지 (모든 화면에서 감지)
    SystemChannels.textInput.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'TextInput.show') {
        _resetLogoutTimer();
      }
      return null;
    });
  }

  @override
  void dispose() {
    _logoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _resetLogoutTimer, // 터치 감지
      onPanDown: (_) => _resetLogoutTimer(), // 스크롤 감지
      child: widget.child,
    );
  }
}

/// ✅ 앱 생명 주기 감지 (백그라운드 → 복귀 시 타이머 리셋)
class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback? resumeCallBack;

  LifecycleEventHandler({this.resumeCallBack});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      resumeCallBack?.call();
    }
  }
}
