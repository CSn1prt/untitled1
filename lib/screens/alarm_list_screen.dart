import 'package:flutter/material.dart';
import '../models/alarm.dart';
import 'app_bar_screen.dart';
import 'main_screen.dart';


class AlarmListScreen extends StatefulWidget {
  const AlarmListScreen({Key? key}) : super(key: key);

  @override
  _AlarmListScreenState createState() => _AlarmListScreenState();
}

class _AlarmListScreenState extends State<AlarmListScreen> {
  List<Alarm> alarms = [
    Alarm(title: "정신과 상담", time: "10:00 AM", isActive: true),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
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

    );
  }
}
