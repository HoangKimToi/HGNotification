import Flutter
import UIKit

public class SwiftHgNotificationFirebasePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "hg_notification_firebase", binaryMessenger: registrar.messenger())
    let instance = SwiftHgNotificationFirebasePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
