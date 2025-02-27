import 'package:flutter/material.dart';
import '../app_constants.dart';
import '../models/alarm.dart';

class FullScreenAlarmListOverlay extends StatefulWidget {
  final List<Alarm> initialAlarms;
  final ValueChanged<List<Alarm>> onSave;
  final VoidCallback onClose;

  const FullScreenAlarmListOverlay({
    Key? key,
    required this.initialAlarms,
    required this.onSave,
    required this.onClose,
  }) : super(key: key);

  @override
  _FullScreenAlarmListOverlayState createState() =>
      _FullScreenAlarmListOverlayState();
}

class _FullScreenAlarmListOverlayState
    extends State<FullScreenAlarmListOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late List<Alarm> alarms;

  @override
  void initState() {
    super.initState();
    // 초기 알람 목록을 복사하여 상태 변수에 저장.
    alarms = List.from(widget.initialAlarms);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _closeOverlay() {
    _controller.reverse().then((_) {
      widget.onClose();
    });
  }




  @override
  Widget build(BuildContext context) {

    return SlideTransition(

      position: _animation,
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    // 헤더: 타이틀 및 닫기 버튼
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      color: Colors.blue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            AppConstants.alarmTitle,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: _closeOverlay,
                          ),
                        ],
                      ),
                    ),
                    // 본문: 알람 목록 표시
                    Expanded(
                      child: ListView.builder(
                        itemCount: alarms.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(
                              alarms[index].isActive ? Icons.alarm_on : Icons.alarm_off,
                              color: alarms[index].isActive ? Colors.green : Colors.red,
                            ),
                            title: Text(alarms[index].title),
                            subtitle: Text(alarms[index].time),
                            trailing: Switch(
                              value: alarms[index].isActive,
                              onChanged: (bool value) {
                                setState(() {
                                  alarms[index] = Alarm(
                                    title: alarms[index].title,
                                    time: alarms[index].time,
                                    isActive: value,
                                  );
                                });
                              },
                            ),
                          );
                        },
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
                            child: const Text(AppConstants.close),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () {
                              widget.onSave(alarms);
                              _closeOverlay();
                            },
                            child: const Text(AppConstants.save),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // FloatingActionButton을 오버레이 상단에 배치하여 알람 추가 기능 제공
              // Positioned(
              //   bottom: 77,
              //   right: 16,
              //   child: FloatingActionButton(
              //     onPressed: _addAlarm,
              //     child: const Icon(Icons.add),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
