import 'package:flutter/foundation.dart';

import 'package:pharmatracker/models/user.dart';

import 'package:pharmatracker/resources/repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

enum AuthState {
  AUTHENTICATED,
  AUTHENTICATING,
  VERIFYING,
  NOT_VERIFIED,
  NOT_AUTHENTICATED,
}

class UserNotifier with ChangeNotifier {
  AuthState _state = AuthState.NOT_AUTHENTICATED;
  User _user;

  int _notifications = 0;

  UserNotifier({AuthState state, User user})
      : _user = user,
        _state = state;

  AuthState get state => _state;

  User get user => _user;

  int get notificationsCount => _notifications;

  Future login(String login, String password) async {
    _state = AuthState.AUTHENTICATING;
    notifyListeners();

    final response = await Repository().api.login(login, password);
    if (response.statusCode == 200) {
      _user = response.body.user;
      _state = AuthState.AUTHENTICATED;

      final storage = FlutterSecureStorage();
      await storage.write(key: '__AUTH_TOKEN_', value: response.body.token);

      final FirebaseAuth auth = FirebaseAuth.instance;
      final authResult = await auth.signInWithCustomToken(token: response.body.user.firebaseToken);
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
      final String token = await _firebaseMessaging.getToken();
      final result = await Repository().api.submitToken(token: token);
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        Repository().api.submitToken(token: newToken);
      });

      notifyListeners();
    }
  }

  Future<bool> auth(String phone) async {
    _state = AuthState.AUTHENTICATING;
    notifyListeners();

    final response = await Repository().auth.auth(phone);
    if (response.statusCode == 200) {
      _state = AuthState.NOT_VERIFIED;
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<void> verify(String phone, String code) async {
    _state = AuthState.VERIFYING;
    notifyListeners();

    final response = await Repository().auth.verify(phone: phone, code: code, deviceId: '123', deviceName: 'name');
    if (response.statusCode == 200) {
      _user = response.body.user;
      _state = AuthState.AUTHENTICATED;

      final storage = FlutterSecureStorage();
      await storage.write(key: '__AUTH_TOKEN_', value: response.body.token);

      final FirebaseAuth auth = FirebaseAuth.instance;
      // final authResult = await auth.signInWithCustomToken(token: response.body.user.firebaseToken);
      final authResult = await auth.signInWithCustomToken(token: response.body.token);
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
      final String token = await _firebaseMessaging.getToken();
      final result = await Repository().api.submitToken(token: token);
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        Repository().api.submitToken(token: newToken);
      });

      notifyListeners();
    }
  }

  void updateUser(User user) {
    _user = user;
    notifyListeners();
  }

  Future updateProfile() async {
    final response = await Repository().api.profile();
    if (response.statusCode == 200) {
      updateUser(response.body.data.user);
    }
  }

  void updateBalance(int newBalance) {
    _user = _user.copyWith(balance: newBalance);
    notifyListeners();
  }

  void resetState() {
    _state = AuthState.NOT_AUTHENTICATED;
    notifyListeners();
  }

  void increaseNotificationsCount() {
    _notifications++;
    notifyListeners();
  }

  void resetNotificationsCount() {
    _notifications = 0;
    notifyListeners();
  }

  void logout() async {
    _state = AuthState.NOT_AUTHENTICATED;
    final storage = FlutterSecureStorage();
    await storage.delete(key: '__AUTH_TOKEN_');
    Repository().create();
    notifyListeners();
  }
}
