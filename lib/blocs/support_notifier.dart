import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

enum SupportState {
  LOADING,
  LOADED,
}

class SupportNotifier with ChangeNotifier {
  SupportState _state = SupportState.LOADING;

  Future load(int userId) async {
    final userDocument = Firestore.instance.collection('sessions').document('$userId');
  }
}