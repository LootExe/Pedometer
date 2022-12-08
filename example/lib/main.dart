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
  StreamSubscription? _stepCountStream;

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

  Future<void> _initPlatformState() async {
    const config = SensorConfiguration(samplingRate: SamplingRate.ui);
    bool result = false;

    try {
      result = await Pedometer.initialize(configuration: config);
      print('Pedometer initialized');
    } catch (e) {
      print('Pedometer error: ${e.toString()}');
    }

    if (result) {
      final lastStepCount = await Pedometer.getStepCount();
      print('Pedometer last step count = $lastStepCount');

      _stepCountStream = Pedometer.getStepCountStream().listen(
        _onListen,
        onError: _onError,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _initPlatformState();
  }

  @override
  void dispose() async {
    _stepCountStream?.cancel();
    await Pedometer.dispose();

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
