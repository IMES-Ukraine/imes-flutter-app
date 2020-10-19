import 'package:flutter/material.dart';
import 'package:pharmatracker/screens/login.dart';
import 'package:pharmatracker/screens/home.dart';

import 'package:pharmatracker/blocs/user_notifier.dart';
import 'package:pharmatracker/helpers/timeago_ua_messages.dart';

import 'package:provider/provider.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:timeago/timeago.dart' as timeago;

import 'package:pharmatracker/models/user.dart';
import 'package:pharmatracker/resources/repository.dart';

import 'package:flutter_stetho/flutter_stetho.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  timeago.setLocaleMessages('ua', UaMessages());

//  final FirebaseApp app = await FirebaseApp.configure(
//    name: 'test',
//    options: FirebaseOptions(
//      googleAppID: Platform.isIOS
//          ? '1:159623150305:ios:4a213ef3dbd8997b'
//          : '1:150670604014:android:dcf0c585896c6f10',
//      gcmSenderID: '150670604014',
//      apiKey: 'AIzaSyA3ZRJdaLzp7JA7zYyhZor9RqoS_qc7yLo',
//      projectID: 'tlogic-aed50',
//    ),
//  );
//  final FirebaseStorage storage = FirebaseStorage(
//      app: app, storageBucket: 'gs://tlogic-aed50.appspot.com/');

  Stetho.initialize();
  final storage = FlutterSecureStorage();
  final token = await storage.read(key: '__AUTH_TOKEN_');

  User user;
  if (token != null) {
    try {
      final response = await Repository().api.profile();
      if (response.statusCode == 200) {
        user = response.body.data.user;
        final FirebaseAuth auth = FirebaseAuth.instance;
        final authResult = await auth.signInWithCustomToken(token: response.body.data.user.firebaseToken);
        final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
        final String token = await _firebaseMessaging.getToken();
        final result = await Repository().api.submitToken(token: token);
        _firebaseMessaging.onTokenRefresh.listen((newToken) {
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
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserNotifier>(builder: (context, userNotifier, _) {
      return MaterialApp(
        localizationsDelegates: [
//          MaterialLocalizationUk(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('uk'),
//          const Locale('en'),
        ],
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Montserrat',
          primaryColor: Color(0xFF00B7FF),
          accentColor: Color(0xFF00B7FF),
          scaffoldBackgroundColor: Color(0xFFF7F7F9),
          appBarTheme: AppBarTheme(
              color: Colors.white,
              // elevation: 0.0,
              iconTheme: IconThemeData(
                color: Color(0xFF00B7FF),
              ),
              actionsIconTheme: IconThemeData(
                color: Color(0xFF00B7FF),
              )),
        ),
        home: userNotifier.state == AuthState.AUTHENTICATED ? HomePage() : LoginPage(),
      );
    });
  }
}
