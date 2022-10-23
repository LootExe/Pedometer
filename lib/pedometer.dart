import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';

class Pedometer {
  static const _eventChannel =
      EventChannel('com.lootexe.pedometer.sensor', JSONMethodCodec());

  static Stream<int> getStepCountStream(SensorConfiguration configuration) {
    return _eventChannel
        .receiveBroadcastStream(configuration.toJson())
        .map((event) => event['stepCount']);
  }
}

class SensorConfiguration {
  const SensorConfiguration({
    required this.batchingInterval,
  });

  final Duration batchingInterval;

  Map toJson() {
    Map json = {
      'batching': max(batchingInterval.inMilliseconds, 100),
    };
    return json;
  }
}
