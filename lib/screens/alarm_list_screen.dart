import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/alarm.dart';
import 'app_bar_screen.dart';
import 'main_screen.dart';

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

  // SharedPreferences 에서 알람 목록 불러오기
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

  void _addOrEditAlarm({Alarm? existingAlarm, int? index}) {
    TextEditingController titleController = TextEditingController();
    TextEditingController timeController = TextEditingController();
    bool isActive = existingAlarm?.isActive ?? true;

    if (existingAlarm != null) {
      titleController.text = existingAlarm.title;
      timeController.text = existingAlarm.time;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(existingAlarm == null ? "알람 추가" : "알람 수정"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "알람 제목"),
              ),
              TextField(
                controller: timeController,
                decoration: InputDecoration(labelText: "시간"),
              ),
              SwitchListTile(
                title: Text("알람 활성화"),
                value: isActive,
                onChanged: (value) {
                  setState(() {
                    isActive = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("취소"),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    timeController.text.isNotEmpty) {
                  setState(() {
                    Alarm newAlarm = Alarm(
                      title: titleController.text,
                      time: timeController.text,
                      isActive: isActive,
                    );
                    if (existingAlarm == null) {
                      alarms.add(newAlarm);
                    } else {
                      alarms[index!] = newAlarm;
                    }
                    _saveAlarms();
                  });
                  Navigator.pop(context);
                }
              },
              child: Text("저장"),
            ),
          ],
        );
      },
    );
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
        return false; // 기본 pop 동작 방지
      },
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(), // 뒤로가기 버튼 강제 표시
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
            color: Colors.blue, // AppBar 뒤에 표시할 위젯
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
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () =>
                        _addOrEditAlarm(existingAlarm: alarms[index], index: index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
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
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
