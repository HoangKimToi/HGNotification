import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hg_notification_firebase/hg_notification_firebase_method_channel.dart';

void main() {
  MethodChannelHgNotificationFirebase platform = MethodChannelHgNotificationFirebase();
  const MethodChannel channel = MethodChannel('hg_notification_firebase');

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
