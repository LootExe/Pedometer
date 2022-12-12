import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

void main() => runApp(const PedometerApp());

class PedometerApp extends StatefulWidget {
  const PedometerApp({super.key});

  @override
  State<PedometerApp> createState() => _PedometerAppState();
}

class _PedometerAppState extends State<PedometerApp> {
  int _stepsFromCall = 0;
  int _stepsFromStream = 0;
  StreamSubscription? _stepCountStream;
  String _sensorStatus = 'Unregistered';

  final _config = const SensorConfiguration(
    samplingRate: SamplingRate.ui,
    batchingInterval: Duration(seconds: 1),
  );

  SnackBar _buildSnackBar(String text) => SnackBar(content: Text(text));

  Future<void> _registerSensor(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);

    if (await Pedometer.isRegistered) {
      messenger.showSnackBar(_buildSnackBar('Sensor already registered'));
      return;
    }

    final success = await Pedometer.registerSensor(
      configuration: _config,
    );

    if (!success) {
      messenger.showSnackBar(_buildSnackBar('Sensor registration failed'));
      _sensorStatus = 'Failure';
      return;
    }

    _sensorStatus = 'Registered';
    _stepsFromCall = await Pedometer.getStepCount();

    _stepCountStream = Pedometer.getStepCountStream().listen(
      (int steps) {
        setState(() => _stepsFromStream = steps);
      },
      onError: (dynamic error) {
        print('Pedometer error: $error');
        setState(() => _stepsFromStream = -1);
      },
    );

    messenger.showSnackBar(_buildSnackBar('Sensor registered'));
    setState(() {});
  }

  Future<void> _unregisterSensor(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);

    if (await Pedometer.isRegistered == false) {
      messenger.showSnackBar(_buildSnackBar('Sensor already unregistered'));
      return;
    }

    _stepCountStream?.cancel();
    await Pedometer.unregisterSensor();
    _sensorStatus = 'Unregistered';

    messenger.showSnackBar(_buildSnackBar('Sensor unregistred'));
    setState(() {});
  }

  @override
  void dispose() {
    _unregisterSensor(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pedometer Example App'),
          centerTitle: true,
        ),
        body: Builder(
          builder: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                ElevatedButton(
                  onPressed: () => _registerSensor(context),
                  child: const Text('Register Sensor'),
                ),
                ElevatedButton(
                  onPressed: () => _unregisterSensor(context),
                  child: const Text('Unregister Sensor'),
                ),
                const Spacer(),
                Text('Last Step Count : $_stepsFromCall'),
                Text('Step Count Stream : $_stepsFromStream'),
                const Spacer(),
                Text('Sensor Status : $_sensorStatus'),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
