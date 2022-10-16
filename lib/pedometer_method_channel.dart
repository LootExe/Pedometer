import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'pedometer_platform_interface.dart';

/// An implementation of [PedometerPlatform] that uses method channels.
class MethodChannelPedometer extends PedometerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pedometer');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
