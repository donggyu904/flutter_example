import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FToast fToast;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _showToast();
              },
              child: const Text('show toast'),
            ),
            ElevatedButton(
              onPressed: () async {
                final notification = FlutterLocalNotificationsPlugin();
                const android = AndroidNotificationDetails(
                  '0',
                  '알림 테스트',
                  channelDescription: '알림 설정',
                  importance: Importance.max,
                  priority: Priority.max,
                );
                const ios = DarwinNotificationDetails();
                const detail = NotificationDetails(
                  android: android,
                  iOS: ios,
                );

                final permission = Platform.isAndroid
                    ? true
                    : await notification
                            .resolvePlatformSpecificImplementation<
                                IOSFlutterLocalNotificationsPlugin>()
                            ?.requestPermissions(
                                alert: true, badge: true, sound: true) ??
                        false;

                if (!permission) {
                  // await showNotiPermissionDialog(context);
                  // return toast 권한이 없습니다.
                  return;
                }

                // await flutterLocalNotificationsPlugin.show(
                //   0,
                //   'plain title',
                //   'plain body',
                //   detail,
                // );
// 타임존 셋팅 필요
                final now = tz.TZDateTime.now(tz.local);
                var notiDay = now.day;

// // 예외처리
//                 if (now.hour > hour ||
//                     now.hour == hour && now.minute >= minute) {
//                   notiDay = notiDay + 1;
//                 }

                await notification.zonedSchedule(
                  1,
                  'alarmTitle',
                  'alarmDescription',
                  tz.TZDateTime(
                    tz.local,
                    now.year,
                    now.month,
                    now.day,
                    now.hour,
                    now.minute + 1,
                  ),
                  detail,
                  androidAllowWhileIdle: true,
                  uiLocalNotificationDateInterpretation:
                      UILocalNotificationDateInterpretation.absoluteTime,
                  matchDateTimeComponents: DateTimeComponents.time,
                  // payload: DateFormat('HH:mm').format(alarmTime),
                );
              },
              child: const Text('add alarm'),
            ),
            const Center(child: Text('hi')),
          ]),
    );
  }

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("This is a Custom Toast"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );

    // Custom Toast Position
  }
}
