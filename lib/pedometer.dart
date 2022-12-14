import 'dart:async';

import 'package:flutter/services.dart';

class Pedometer {
  static const _methodChannel =
      MethodChannel('com.lootexe.pedometer.method', JSONMethodCodec());
  static const _eventChannel =
      EventChannel('com.lootexe.pedometer.event', JSONMethodCodec());

  static const int sensorError = -1;

  /// Returns a [Future] of [bool] that resolves to true
  /// if the sensor is registered with the SensorManager.
  static Future<bool> get isRegistered async =>
      await _methodChannel.invokeMethod<bool>('isRegistered') ?? false;

  /// Registers the sensor with the SensorManager.
  ///
  /// Returns a [Future] of [bool] if the sensor hardware exists
  /// and is succesfully registered.
  ///
  /// [configuration] sets the sensor configuration. If none is specified,
  /// the default configuration is being used ([SamplingRate.normal] and zero
  /// batching)
  static Future<bool> registerSensor({
    SensorConfiguration configuration = const SensorConfiguration(),
  }) async {
    if (await isRegistered) {
      return true;
    }

    try {
      final result = await _methodChannel.invokeMethod<bool>(
          'registerSensor', configuration.toJson());

      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Unregisters the sensor from the SensorManager and stops listening
  /// to step events.
  ///
  /// Returns a [Future] of [bool] if the sensor is succesfully unregistered.
  static Future<bool> unregisterSensor() async {
    if (await isRegistered == false) {
      return true;
    }

    try {
      final result =
          await _methodChannel.invokeMethod<bool>('unregisterSensor');

      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Returns a [Future] of [int] that resolves to the last step count
  /// while the sensor was registered.
  static Future<int> getStepCount() async {
    if (await isRegistered == false) {
      return sensorError;
    }

    return await _methodChannel.invokeMethod<int>('stepCount') ?? sensorError;
  }

  /// Returns a stream that receives step events.
  ///
  /// While the sensor is registered, this stream returns
  /// the step count [int] since boot of the Android system.
  ///
  /// The value is reset to zero on every reboot
  static Stream<int> getStepCountStream() =>
      _eventChannel.receiveBroadcastStream().map((event) => event['stepCount']);
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
