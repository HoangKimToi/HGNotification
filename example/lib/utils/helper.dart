import 'dart:developer' as devtools show log;

import 'package:flutter/material.dart';
import 'package:hg_notification_firebase_example/utils/globals.dart';

void showSnackBar(String text, {
  Duration duration = const Duration(seconds: 20)
}) {
  Globals.scaffoldMessengerKey.currentState?..clearSnackBars()
      ..showSnackBar(
        SnackBar(content: Text(text), duration: duration,)
      );
}

bool isNullOrBlank(String? data) => data?.trim().isEmpty ?? true;

void log(String screenId, {
  dynamic msg,
  dynamic error,
  StackTrace? stackTrace,
}) => devtools.log(msg.toString(),error: error, name: screenId, stackTrace: stackTrace);