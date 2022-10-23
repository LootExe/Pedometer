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

  void _onListen(int steps) {
    setState(() {
      _stepsFromStream = steps;
    });
  }

  void _onError(dynamic error) {
    print('Pedometer error: $error');

    setState(() {
      _stepsFromStream = -1;
    });
  }

  void _initPlatformState() {
    const config = SensorConfiguration(batchingInterval: Duration(minutes: 5));

    _stepCountStream = Pedometer.getStepCountStream(config).listen(
      _onListen,
      onError: _onError,
    );
  }

  @override
  void initState() {
    super.initState();
    _initPlatformState();
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
          centerTitle: true,
        ),
        body: Center(
          child: Text('Step Count: $_stepsFromStream'),
        ),
      ),
    );
  }
}
