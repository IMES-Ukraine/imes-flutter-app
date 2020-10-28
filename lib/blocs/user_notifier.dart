import 'package:flutter/foundation.dart';

import 'package:imes/models/user.dart' as local;

import 'package:imes/resources/repository.dart';
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
  local.User _user;

  int _notifications = 0;

  UserNotifier({AuthState state, local.User user})
      : _user = user,
        _state = state;

  AuthState get state => _state;

  local.User get user => _user;

  int get notificationsCount => _notifications;

  Future login(String login, String password) async {
    _state = AuthState.AUTHENTICATING;
    notifyListeners();

    final response = await Repository().api.login('$login@imes.pro', password);
    if (response.statusCode == 200) {
      _user = response.body.user;
      _state = AuthState.AUTHENTICATED;

      final storage = FlutterSecureStorage();
      await storage.write(key: '__AUTH_TOKEN_', value: response.body.token);

      final auth = FirebaseAuth.instance;
      final authResult = await auth.signInWithCustomToken(response.body.user.firebaseToken);
      final _firebaseMessaging = FirebaseMessaging();
      final token = await _firebaseMessaging.getToken();
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
      final storage = FlutterSecureStorage();
      await storage.write(key: '__AUTH_TOKEN_', value: response.body.token);

      final profileResponse = await Repository().api.profile();
      if (profileResponse.statusCode == 200) {
        _user = profileResponse.body.data.user;
        _state = AuthState.AUTHENTICATED;

        final auth = FirebaseAuth.instance;
        final authResult = await auth.signInWithCustomToken(profileResponse.body.data.user.firebaseToken);
        final _firebaseMessaging = FirebaseMessaging();
        final token = await _firebaseMessaging.getToken();
        final result = await Repository().api.submitToken(token: token);
        _firebaseMessaging.onTokenRefresh.listen((newToken) {
          Repository().api.submitToken(token: newToken);
        });

        notifyListeners();
      }
    }
  }

  Future<void> setupPwd(String pwd) async {
    final response = await Repository().api.submitPassword(pwd);
  }

  void updateUser(local.User user) {
    _user = user;
    notifyListeners();
  }

  Future submitProfile(Map<String, dynamic> data) async {
    final response = await Repository().api.submitProfile(data);
    if (response.statusCode == 200) {
      updateUser(response.body.data.user);
    }
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
