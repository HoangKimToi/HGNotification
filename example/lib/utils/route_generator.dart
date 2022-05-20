

import 'package:flutter/material.dart';
import 'package:hg_notification_firebase_example/screens/detail_screen.dart';
import 'package:hg_notification_firebase_example/screens/home_screen.dart';
import 'package:hg_notification_firebase_example/screens/splash_screen.dart';
import 'package:hg_notification_firebase_example/utils/helper.dart';

class RouteGenerator {
  static const _id = 'RouteGenerator';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments as dynamic;
    log(_id, msg: "Pushed ${settings.name}(${args ?? ''})");
    switch (settings.name) {
      case SplashScreen.id:
        return _route(const SplashScreen());
      case HomeScreen.id:
        return _route(const HomeScreen());
      case DetailScreen.id:
        if (settings.arguments != null) {
          final payload = settings.arguments as Map<String, dynamic>;
          return _route(DetailScreen(payload: payload));
        }
        return _errorRoute(settings.name);
      default:
        return _errorRoute(settings.name);
    }
  }

  static MaterialPageRoute _route(Widget widget) =>
      MaterialPageRoute(builder: (context) => widget);

  static Route<dynamic> _errorRoute(String? name) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('ROUTE \n\n$name\n\nNOT FOUND'),
        ),
      ),
    );
  }
}