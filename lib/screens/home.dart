import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:pharmatracker/helpers/bottom_icons.dart';
import 'package:pharmatracker/screens/blogs.dart';
import 'package:pharmatracker/screens/analytics.dart';
import 'package:pharmatracker/screens/report.dart';
import 'package:pharmatracker/screens/balance.dart';
import 'package:pharmatracker/screens/menu.dart';
import 'package:pharmatracker/screens/blog_view.dart';
import 'package:pharmatracker/screens/balance_history.dart';
import 'package:pharmatracker/screens/support.dart';
import 'package:pharmatracker/screens/test_view.dart';
import 'package:pharmatracker/screens/tests.dart';

import 'package:provider/provider.dart';

import 'package:pharmatracker/blocs/user_notifier.dart';
import 'package:pharmatracker/blocs/home_notifier.dart';

import 'package:pharmatracker/helpers/size_config.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  final GlobalKey<NavigatorState> _blogsNavigatorKey = GlobalKey();
  final GlobalKey<NavigatorState> _analyticsNavigatorKey = GlobalKey();
  final GlobalKey<NavigatorState> _balanceNavigatorKey = GlobalKey();
  final GlobalKey<NavigatorState> _menuNavigatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

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
            print(e.toString());
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
    SizeConfig().init(context);

    final themeData = Theme.of(context);
    return ChangeNotifierProvider(
      create: (_) {
        final homeNotifier = HomeNotifier(controller: _pageController);
        final userNotifier = Provider.of<UserNotifier>(context);
        final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
        _firebaseMessaging.requestNotificationPermissions();
        _firebaseMessaging.configure(onMessage: (message) {
          debugPrint('onMessage: $message');
          userNotifier.increaseNotificationsCount();
          final data = message['data'];
          if (data != null) {
            final int newBalance = int.parse(data['balance']);
            if (newBalance != null) {
              userNotifier.updateBalance(newBalance);
            }
          }
          return;
        }, onLaunch: (message) {
          debugPrint('onLaunch: $message');
          _redirect(message, homeNotifier);
          return;
        }, onResume: (message) {
          debugPrint('onResume: $message');
          _redirect(message, homeNotifier);
          return;
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

            if (homeNotifier.currentPage == 3) {
              if (await _balanceNavigatorKey.currentState.maybePop()) {
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
              onPageChanged: homeNotifier.changePage,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                Navigator(
                  key: _blogsNavigatorKey,
                  initialRoute: '/',
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
                  initialRoute: '/',
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
                ReportsPage(),
                Navigator(
                  key: _balanceNavigatorKey,
                  initialRoute: '/',
                  onGenerateRoute: (routeSettings) {
                    return MaterialPageRoute(
                      builder: (context) {
                        switch (routeSettings.name) {
                          case '/':
                            return BalancePage();
                          case '/balance/history':
                            return BalanceHistoryPage();
                          default:
                            return BalancePage();
                        }
                      },
                    );
                  },
                ),
                Navigator(
                  key: _menuNavigatorKey,
                  initialRoute: '/',
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
            // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            // floatingActionButton: FloatingActionButton(
            //   child: Icon(Icons.add),
            //   onPressed: () {},
            // ),
            bottomNavigationBar: BottomNavigationBar(
//                backgroundColor: const Color(0xFFE9EAEC),
                selectedItemColor: themeData.primaryColor,
                unselectedItemColor: const Color(0xFFA1A1A1),
                type: BottomNavigationBarType.fixed,
                unselectedFontSize: 10.0,
                selectedFontSize: 10.0,
                iconSize: 26.0,
                currentIndex: homeNotifier.currentPage,
                onTap: homeNotifier.changePage,
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      title: Text(
                        'Головна',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  BottomNavigationBarItem(
                      icon: Icon(MyFlutterApp.test), //Image.asset('assets/tests.png'),
                      title: Text(
                        'Дослідження',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  BottomNavigationBarItem(
                      icon: Icon(MyFlutterApp.chat), //Image.asset('assets/chat.png'),
                      title: Text(
                        'Чат',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  BottomNavigationBarItem(
                      icon: Icon(MyFlutterApp.clients), //Image.asset('assets/clients.png'),
                      title: Text(
                        'Пацієнти',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  BottomNavigationBarItem(
                      icon: Icon(MyFlutterApp.menu), //Image.asset('assets/menu.png'),
                      title: Text(
                        'Меню',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                ]),
          ),
        );
      }),
    );
  }
}
