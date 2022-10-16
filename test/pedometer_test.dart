import 'package:flutter_test/flutter_test.dart';
import 'package:pedometer/pedometer.dart';
import 'package:pedometer/pedometer_platform_interface.dart';
import 'package:pedometer/pedometer_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPedometerPlatform
    with MockPlatformInterfaceMixin
    implements PedometerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PedometerPlatform initialPlatform = PedometerPlatform.instance;

  test('$MethodChannelPedometer is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPedometer>());
  });

  test('getPlatformVersion', () async {
    Pedometer pedometerPlugin = Pedometer();
    MockPedometerPlatform fakePlatform = MockPedometerPlatform();
    PedometerPlatform.instance = fakePlatform;

    expect(await pedometerPlugin.getPlatformVersion(), '42');
  });
}
