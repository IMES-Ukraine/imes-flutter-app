import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:imes/resources/repository.dart';

import 'package:firebase_storage/firebase_storage.dart';

enum ReportsState {
  NOT_ADDED,
  UPLOADING,
  ADDED,
}

class ReportsNotifier with ChangeNotifier {
  ReportsState _state = ReportsState.NOT_ADDED;
  int _count = 1;
  int _amount = 25;
  double _progress = 0;
  File _reportFile;
  TimeOfDay _timeOfDay = TimeOfDay.now();

  File get image => _reportFile;

  int get count => _count;

  int get amount => _amount;

  double get progress => _progress;

  TimeOfDay get timeOfDay => _timeOfDay;

  ReportsState get state => _state;

  Future chooseImage(File file) async {
    _reportFile = file;
    _state = ReportsState.ADDED;
    notifyListeners();
  }

  Future uploadImage() async {
    if (_state != ReportsState.ADDED) {
      return;
    }

    _state = ReportsState.UPLOADING;
    notifyListeners();

    String reportIdString = '';
    int reportId = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < 8; i++) {
      reportIdString += '${reportId % 10}';
      reportId = reportId ~/ 10;
    }

    final resultId = int.parse(reportIdString);
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('bills/${resultId.toRadixString(16)}.jpg');
    final StorageUploadTask task = firebaseStorageRef.putFile(_reportFile);
    task.events.listen((event) {
      _progress = event.snapshot.bytesTransferred / event.snapshot.totalByteCount;
      notifyListeners();
    });

    String _addLeadingZeroIfNeeded(int value) {
      if (value < 10) return '0$value';
      return value.toString();
    }

    final String hourLabel = _addLeadingZeroIfNeeded(_timeOfDay.hour);
    final String minuteLabel = _addLeadingZeroIfNeeded(_timeOfDay.minute);
    final String creationTime = '$hourLabel:$minuteLabel';

    print(creationTime);

    final snapshot = await task.onComplete;
    final response = await Repository().api.postAnalytics(
          id: resultId.toRadixString(16),
          grams: _amount,
          count: _count,
          creationTime: creationTime,
        );
  }

  chooseTime(TimeOfDay value) {
    _timeOfDay = value;
    notifyListeners();
  }

  chooseAmount(int value) {
    _amount = value;
    notifyListeners();
  }

  incrementCount() {
    if (_count < 100) {
      _count = _count + 1;
      notifyListeners();
    }
  }

  decrementCount() {
    if (_count > 1) {
      _count = _count - 1;
      notifyListeners();
    }
  }

  void resetState() {
    _state = ReportsState.NOT_ADDED;
    _amount = 25;
    _progress = 0;
    notifyListeners();
  }
}
