import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hg_notification_firebase/hg_notification_firebase.dart';
import 'package:hg_notification_firebase_example/screens/detail_screen.dart';
import 'package:hg_notification_firebase_example/screens/splash_screen.dart';
import 'package:hg_notification_firebase_example/utils/app_theme.dart';
import 'package:hg_notification_firebase_example/utils/globals.dart';
import 'package:hg_notification_firebase_example/utils/helper.dart';
import 'package:hg_notification_firebase_example/utils/route_generator.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const _MyApp());
}

class _MyApp extends StatelessWidget {

  static const id = '_MainApp';

  const _MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HGNotificationFirebase(
      // File path in android/app/src/main/res/raw
      customSound: "notification",
      defaultNavigatorKey: Globals.navigatorKey,
      onOpenNotificationArrive: (_, payload) {
        log(
          id,
          msg: "Notification received while app is open with payload $payload",
        );
      },
      onTap: (navigatorState, appState, payload) {
        log(
          id,
          msg: "Notification tapped with $appState & payload $payload",
        );

        if (Globals.navigatorKey.currentContext != null) {
          Navigator.pushNamed(Globals.navigatorKey.currentContext!, DetailScreen.id, arguments: payload);
        }
      },

      // Save the device's fcmToken.
      onFCMTokenInitialize: (_, token) => Globals.fcmToken = token,
      onFCMTokenUpdate: (_, token) => Globals.fcmToken = token,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FirebaseNotificationsHandler Demo',
        navigatorKey: Globals.navigatorKey,
        scaffoldMessengerKey: Globals.scaffoldMessengerKey,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: SplashScreen.id,
      ),
    );
  }
}
