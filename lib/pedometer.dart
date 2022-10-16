import 'pedometer_platform_interface.dart';

class Pedometer {
  Future<String?> getPlatformVersion() {
    return PedometerPlatform.instance.getPlatformVersion();
  }
}
