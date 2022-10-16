import 'package:flutter/services.dart';

class Pedometer {
  static const _eventChannel = EventChannel('com.lootexe.pedometer.event');

  static Stream<int> getStepCountStream() =>
      _eventChannel.receiveBroadcastStream().map((steps) => steps);
}
