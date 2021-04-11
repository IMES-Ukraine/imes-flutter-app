import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';

StreamController<bool> useLocalStorageBool(
  String key, {
  bool defaultValue = false,
}) {
  final controller = useStreamController<bool>(keys: [key]);
  
  useEffect(
    () {
      final sub = controller.stream.listen((data) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(key, data);
        if (key != 'all') {
          if (data) {
            FirebaseMessaging.instance.subscribeToTopic(key);
          } else {
            FirebaseMessaging.instance.unsubscribeFromTopic(key);
          }
        }
      });

      return sub.cancel;
    },
    [controller, key],
  );

  useEffect(
    () {
      SharedPreferences.getInstance().then((prefs) async {
        final valueFromStorage = prefs.getBool(key);
        controller.add(valueFromStorage ?? defaultValue);
      }).catchError(controller.addError);
      return null;
    },
    [controller, key],
  );

  return controller;
}
