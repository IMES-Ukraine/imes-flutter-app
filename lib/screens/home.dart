import 'package:flutter/material.dart';
import 'package:imes/helpers/custom_icons_icons.dart';
import 'package:imes/screens/blogs.dart';
import 'package:imes/screens/instructions.dart';
import 'package:imes/screens/menu.dart';
import 'package:imes/screens/blog_view.dart';
import 'package:imes/screens/support.dart';
import 'package:imes/screens/test_view.dart';
import 'package:imes/screens/tests.dart';
import 'package:imes/widgets/base/bottom_appbar_button.dart';

import 'package:provider/provider.dart';

import 'package:imes/blocs/user_notifier.dart';
import 'package:imes/blocs/home_notifier.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  final GlobalKey<NavigatorState> _blogsNavigatorKey = GlobalKey();
  final GlobalKey<NavigatorState> _analyticsNavigatorKey = GlobalKey();
  final GlobalKey<NavigatorState> _menuNavigatorKey = GlobalKey();

  void _redirect(final message, final homeNotifier) {
    final data = message['data'];
    if (data != null) {
      final type = data['type'];
      print(type);
      if (type == 'NEWS') {
        final action = data['action'];
        if (action != null) {
          final values = data['action'].split(':');
          try {
            final id = num.parse(values[1]);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlogViewPage(id)));
          } catch (e) {
            print(e);
          }
        }
      }

      if (type == 'SUPPORT') {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => SupportPage()),
        );
      }

      if (type == 'REFILL') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          homeNotifier.changePage(3);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return ChangeNotifierProvider(
      create: (_) {
        final homeNotifier = HomeNotifier(controller: _pageController);
        final userNotifier = Provider.of<UserNotifier>(context);
        FirebaseMessaging.instance.requestPermission();
        FirebaseMessaging.instance.getInitialMessage().then((message) {
          if (message != null) {
            _redirect(message, homeNotifier);
          }
        });
        FirebaseMessaging.onMessage.listen((message) {
          debugPrint('onMessage: ${message.data}');
          userNotifier.increaseNotificationsCount();
          final data = message.data;
          if (data != null) {
            final newBalance = int.parse(data['balance']);
            if (newBalance != null) {
              userNotifier.updateBalance(newBalance);
            }
          }
        });
        SharedPreferences.getInstance().then((prefs) async {
          final allEnabled = prefs.getBool('all') ?? true;
          final newsEnabled = prefs.getBool('news') ?? true;
          final testsEnabled = prefs.getBool('tests') ?? true;
          final balanceEnabled = prefs.getBool('balance') ?? true;
          final messagesEnabled = prefs.getBool('messages') ?? true;

          if (allEnabled) {
            FirebaseMessaging.instance.subscribeToTopic('news');
            FirebaseMessaging.instance.subscribeToTopic('tests');
            FirebaseMessaging.instance.subscribeToTopic('balance');
            FirebaseMessaging.instance.subscribeToTopic('messages');
          } else {
            if (newsEnabled) {
              FirebaseMessaging.instance.subscribeToTopic('news');
            }

            if (testsEnabled) {
              FirebaseMessaging.instance.subscribeToTopic('tests');
            }

            if (balanceEnabled) {
              FirebaseMessaging.instance.subscribeToTopic('balance');
            }

            if (messagesEnabled) {
              FirebaseMessaging.instance.subscribeToTopic('messages');
            }
          }
        });
        return homeNotifier;
      },
      child: Consumer<HomeNotifier>(builder: (context, homeNotifier, _) {
        return WillPopScope(
          onWillPop: () async {
            if (homeNotifier.currentPage == 0) {
              if (await _blogsNavigatorKey.currentState.maybePop()) {
                return false;
              }
            }

            if (homeNotifier.currentPage == 1) {
              if (await _analyticsNavigatorKey.currentState.maybePop()) {
                return false;
              }
            }

            if (homeNotifier.currentPage == 4) {
              if (await _menuNavigatorKey.currentState.maybePop()) {
                return false;
              }
            }

            return true;
          },
          child: Scaffold(
            body: PageView(
              controller: _pageController,
              onPageChanged: (val) {
                FocusScope.of(context).unfocus();
                homeNotifier.changePage(val);
              },
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                Navigator(
                  key: _blogsNavigatorKey,
                  initialRoute: homeNotifier.initialPageRoute,
                  onGenerateRoute: (routeSettings) {
                    return MaterialPageRoute(
                      builder: (context) {
                        switch (routeSettings.name) {
                          case '/':
                            return BlogsPage();
                          case '/blogs/view':
                            return BlogViewPage(routeSettings.arguments);
                          default:
                            return BlogsPage();
                        }
                      },
                    );
                  },
                ),
                Navigator(
                  key: _analyticsNavigatorKey,
                  initialRoute: homeNotifier.initialPageRoute,
                  onGenerateRoute: (routeSettings) {
                    return MaterialPageRoute(builder: (context) {
                      switch (routeSettings.name) {
                        case '/':
                          return TestsPage();
                        case '/tests/view':
                          return TestViewPage(routeSettings.arguments);
                        default:
                          return TestsPage();
                      }
                    });
                  },
                ),
                Navigator(
                  // key: _menuNavigatorKey,
                  initialRoute: homeNotifier.initialPageRoute,
                  onGenerateRoute: (routeSettings) {
                    return MaterialPageRoute(builder: (context) {
                      switch (routeSettings.name) {
                        case '/':
                          return SupportPage();
                        default:
                          return SupportPage();
                      }
                    });
                  },
                ),
                InstructionsPage(),
                Navigator(
                  key: _menuNavigatorKey,
                  initialRoute: homeNotifier.initialPageRoute,
                  onGenerateRoute: (routeSettings) {
                    return MaterialPageRoute(builder: (context) {
                      switch (routeSettings.name) {
                        case '/':
                          return MenuPage();
                        default:
                          return MenuPage();
                      }
                    });
                  },
                ),
              ],
            ),
            bottomNavigationBar: SafeArea(
              child: BottomAppBar(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BottomAppBarButton(
                        icon: CustomIcons.home,
                        label: 'Головна',
                        selected: homeNotifier.currentPage == 0,
                        onTap: () {
                          if (homeNotifier.currentPage != 0) {
                            homeNotifier.changePage(0);
                          } else {
                            _blogsNavigatorKey.currentState.pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
                          }
                        }),
                    BottomAppBarButton(
                        icon: CustomIcons.test,
                        label: 'Дослідження',
                        selected: homeNotifier.currentPage == 1,
                        onTap: () => homeNotifier.changePage(1)),
                    BottomAppBarButton(
                        icon: CustomIcons.chat,
                        label: 'Підтримка',
                        selected: homeNotifier.currentPage == 2,
                        onTap: () => homeNotifier.changePage(2)),
                    BottomAppBarButton(
                        icon: Icons.info_rounded,
                        label: 'Інструкція',
                        selected: homeNotifier.currentPage == 3,
                        onTap: () => homeNotifier.changePage(3)),
                    BottomAppBarButton(
                        icon: CustomIcons.menu,
                        label: 'Меню',
                        selected: homeNotifier.currentPage == 4,
                        onTap: () => homeNotifier.changePage(4)),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
