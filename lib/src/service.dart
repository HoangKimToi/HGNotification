
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart'
  show GlobalKey, NavigatorState, debugPrint;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hg_notification_firebase/src/app_state.dart';
import 'package:hg_notification_firebase/src/constants.dart';
import 'package:hg_notification_firebase/src/downloader.dart';

class PushNotificationService {
  static final _fcm = FirebaseMessaging.instance;

  static GlobalKey<NavigatorState> _navigatiorKey = GlobalKey<NavigatorState>();

  static GlobalKey<NavigatorState> get navigatorKey => _navigatiorKey;

  static String? _fcmToken;

  static String? get fcmToken => _fcmToken;

  static bool? _enableLogs;

  static String? _customSound;

  static String? _channelId;

  static String? _channelName;

  static String? _channelDescription;

  static String? _groupKey;

  static Stream<String> get onTokenRefresh => _fcm.onTokenRefresh;

  static void Function(
      GlobalKey<NavigatorState>,
      AppState,
      Map<String, dynamic> payload,
      )? _onTap;

  static bool _openedAppFromNotification = false;

  static bool get openedAppFromNotification => _openedAppFromNotification;

  static int Function(RemoteMessage)? _notificationIdCallback;

  static late void Function(
      GlobalKey<NavigatorState> nagigatorKey,
      Map<String, dynamic> payload,
      )? _onOpenedNotificationArrive;

  static Future<String?> initialize({
    String? vapidKey,
    bool enableLogs = Constants.enableLogs,
    void Function(
        GlobalKey<NavigatorState>,
        AppState,
        Map<String, dynamic> payload,
    )? onTap,

    GlobalKey<NavigatorState>? navigatorKey,
    String? customSound,
    required String channelId,
    required String channelName,
    required String channelDescription,
    required String? groupKey,
    int Function(RemoteMessage)? notificationIdCallback,
    required void Function(
      GlobalKey<NavigatorState> navigatorKey,
      Map<String, dynamic> pauload,
      )? onOpenNotificationArrive,
    }) async {
    _onTap = onTap;
    _enableLogs = enableLogs;
    _customSound = customSound;
    _notificationIdCallback = notificationIdCallback;
    _onOpenedNotificationArrive = onOpenNotificationArrive;

    _channelId = channelId;
    _channelName = channelName;
    _channelDescription = channelDescription;
    _groupKey = groupKey;

    if (navigatorKey != null) _navigatiorKey = navigatorKey;

    if (!kIsWeb && Platform.isIOS) await _fcm.requestPermission();

    _fcmToken = await initializeFCMToken(vapidKey: vapidKey);

    final bgMessage = await _fcm.getInitialMessage();

    if (bgMessage != null) {
      _openedAppFromNotification = true;
      _onBackgroundMessage(bgMessage);
    }

    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    return fcmToken;
  }

  static Future<String?> initializeFCMToken({
    String? vapidKey,
    bool log = true,
  }) async {
    _fcmToken ??= await _fcm.getToken(vapidKey: vapidKey);
    if (_enableLogs ?? log) debugPrint("FCM Token initialize: $_fcmToken");

    _fcm.onTokenRefresh.listen((event) {
      _fcmToken = event;
      if (_enableLogs ?? log) debugPrint("FCM Token updated: $_fcmToken");
    });
    return _fcmToken;
  }

  static Future<void> _onMessage(RemoteMessage message) => _notificationHandler(message, appState: AppState.open);

  static Future<void> _onBackgroundMessage(RemoteMessage message) => _notificationHandler(message, appState: AppState.closed);

  static Future<void> _onMessageOpenedApp(RemoteMessage message) => _notificationHandler(message, appState: AppState.background);

  static Future<FlutterLocalNotificationsPlugin> _initializeLocalNotifications() async {
    final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();
    const initializationSetting = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),

    );

    await flutterLocalNotificationPlugin.initialize(initializationSetting,
    onSelectNotification: (String? payload) async {
      if (_onTap != null) {
        _onTap!(
          navigatorKey, AppState.open, payload == null ? {} : jsonDecode(payload)
        );
      }
    });

    return flutterLocalNotificationPlugin;
  }

  static Future<void> _notificationHandler(RemoteMessage message, { AppState? appState }) async {
    _enableLogs ??= Constants.enableLogs;
    if (_enableLogs!) {
      debugPrint("""\n
      ******************************************************* 
                        NEW NOTIFICATION
      *******************************************************
      Title: ${message.notification?.title}
      Body: ${message.notification?.body}
      Payload: ${message.data}
      *******************************************************\n
                """);
    }

    _channelId ??= Constants.channelId;
    _channelName ??= Constants.channelName;
    _channelDescription ??= Constants.channelDescription;

    StyleInformation? styleInformation;

    String? imageUrl;

    if (message.notification?.android?.imageUrl != null) {
      imageUrl = message.notification?.android?.imageUrl;
    } else if(message.notification?.apple?.imageUrl != null) {
      imageUrl = message.notification?.apple?.imageUrl;
    }

    if (appState == AppState.open && imageUrl != null) {
      final notificationImage = await DownloaderService.downloadImage(url: imageUrl, fileName: "notificationImage");
      if (notificationImage != null) {
        styleInformation = BigPictureStyleInformation(FilePathAndroidBitmap(notificationImage),
        largeIcon: FilePathAndroidBitmap(notificationImage),
        hideExpandedLargeIcon: true);
      }
    }

    final androidSpecifics = AndroidNotificationDetails(message.notification?.android?.channelId ?? _channelId!,
        _channelName!,
      channelDescription: _channelDescription!,
      importance: Importance.max,
      styleInformation: styleInformation,
      priority: Priority.high,
      groupKey: _groupKey,
      sound: _customSound == null ? null : RawResourceAndroidNotificationSound(_customSound),
      playSound: true,
      enableLights: true,
      enableVibration: true
    );

    final iOSSpecifics = IOSNotificationDetails(sound: _customSound);

    final notificationPlatformSpecifics = NotificationDetails(
      android: androidSpecifics,
      iOS: iOSSpecifics,
    );

    final localNotification = await _initializeLocalNotifications();
    _notificationIdCallback ??= (_) => DateTime.now().hashCode;

    if (appState == AppState.open) {
      await localNotification.show(_notificationIdCallback!(message), message.notification?.title, message.notification?.body, notificationPlatformSpecifics,
      payload: jsonEncode(message.data));

      if (_onOpenedNotificationArrive != null) {
        _onOpenedNotificationArrive!(_navigatiorKey, message.data);
      }
    } else if (_onTap != null) {
      _onTap!(_navigatiorKey, appState!, message.data);
    }


  }
}