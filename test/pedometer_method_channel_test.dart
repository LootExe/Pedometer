import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pedometer/pedometer_method_channel.dart';

void main() {
  MethodChannelPedometer platform = MethodChannelPedometer();
  const MethodChannel channel = MethodChannel('pedometer');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
