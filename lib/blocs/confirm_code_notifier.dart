import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';

class ConfirmCodeNotifier with ChangeNotifier {
  static int _isolateCounter = 0;
  int _sendAgainCounter = 30;
  Isolate _timerIsolate;
  ReceivePort _receivePort;

  int get sendAgainCounter => _sendAgainCounter;

  Future<void> startIsolatedTimer() async {
    _receivePort?.close();
    _timerIsolate?.kill(priority: Isolate.immediate);
    _sendAgainCounter = 30;
    _receivePort = ReceivePort();
    _timerIsolate = await Isolate.spawn(_sendAgainTimer, _receivePort.sendPort);
    _receivePort.listen((dynamic data) {
      if (data >= 0) {
        print(data);
        _sendAgainCounter = data;
        notifyListeners();
      } else {
        _receivePort?.close();
        _timerIsolate?.kill(priority: Isolate.immediate);
      }
    }, onDone: () {});
  }

  static void _sendAgainTimer(SendPort sendPort) {
    _isolateCounter = 30;
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      _isolateCounter--;
      sendPort.send(_isolateCounter);
    });
  }
}
