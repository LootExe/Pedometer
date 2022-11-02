import 'dart:async';

import 'package:flutter/services.dart';

class Pedometer {
  static const _eventChannel =
      EventChannel('com.lootexe.pedometer.sensor', JSONMethodCodec());

  /// Returns a stream that receives steps events.
  /// As soon as the sensor is registered in the plugin, this stream returns
  /// the last step count [int] since boot of the Android system.
  ///
  /// The value is reset to zero on every reboot
  ///
  /// The sensor does not report steps when being called from a background task.
  /// If you need to call this sensor from a background task, like Alarm Manager,
  /// the App needs to implement a foreground service.
  ///
  /// [configuration] sets the sensor configuration. If none is specified,
  /// the default configuration is being used ([SamplingRate.normal] and zero
  /// batching)
  static Stream<int> getStepCountStream(
      {SensorConfiguration configuration = const SensorConfiguration()}) {
    return _eventChannel
        .receiveBroadcastStream(configuration.toJson())
        .map((event) => event['stepCount']);
  }
}

/// A data class that holds the sensor configuration for the Step Count sensor.
class SensorConfiguration {
  /// Creates a [SensorConfiguration].
  ///
  /// The [samplingRate] sets the desired delay between two consecutive
  /// events in microseconds. This is only a hint to the system.
  /// Events may be received faster or slower than the specified rate.
  /// Usually events are received faster.
  ///
  /// The [batchingInterval] sets the maximum time in microseconds
  /// that events can be delayed before being reported to the application.
  /// A large value allows reducing the power consumption associated with the sensor.
  /// If maxReportLatencyUs is set to zero, events are delivered as soon as they are available
  const SensorConfiguration({
    this.samplingRate = SamplingRate.normal,
    this.batchingInterval = const Duration(),
  });

  final SamplingRate samplingRate;
  final Duration batchingInterval;

  Map toJson() => {
        'samplingRate': samplingRate.value,
        'batchingInterval': batchingInterval.inMicroseconds,
      };
}

/// The sensor sampling rate
enum SamplingRate {
  /// 0 microseconds
  fastest(0),

  /// 20,000 microsecond (20 milliseconds)
  game(1),

  /// 60,000 microsecond (60 milliseconds)
  ui(2),

  /// 200,000 microseconds (200 milliseconds)
  normal(3);

  const SamplingRate(this.value);
  final int value;
}
