import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

enum SupportState {
  LOADING,
  LOADED,
}

class SupportNotifier with ChangeNotifier {
  SupportState _state = SupportState.LOADING;

  SupportState get state => _state;

  Future load(int userId) async {
    final userDocument = FirebaseFirestore.instance.collection('sessions').doc('$userId');
    _state = SupportState.LOADED;
    notifyListeners();
  }
}
