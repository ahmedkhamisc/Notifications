import 'package:flutter/material.dart';
import 'services/local_notification_service.dart';
import 'secondPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final localNotificationService service;
  @override
  void initState() {
    service = localNotificationService();
    service.intialize();
    listenToNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                await service.showNotification(
                    id: 0, title: 'Notification title', body: 'some body');
              },
              child: const Text('Get Notification'),
            ),
            TextButton(
              onPressed: () async {
                await service.showScheduleNotification(
                  id: 0,
                  title: 'Notification title',
                  body: 'some body',
                );
              },
              child: const Text('Get Schedule Notification'),
            ),
            TextButton(
              onPressed: () async {
                await service.showNotificationWithPayload(
                    id: 0,
                    title: 'Notification title',
                    body: 'some body',
                    payload: 'Payload navigation');
              },
              child: const Text('Get Notification payload'),
            ),
          ],
        ),
      ),
    );
  }

  void listenToNotification() =>
      service.onNotificationClick.stream.listen(onNoitifationListener);

  void onNoitifationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      print('payload $payload');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SecondPage(payload: payload)));
    }
    ;
  }
}
