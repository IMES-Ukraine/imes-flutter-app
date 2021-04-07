import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:imes/models/blog.dart';
import 'package:imes/models/cover_image.dart';
import 'package:imes/screens/login.dart';
import 'package:imes/screens/home.dart';

import 'package:imes/blocs/user_notifier.dart';
import 'package:imes/helpers/timeago_ua_messages.dart';
import 'package:imes/utils/constants.dart';

import 'package:provider/provider.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:timeago/timeago.dart' as timeago;

import 'package:imes/models/user.dart' as local;
import 'package:imes/resources/repository.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' hide ChangeNotifierProvider, Consumer;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_flipperkit/flutter_flipperkit.dart';

import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final flipperClient = FlipperClient.getDefault();

  flipperClient.addPlugin(FlipperNetworkPlugin(
      // If you use http library, you must set it to false and use https://pub.dev/packages/flipperkit_http_interceptor
      // useHttpOverrides: false,
      // Optional, for filtering request
      filter: (HttpClientRequest request) {
    final url = '${request.uri}';
    if (url.startsWith('https://echo.myftp.org/storage/app/uploads')) {
      return false;
    }
    return true;
  }));

  flipperClient.addPlugin(FlipperSharedPreferencesPlugin());
  flipperClient.start();

  await Firebase.initializeApp();

  timeago.setLocaleMessages('uk', UaMessages());

  final storage = FlutterSecureStorage();
  final token = await storage.read(key: '__AUTH_TOKEN_');

  await Hive.initFlutter();
  Hive.registerAdapter(BlogAdapter());
  Hive.registerAdapter(CoverImageAdapter());
  await Hive.openBox(Constants.FAVORITES_BOX);

  local.User user;
  if (token != null) {
    try {
      final response = await Repository().api.profile();
      if (response.statusCode == 200) {
        print('authenticated');
        user = response.body.data.user;
        final auth = FirebaseAuth.instance;
        final authResult = await auth.signInWithCustomToken(response.body.data.user.firebaseToken);
        final token = await FirebaseMessaging.instance.getToken();
        final result = await Repository().api.submitToken(token: token);
        FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
          Repository().api.submitToken(token: newToken);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  runApp(ChangeNotifierProvider(
      create: (_) {
        return UserNotifier(
            state: token != null && user != null ? AuthState.AUTHENTICATED : AuthState.NOT_AUTHENTICATED, user: user);
      },
      child: ProviderScope(child: MyApp())));
}

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserNotifier>(builder: (context, userNotifier, _) {
      return LayoutBuilder(builder: (context, constraints) {
        return OrientationBuilder(builder: (context, orientation) {
          SizerUtil().init(constraints, orientation);
          return MaterialApp(
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('uk'),
            ],
            theme: ThemeData(
              fontFamily: 'Montserrat',
              primaryColor: const Color(0xFF00B7FF),
              accentColor: const Color(0xFF00D7FF),
              scaffoldBackgroundColor: const Color(0xFFF7F7F9),
              errorColor: const Color(0xFFFF5C8E),
              dividerColor: const Color(0xFFE0E0E0),
              canvasColor: const Color(0xFFF2F2F2),
              appBarTheme: AppBarTheme(
                  color: Colors.white,
                  elevation: 4.0,
                  iconTheme: IconThemeData(
                    color: const Color(0xFF00B7FF),
                  ),
                  actionsIconTheme: IconThemeData(
                    color: const Color(0xFF00B7FF),
                  )),
            ),
            home: userNotifier.state == AuthState.AUTHENTICATED ? HomePage() : LoginPage(),
          );
        });
      });
    });
  }
}
