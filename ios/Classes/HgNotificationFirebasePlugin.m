#import "HgNotificationFirebasePlugin.h"
#if __has_include(<hg_notification_firebase/hg_notification_firebase-Swift.h>)
#import <hg_notification_firebase/hg_notification_firebase-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "hg_notification_firebase-Swift.h"
#endif

@implementation HgNotificationFirebasePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftHgNotificationFirebasePlugin registerWithRegistrar:registrar];
}
@end
