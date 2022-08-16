import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  String? payload;
  SecondPage({this.payload});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('payload $payload'),
      ),
    );
  }
}
