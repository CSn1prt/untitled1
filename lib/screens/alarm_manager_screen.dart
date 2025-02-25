import 'package:flutter/material.dart';
import '../models/alarm.dart';
import '../screens/alarm_list_screen.dart'; // 오버레이 위젯 경로에 맞게 수정

class AlarmManagerScreen extends StatefulWidget {
  const AlarmManagerScreen({Key? key}) : super(key: key);

  @override
  _AlarmManagerScreenState createState() => _AlarmManagerScreenState();
}

class _AlarmManagerScreenState extends State<AlarmManagerScreen> {
  List<Alarm> alarms = [
    Alarm(title: "정신과 상담", time: "10:00 AM", isActive: true),
  ];
  OverlayEntry? _overlayEntry;

  // 오버레이를 띄워 알람 추가 또는 수정을 진행합니다.
  void _showAlarmOverlay({required Function(List<Alarm>) onSave}) {
    _overlayEntry = OverlayEntry(
      builder: (context) => FullScreenAlarmListOverlay(
        initialAlarms: alarms,
        onSave: onSave,
        onClose: () {
          _overlayEntry?.remove();
          _overlayEntry = null;
        },
      ),
    );
    Overlay.of(context)!.insert(_overlayEntry!);
  }

// 새 알람 추가
  void _addAlarm() {
    _showAlarmOverlay(
      onSave: (List<Alarm> updatedAlarms) {
        setState(() {
          alarms = updatedAlarms;
        });
      },
    );
  }

// 기존 알람 수정
  void _editAlarm(int index) {
    _showAlarmOverlay(
      onSave: (List<Alarm> updatedAlarms) {
        setState(() {
          alarms = updatedAlarms;
        });
      },
    );
  }


  // 알람 삭제
  void _deleteAlarm(int index) {
    setState(() {
      alarms.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("알람 관리"),
      ),
      body: ListView.builder(
        itemCount: alarms.length,
        itemBuilder: (context, index) {
          final alarm = alarms[index];
          return ListTile(
            leading: Icon(
              alarm.isActive ? Icons.alarm_on : Icons.alarm_off,
              color: alarm.isActive ? Colors.green : Colors.red,
            ),
            title: Text(alarm.title),
            subtitle: Text(alarm.time),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editAlarm(index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteAlarm(index),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAlarm,
        child: const Icon(Icons.add),
      ),
    );
  }
}