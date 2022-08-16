import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class localNotificationService {
  localNotificationService();

  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();

  final _localNotificationService = FlutterLocalNotificationsPlugin();
  Future<void> intialize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/logo');

    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    final InitializationSettings settings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _localNotificationService.initialize(settings,
        onSelectNotification:
            onSelectNotification); //onSelectNotification its for navigation to second page when clicked on get notification payload button
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails andriodNotifiactionDetails =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      showWhen: true,
    );

    const IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails();
    return const NotificationDetails(
        android: andriodNotifiactionDetails, iOS: iosNotificationDetails);
  }

  Future<void> showNotification(
      {required int id, required String title, required String body}) async {
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details);
  }

  Future<void> showScheduleNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = await _notificationDetails();
    var dateTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 22, 49, 0);
    await _localNotificationService.zonedSchedule(
        id, title, body, tz.TZDateTime.from(dateTime, tz.local), details,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> showNotificationWithPayload(
      {required int id,
      required String title,
      required String body,
      required String payload}) async {
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details,
        payload: payload);
  }

  void _onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print('id $id');
  }

  void onSelectNotification(String? payload) {
    print('payload $payload');
    if (payload != null && payload.isNotEmpty) onNotificationClick.add(payload);
  }
}
