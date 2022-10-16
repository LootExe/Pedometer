import 'package:flutter/services.dart';

class Pedometer {
  static const _methodChannel = MethodChannel('com.lootexe.pedometer');
  static const _eventChannel = EventChannel('com.lootexe.pedometer.event');

  static Future<int> getLastStepCount() async {
    try {
      final result = await _methodChannel.invokeMethod<int?>('getStepCount');
      return result ?? -1;
    } on PlatformException {
      return -1;
    }
  }

  static Stream<int> getStepCountStream() =>
      _eventChannel.receiveBroadcastStream().map((steps) => steps);
}
