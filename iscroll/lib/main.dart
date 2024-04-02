import 'package:flutter/material.dart';
import 'package:iscroll/screen/pour.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keke tv',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: ShikasmaduPlay(),
    );
  }
}
