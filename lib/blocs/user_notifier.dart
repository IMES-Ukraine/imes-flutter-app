import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:imes/models/cover_image.dart';

import 'package:imes/models/user.dart' as local;
import 'package:imes/models/user_basic_info.dart';
import 'package:imes/models/user_special_info.dart';

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

  StreamSubscription<String> _tokenRefreshSubscription;

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
      _tokenRefreshSubscription = _firebaseMessaging.onTokenRefresh.listen((newToken) {
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

    String deviceId;
    String deviceName;
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.androidId;
      deviceName = androidInfo.model;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
      deviceName = iosInfo.utsname.machine;
    } else {}

    final response =
        await Repository().auth.verify(phone: phone, code: code, deviceId: deviceId, deviceName: deviceName);
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

  void updateEducationDocument(CoverImage doc) {
    // _user = _user.specializedInformation.educationDocument = doc;
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
    _user = null;
    _state = AuthState.NOT_AUTHENTICATED;
    final storage = FlutterSecureStorage();
    await storage.delete(key: '__AUTH_TOKEN_');
    _tokenRefreshSubscription.cancel();
    Repository().create();
    notifyListeners();
  }

  Future<void> uploadEducationDocument(String path) async {
    final response = await Repository().api.uploadEducationDoc(path);
    if (response.statusCode == 200) {
      if (user.specializedInformation != null) {
        _user = user.copyWith(
          specializedInformation: user.specializedInformation.copyWith(
            educationDocument: response.body.data,
          ),
        );
      } else {
        _user = user.copyWith(specializedInformation: UserSpecializedInfo(educationDocument: response.body.data));
      }
      notifyListeners();
    }
  }

  Future<void> uploadPassport(String path) async {
    final response = await Repository().api.uploadPassport(path);
    if (response.statusCode == 200) {
      if (user.specializedInformation != null) {
        _user = user.copyWith(
          specializedInformation: user.specializedInformation.copyWith(
            passport: response.body.data,
          ),
        );
      } else {
        _user = user.copyWith(specializedInformation: UserSpecializedInfo(passport: response.body.data));
      }
      notifyListeners();
    }
  }

  Future<void> uploadProfilePicture(String path) async {
    final response = await Repository().api.uploadProfileImage(path);
    if (response.statusCode == 200) {
      if (_user.basicInformation != null) {
        _user = _user.copyWith(basicInformation: _user.basicInformation.copyWith(avatar: response.body.data));
      } else {
        _user = _user.copyWith(basicInformation: UserBasicInfo(avatar: response.body.data));
      }
      notifyListeners();
    }
  }
}
