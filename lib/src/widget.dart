
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:hg_notification_firebase/src/app_state.dart';
import 'package:hg_notification_firebase/src/constants.dart';
import 'package:hg_notification_firebase/src/service.dart';
import 'package:http/http.dart' as http;

class HGNotificationFirebase extends StatefulWidget {

  static String? get fcmToken => PushNotificationService.fcmToken;

  static GlobalKey<NavigatorState>? get navigatorKey => PushNotificationService.navigatorKey;

  static bool get openedAppFromNotification => PushNotificationService.openedAppFromNotification;

  /// Returns the default FCM token for this device.
  final String? vapidKey;

  /// {@template customSound}
  /// Pass in the name of the audio file as a string if you
  /// want a custom sound for the notification.
  ///
  /// .
  ///
  /// Android: Add the audio file in android/app/src/main/res/raw/___audio_file_here___
  ///
  /// iOS: Add the audio file in Runner/Resources/___audio_file_here___
  ///
  /// Edit the keep file in the folder ..res/raw of android
  /// https://stackoverflow.com/questions/59783904/flutter-local-notification-custom-sound-doesnt-work-path-issue
  ///
  /// {@endtemplate}
  final String? customSound;

  final String channelId;

  final String channelName;

  final String channelDescription;

  final String? groupKey;

  final bool enableLogs;

  final GlobalKey<NavigatorState>? defaultNavigatorKey;

  final int Function(RemoteMessage)? notificationIdCallback;

  final void Function(BuildContext, String?)? onFCMTokenInitialize;

  final void Function(BuildContext, String?)? onFCMTokenUpdate;

  final void Function(
      GlobalKey<NavigatorState> navigatorKey,
      Map payload,
      )? onOpenNotificationArrive;

  final void Function(
      GlobalKey<NavigatorState> navigatorKey,
      AppState appState,
      Map payload,
      )? onTap;

  final Widget child;

  const HGNotificationFirebase({
    Key? key,
    this.vapidKey,
    this.enableLogs = true,
    this.onTap,
    this.onOpenNotificationArrive,
    this.onFCMTokenInitialize,
    this.onFCMTokenUpdate,
    this.defaultNavigatorKey,
    this.customSound,
    this.notificationIdCallback,
    this.channelId = Constants.channelId,
    this.channelName = Constants.channelName,
    this.channelDescription = Constants.channelDescription,
    this.groupKey,
    required this.child,
  }): super(key: key);

  static const initializeFCMToken = PushNotificationService.initializeFCMToken;
  static final onFCMTokenRefresh = PushNotificationService.onTokenRefresh;

  static Future<http.Response> sendNotification({
    required String cloudMessagingServerKey,
    required String title,
    required List<String> fcmTokens,
    String? body,
    String? imageUrl,
    Map? payload,
    Map? additionalHeaders,
    Map? notificationMeta,
  }) async {
    return await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$cloudMessagingServerKey',
        ...?additionalHeaders
      },
      body: jsonEncode({
        if (fcmTokens.length == 1)
          "to": fcmTokens.first
         else
          "registration_ids": fcmTokens,
        "notification": {
          "title": title,
          "body": body,
          "image": imageUrl,
          ...?notificationMeta,
        },
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          ...?payload,
        },
      })
    );
  }

  @override
  State<HGNotificationFirebase> createState() {
    return _HGNotificationFirebaseState();
  }
}

class _HGNotificationFirebaseState extends State<HGNotificationFirebase> {

  @override
  void initState() {
    () async {
      final token = await PushNotificationService.initialize(
          vapidKey: widget.vapidKey,
          enableLogs: widget.enableLogs,
          onTap: widget.onTap,
          navigatorKey: widget.defaultNavigatorKey,
          customSound: widget.customSound,
          channelId: widget.channelId,
          channelName:  widget.channelName,
          channelDescription: widget.channelDescription,
          groupKey: widget.groupKey,
          onOpenNotificationArrive: widget.onOpenNotificationArrive,
          notificationIdCallback: widget.notificationIdCallback
      ).then((value) => {
        widget.onFCMTokenInitialize?.call(context, value)
      });

      PushNotificationService.onTokenRefresh.listen((token) {
        widget.onFCMTokenUpdate?.call(context, token);
      });
    }();
    super.initState();

  }

  @override
  Widget build(BuildContext context) => widget.child;

}