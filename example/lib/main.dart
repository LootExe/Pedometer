import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _stepsFromStream = 0;
  late StreamSubscription _stepCountStream;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    _stepCountStream = Pedometer.getStepCountStream().listen((steps) {
      setState(() {
        _stepsFromStream = steps;
      });
    }, onError: (error) {
      print('[ERROR] $error');
      _stepsFromStream = -1;
    });
  }

  @override
  void dispose() {
    _stepCountStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pedometer example app'),
        ),
        body: Center(
          child: Text('Step Count: $_stepsFromStream'),
        ),
      ),
    );
  }
}
