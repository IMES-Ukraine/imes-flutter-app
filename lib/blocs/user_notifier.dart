import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:imes/models/cover_image.dart';

import 'package:imes/models/user.dart' as local;
import 'package:imes/models/user_basic_info.dart';
import 'package:imes/models/user_financial_info.dart';
import 'package:imes/models/user_special_info.dart';

import 'package:imes/resources/repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final userNotifierProvider = ChangeNotifierProvider<UserNotifier>((ref) => UserNotifier());

enum AppState {
  authorized,
  none,
}

// final dbUserProvider = FutureProvider<User>((ref) {

// });

final userStateProvider = StateProvider<local.User>((ref) => null);
final appStateProvider = StateProvider<AppState>((ref) => AppState.none);
final notificationsCountProvider = StateProvider<int>((ref) => 0);

enum AuthState {
  AUTHENTICATED,
  // AUTHENTICATING,
  // VERIFYING,/
  // NOT_VERIFIED,
  NOT_AUTHENTICATED,
}

class UserNotifier with ChangeNotifier {
  AuthState _state = AuthState.NOT_AUTHENTICATED;
  local.User _user;

  StreamSubscription<String> _tokenRefreshSubscription;

  UserNotifier({AuthState state, local.User user})
      : _user = user,
        _state = state = AuthState.NOT_AUTHENTICATED;

  AuthState get state => _state;

  local.User get user => _user;

  Future<void> initFirebase() async {
    final _firebaseMessaging = FirebaseMessaging();
    ;
    _tokenRefreshSubscription = _firebaseMessaging.onTokenRefresh.listen((newToken) {
      Repository().api.submitToken(token: newToken);
    });

    await FirebaseAuth.instance.signInWithCustomToken(_user.firebaseToken);
  }

  Future<void> login(String login, String password) async {
    final response = await Repository().api.login('$login@imes.pro', password);
    _user = response.user;
    _state = AuthState.AUTHENTICATED;
    notifyListeners();
    return initFirebase();
  }

  Future<void> auth(String phone) async {
    final response = await Repository().auth.auth(phone);
    print(response.data);
  }

  Future<void> verify(String phone, String code) async {
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
    final profileResponse = await Repository().api.profile();
    _user = profileResponse.data.user;
    notifyListeners();
    return initFirebase();
  }

  Future<void> setupPwd(String pwd) async {
    await Repository().api.submitPassword(pwd);
    _state = AuthState.AUTHENTICATED;
    notifyListeners();
  }

  void updateUser(local.User user) {
    _user = user;
    notifyListeners();
  }

  Future<void> submitProfile(
      UserBasicInfo basicInfo, UserSpecializedInfo spcializedInfo, UserFinancialInfo userFinancialInfo) async {
    final response = await Repository().api.submitProfile(basicInfo, spcializedInfo, userFinancialInfo);
    updateUser(response.data.user);
  }

  Future<local.User> updateProfile() async {
    final response = await Repository().api.profile();
    if (_state != AuthState.AUTHENTICATED) {
      _state = AuthState.AUTHENTICATED;
    }
    updateUser(response.data.user);
    initFirebase();
    return response.data.user;
  }

  void updateEducationDocument(CoverImage doc) {
    // _user = _user.specializedInformation.educationDocument = doc;
  }

  void updateBalance(int newBalance) {
    _user = _user.copyWith(balance: newBalance);
    notifyListeners();
  }

  void logout() async {
    _state = AuthState.NOT_AUTHENTICATED;
    final storage = FlutterSecureStorage();
    await storage.delete(key: '__AUTH_TOKEN_');
    _tokenRefreshSubscription?.cancel();
    _user = null;
    notifyListeners();
  }

  Future<void> uploadEducationDocument(String path) async {
    final response = await Repository().api.uploadEducationDoc(path);
    // if (response.statusCode == 200) {
    if (user.specializedInformation != null) {
      _user = user.copyWith(
        specializedInformation: user.specializedInformation.copyWith(
          educationDocument: response.data,
        ),
      );
    } else {
      _user = user.copyWith(specializedInformation: UserSpecializedInfo(educationDocument: response.data));
    }
    notifyListeners();
    // }
  }

  Future<void> uploadProfilePicture(String path) async {
    final response = await Repository().api.uploadProfileImage(path);
    // if (response.statusCode == 200) {
    if (_user.basicInformation != null) {
      _user.copyWith(basicInformation: _user.basicInformation.copyWith(avatar: response.data));
    } else {
      _user.copyWith(basicInformation: UserBasicInfo(avatar: response.data));
    }
    notifyListeners();
    // }
  }
}
