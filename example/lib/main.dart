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
  int _lastStepCount = 0;
  int _stepsFromStream = 0;
  late StreamSubscription _stepCountStream;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    print('TimeNow: ${DateTime.now()}');
    int stepCount = await Pedometer.getLastStepCount();
    print('TimeNow: ${DateTime.now()}');

    _stepCountStream = Pedometer.getStepCountStream().listen((steps) {
      setState(() {
        _stepsFromStream = steps;
      });
    }, onError: (error) {
      print('[ERROR] $error');
      _stepsFromStream = -1;
    });
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _lastStepCount = stepCount;
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
          child: Text(
              'Last Step count: $_lastStepCount\nSteps Stream: $_stepsFromStream'),
        ),
      ),
    );
  }
}
