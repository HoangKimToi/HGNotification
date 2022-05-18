library hg_notification_firebase;

import 'hg_notification_firebase_platform_interface.dart';
export 'src/widget.dart';
export 'src/app_state.dart';

class HgNotificationFirebase {
  Future<String?> getPlatformVersion() {
    return HgNotificationFirebasePlatform.instance.getPlatformVersion();
  }
}
