import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'pedometer_method_channel.dart';

abstract class PedometerPlatform extends PlatformInterface {
  /// Constructs a PedometerPlatform.
  PedometerPlatform() : super(token: _token);

  static final Object _token = Object();

  static PedometerPlatform _instance = MethodChannelPedometer();

  /// The default instance of [PedometerPlatform] to use.
  ///
  /// Defaults to [MethodChannelPedometer].
  static PedometerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PedometerPlatform] when
  /// they register themselves.
  static set instance(PedometerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<int?> getStepCount() {
    throw UnimplementedError('getStepCount() has not been implemented.');
  }
}
