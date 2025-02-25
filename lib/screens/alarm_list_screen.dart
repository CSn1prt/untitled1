import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/alarm.dart';
import '../screens/main_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// FullScreenAlarmOverlay 위젯: 슬라이드 애니메이션과 함께 전체 화면 오버레이를 표시합니다.
class FullScreenAlarmOverlay extends StatefulWidget {
  final Alarm? existingAlarm;
  final ValueChanged<Alarm> onSave;
  final VoidCallback onClose;

  const FullScreenAlarmOverlay({
    Key? key,
    this.existingAlarm,
    required this.onSave,
    required this.onClose,
  }) : super(key: key);

  @override
  _FullScreenAlarmOverlayState createState() => _FullScreenAlarmOverlayState();
}

class _FullScreenAlarmOverlayState extends State<FullScreenAlarmOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late TextEditingController _titleController;
  late TextEditingController _timeController;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
        text: widget.existingAlarm != null ? widget.existingAlarm!.title : '');
    _timeController = TextEditingController(
        text: widget.existingAlarm != null ? widget.existingAlarm!.time : '');
    _isActive = widget.existingAlarm?.isActive ?? true;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, 1), // 시작: 화면 아래에서 시작
      end: Offset.zero, // 끝: 원래 위치
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _timeController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _closeOverlay() {
    _controller.reverse().then((value) {
      widget.onClose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Material(
        color: Colors.black.withOpacity(0.5),
        child: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                // 헤더: 타이틀과 닫기 버튼
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.existingAlarm == null ? '알림 추가' : '알림 수정',
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: _closeOverlay,
                      ),
                    ],
                  ),
                ),
                //본문: 알람 제목, 시간, 활성화 스위치
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            labelText: "알림 제목",
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _timeController,
                          decoration: const InputDecoration(
                            labelText: "시간",
                          ),
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile(
                          title: const Text("알림 활성화"),
                          value: _isActive,
                          onChanged: (value) {
                            setState(() {
                              _isActive = value;
                            });
                          },
                        ),

                        ElevatedButton(
                          onPressed: _triggerTestNotification,
                          child: const Text('알림 테스트'),
                        ),


                      ],
                    ),
                  ),
                ),
                // 액션 버튼: 취소 및 저장
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _closeOverlay,
                        child: const Text("취소"),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          if (_titleController.text.isNotEmpty &&
                              _timeController.text.isNotEmpty) {
                            Alarm newAlarm = Alarm(
                              title: _titleController.text,
                              time: _timeController.text,
                              isActive: _isActive,
                            );
                            widget.onSave(newAlarm);
                            _closeOverlay();
                          }
                        },
                        child: const Text("저장"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// AlarmListScreen에 적용하는 예시 코드
class AlarmListScreen extends StatefulWidget {
  const AlarmListScreen({Key? key}) : super(key: key);

  @override
  _AlarmListScreenState createState() => _AlarmListScreenState();
}

class _AlarmListScreenState extends State<AlarmListScreen> {
  List<Alarm> alarms = [];

  @override
  void initState() {
    super.initState();
    _loadAlarms();
  }

  // SharedPreferences에서 알람 목록 불러오기
  Future<void> _loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final String? alarmsJson = prefs.getString('alarms');

    if (alarmsJson != null) {
      setState(() {
        alarms = (json.decode(alarmsJson) as List)
            .map((item) => Alarm.fromJson(item))
            .toList();
      });
    }
  }

  // 알람 리스트를 SharedPreferences에 저장
  Future<void> _saveAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final String alarmsJson =
    json.encode(alarms.map((alarm) => alarm.toJson()).toList());
    await prefs.setString('alarms', alarmsJson);
  }

  // 오버레이로 알람 추가/수정 화면을 띄움
  void _addOrEditAlarm({Alarm? existingAlarm, int? index}) {
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => FullScreenAlarmOverlay(
        existingAlarm: existingAlarm,
        onSave: (newAlarm) {
          setState(() {
            if (existingAlarm == null) {
              alarms.add(newAlarm);
            } else {
              alarms[index!] = newAlarm;
            }
            _saveAlarms();
          });
        },
        onClose: () {
          overlayEntry.remove();
        },
      ),
    );

    Overlay.of(context)?.insert(overlayEntry);
  }

  void _deleteAlarm(int index) {
    setState(() {
      alarms.removeAt(index);
      _saveAlarms();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Building AlarmListScreen');
    return WillPopScope(
      onWillPop: () async {
        // 뒤로가기 시 MainScreen으로 전환
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: const Text('알람'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // 검색 액션 처리
              },
            ),
          ],
          flexibleSpace: Container(
            color: Colors.blue,
          ),
        ),
        body: ListView.builder(
          itemCount: alarms.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(
                alarms[index].isActive ? Icons.alarm_on : Icons.alarm_off,
                color: alarms[index].isActive ? Colors.green : Colors.red,
              ),
              title: Text(alarms[index].title),
              subtitle: Text(alarms[index].time),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () =>
                        _addOrEditAlarm(existingAlarm: alarms[index], index: index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteAlarm(index),
                  ),
                ],
              ),
              onTap: () =>
                  _addOrEditAlarm(existingAlarm: alarms[index], index: index),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () => _addOrEditAlarm(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

//알람 테스트 버튼 위치

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher'); // 앱 아이콘 설정

  const InitializationSettings initializationSettings =
  InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> _triggerTestNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'test_channel_id', // 채널 id
    'Test Channel', // 채널 이름
    channelDescription: 'Channel for testing alarms',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
  );
  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    '테스트 알림',
    '이것은 테스트 알림입니다.',
    platformChannelSpecifics,
  );
}