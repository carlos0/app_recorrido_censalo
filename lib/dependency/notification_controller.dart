/* import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'package:get/get.dart';

class NotificationController extends GetxController {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future<void> initialize() async {
    tz.initializeTimeZones();
    var detroit = tz.getLocation('America/La_Paz');
    tz.setLocalLocation(detroit);

    scheduleDailyNotifications();
  }

  Future<void> scheduleDailyNotifications() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'Your Channel Name',
      icon: '@mipmap/ic_launcher',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    DateTime now = DateTime.now();
    DateTime todayAt8AM = DateTime(now.year, now.month, now.day, 8, 0, 0, 0, 0);

    if (now.isBefore(todayAt8AM)) {
      // Si aún no son las 8 AM, programa la primera notificación para las 8 AM
      await flutterLocalNotificationsPlugin.zonedSchedule(
        todayAt8AM.hashCode,
        'Mensaje periódico',
        'Este es un mensaje cada 3 horas',
        tz.TZDateTime.from(todayAt8AM, tz.local),
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'Notificación ${todayAt8AM.hashCode}',
      );
    }

// Programar las siguientes notificaciones cada 3 horas hasta las 8 PM
    DateTime nextNotificationTime = todayAt8AM.add(Duration(hours: 3));

    while (nextNotificationTime.isBefore(todayAt8AM.add(Duration(hours: 12)))) {
      if (nextNotificationTime.isAfter(now)) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          nextNotificationTime.hashCode,
          'Mi día como censista',
          'Usa la aplicación, asi podremos registrar la aplicación en play store',
          tz.TZDateTime.from(nextNotificationTime, tz.local),
          platformChannelSpecifics,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: 'Notificación ${nextNotificationTime.hashCode}',
        );
      }

      // Programar la siguiente notificación 3 horas después
      nextNotificationTime = nextNotificationTime.add(Duration(hours: 3));
    }
  }
}
 */