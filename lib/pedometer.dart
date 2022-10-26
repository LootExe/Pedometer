import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';

class Pedometer {
  static const _eventChannel =
      EventChannel('com.lootexe.pedometer.sensor', JSONMethodCodec());

  static Stream<int> getStepCountStream(SensorConfiguration? configuration) {
    final config = configuration ??
        const SensorConfiguration(batchingInterval: Duration());
    return _eventChannel
        .receiveBroadcastStream(config.toJson())
        .map((event) => event['stepCount']);
  }
}

class SensorConfiguration {
  const SensorConfiguration({
    required this.batchingInterval,
  });

  final Duration batchingInterval;

  Map toJson() => {
        'batching': max(batchingInterval.inMilliseconds, 100),
      };
}
