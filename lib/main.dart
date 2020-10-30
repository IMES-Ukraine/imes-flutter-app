import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:imes/screens/login.dart';
import 'package:imes/screens/home.dart';

import 'package:imes/blocs/user_notifier.dart';
import 'package:imes/helpers/timeago_ua_messages.dart';

import 'package:provider/provider.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:timeago/timeago.dart' as timeago;

import 'package:imes/models/user.dart' as local;
import 'package:imes/resources/repository.dart';

import 'package:flutter_stetho/flutter_stetho.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:pedantic/pedantic.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true // optional: set false to disable printing logs to console
      );

  await Firebase.initializeApp();

  timeago.setLocaleMessages('uk', UaMessages());

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

  unawaited(Stetho.initialize());

  final storage = FlutterSecureStorage();
  final token = await storage.read(key: '__AUTH_TOKEN_');

  local.User user;
  if (token != null) {
    print('authenticated');
    try {
      final response = await Repository().api.profile();
      if (response.statusCode == 200) {
        user = response.body.data.user;
        final auth = FirebaseAuth.instance;
        final authResult = await auth.signInWithCustomToken(response.body.data.user.firebaseToken);
        final _firebaseMessaging = FirebaseMessaging();
        final token = await _firebaseMessaging.getToken();
        final result = await Repository().api.submitToken(token: token);
        _firebaseMessaging.onTokenRefresh.listen((newToken) {
          Repository().api.submitToken(token: newToken);
        });
      }
    } catch (e) {
      print(e);
      rethrow;
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
  }
}
