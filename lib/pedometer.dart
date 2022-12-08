import 'dart:async';

import 'package:flutter/services.dart';

class Pedometer {
  static const _methodChannel =
      MethodChannel('com.lootexe.pedometer.method', JSONMethodCodec());
  static const _eventChannel =
      EventChannel('com.lootexe.pedometer.event', JSONMethodCodec());

  static bool isInitialized = false;

  /// Registers a SensorListener with the SensorManager
  /// Returns true if the sensor hardware exists and could be registered
  ///
  /// [configuration] sets the sensor configuration. If none is specified,
  /// the default configuration is being used ([SamplingRate.normal] and zero
  /// batching)
  static Future<bool> initialize(
      {SensorConfiguration configuration = const SensorConfiguration()}) async {
    try {
      final result = await _methodChannel.invokeMethod<bool>(
          'registerSensor', configuration.toJson());

      isInitialized = result ?? false;
      return isInitialized;
    } on PlatformException catch (e) {
      throw SensorError(e.message);
    }
  }

  /// Unregisters the sensor from the SensorManager and stops listening
  /// to step events
  static Future<void> dispose() async {
    await _methodChannel.invokeMethod('unregisterSensor');
  }

  /// Returns the last step count [int] while the sensor was active
  static Future<int> getStepCount() async {
    if (!isInitialized) {
      throw SensorError('Not initialized');
    }

    return await _methodChannel.invokeMethod<int>('stepCount') ?? -1;
  }

  /// Returns a stream that receives step events.
  ///
  /// While the sensor is registered, this stream returns
  /// the step count [int] since boot of the Android system.
  ///
  /// The value is reset to zero on every reboot
  static Stream<int> getStepCountStream() {
    if (!isInitialized) {
      throw SensorError('Not initialized');
    }

    return _eventChannel
        .receiveBroadcastStream()
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

class SensorException implements Exception {}

class SensorError extends Error {
  SensorError([this.message]);

  /// Message describing the problem.
  final dynamic message;

  @override
  String toString() {
    Object? message = this.message;
    return (message == null) ? '' : '$message';
  }
}
