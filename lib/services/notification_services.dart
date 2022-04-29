import 'package:flutter/material.dart';
import 'package:flutter_advanced_testing/models/task.dart';
import 'package:flutter_advanced_testing/ui/pages/notification_screen.dart';
import 'package:flutter_advanced_testing/ui/theme.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String selectedNotificationPayload = '';

  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();

  initializeNotification() async {
    ///////////////////////////////////////////////////
    tz.initializeTimeZones();
    //tz.setLocalLocation(tz.getLocation(timeZoneName));
    ///////////////////////////////////////////////////
    _configureSelectNotificationSubject();
    await _configureLocalTimeZone();
    //////////////////////////////////////////////////////////////////////////
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    //////////////////////////////////////////////////////////////////////////
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    //////////////////////////////////////////////////////////////////////////
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    //////////////////////////////////////////////////////////////////////////
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
        }
        selectNotificationSubject.add(payload!);
      },
    );
  }

  //////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////
  displayNotification({required String title, required String body}) async {
    print('display notification function is called');
    ////////////////////////////////////////////////////////////////
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      color: Colors.red,
    );
    ////////////////////////////////////////////////////////////////
    const IOSNotificationDetails iosPlatformChannelSpecifics =
        IOSNotificationDetails();
    ////////////////////////////////////////////////////////////////
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );
    ////////////////////////////////////////////////////////////////
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  //////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////
  cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  //////////////////////////////////////////////////////////////////////////
  cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  //////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////
  scheduledNotification(int hour, int minutes, Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!,
      task.title,
      task.note,
      //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      _nextInstanceOfTenAM(
        hour,
        minutes,
        task.remind!,
        task.repeat!,
        task.date!,
      ),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          color: task.color == 0
              ? primaryClr
              : task.color == 1
                  ? pinkClr
                  : orangeClr,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: '${task.title}|${task.note}|${task.startTime}|',
    );
  }

  //////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////
  tz.TZDateTime _nextInstanceOfTenAM(
    int hour,
    int minutes,
    int remind,
    String repeat,
    String date,
  ) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz
        .local); // To get the current date and time in the [location] time zone

    DateTime dateTime =
        DateFormat.yMd().parse(date); //Convert string of date -> dateTime

    final tz.TZDateTime _tzDateTime = tz.TZDateTime.from(
        dateTime, tz.local); // Convert dateTime -> tzDateTime

    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      _tzDateTime.year,
      _tzDateTime.month,
      _tzDateTime.day,
      hour,
      minutes,
    );

    scheduledDate = scheduledDate
        .subtract(Duration(minutes: remind)); // To subtract the remind value

    print('Remind is : $remind  && ScheduledDate is : $scheduledDate');

    if (scheduledDate.isBefore(now) && repeat != 'None') {
      if (repeat == 'Daily') {
        scheduledDate = tz.TZDateTime(
            tz.local, now.year, now.month, (dateTime.day) + 1, hour, minutes);
      } else if (repeat == 'Weekly') {
        scheduledDate = tz.TZDateTime(
            tz.local, now.year, now.month, (dateTime.day) + 7, hour, minutes);
      } else if (repeat == 'Monthly') {
        scheduledDate = tz.TZDateTime(tz.local, now.year, (dateTime.month) + 1,
            dateTime.day, hour, minutes);
      }
      scheduledDate = scheduledDate.subtract(Duration(minutes: remind));
    }

    print('New ScheduledDate is : $scheduledDate');

    return scheduledDate;
  }

  //////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////
  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  //////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////
  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen(
      (String payload) async {
        debugPrint('My payload is ' + payload);
        await Get.to(() => NotificationScreen(payload: payload));
      },
    );
  }

  ////////////////////////////////////////////////////////////////
  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details
    print('Hi man onDidReceiveLocalNotification');
    Get.dialog(Text(body!));
  }

  //////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////
  requestIOSPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}
