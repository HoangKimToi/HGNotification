import 'package:flutter_test/flutter_test.dart';
import 'package:hg_notification_firebase/hg_notification_firebase.dart';
import 'package:hg_notification_firebase/hg_notification_firebase_platform_interface.dart';
import 'package:hg_notification_firebase/hg_notification_firebase_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockHgNotificationFirebasePlatform 
    with MockPlatformInterfaceMixin
    implements HgNotificationFirebasePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final HgNotificationFirebasePlatform initialPlatform = HgNotificationFirebasePlatform.instance;

  test('$MethodChannelHgNotificationFirebase is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelHgNotificationFirebase>());
  });

  test('getPlatformVersion', () async {
    HgNotificationFirebase hgNotificationFirebasePlugin = HgNotificationFirebase();
    MockHgNotificationFirebasePlatform fakePlatform = MockHgNotificationFirebasePlatform();
    HgNotificationFirebasePlatform.instance = fakePlatform;
  
    expect(await hgNotificationFirebasePlugin.getPlatformVersion(), '42');
  });
}
