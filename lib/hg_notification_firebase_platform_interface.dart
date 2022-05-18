import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'hg_notification_firebase_method_channel.dart';

abstract class HgNotificationFirebasePlatform extends PlatformInterface {
  /// Constructs a HgNotificationFirebasePlatform.
  HgNotificationFirebasePlatform() : super(token: _token);

  static final Object _token = Object();

  static HgNotificationFirebasePlatform _instance = MethodChannelHgNotificationFirebase();

  /// The default instance of [HgNotificationFirebasePlatform] to use.
  ///
  /// Defaults to [MethodChannelHgNotificationFirebase].
  static HgNotificationFirebasePlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HgNotificationFirebasePlatform] when
  /// they register themselves.
  static set instance(HgNotificationFirebasePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
