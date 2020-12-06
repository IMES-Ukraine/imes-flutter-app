import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imes/helpers/custom_icons_icons.dart';
import 'package:imes/screens/blogs.dart';
import 'package:imes/screens/balance.dart';
import 'package:imes/screens/menu.dart';
import 'package:imes/screens/blog_view.dart';
import 'package:imes/screens/balance_history.dart';
import 'package:imes/screens/support.dart';
import 'package:imes/screens/test_view.dart';
import 'package:imes/screens/tests.dart';

import 'package:provider/provider.dart';

import 'package:imes/blocs/user_notifier.dart';
import 'package:imes/blocs/home_notifier.dart';

import 'package:imes/helpers/size_config.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

class HomePage extends HookWidget {
  // final PageController _pageController = PageController();

  final GlobalKey<NavigatorState> _blogsNavigatorKey = GlobalKey();
  final GlobalKey<NavigatorState> _analyticsNavigatorKey = GlobalKey();
  final GlobalKey<NavigatorState> _balanceNavigatorKey = GlobalKey();
  final GlobalKey<NavigatorState> _menuNavigatorKey = GlobalKey();

  void _redirect(final context, final message, final homeNotifier) {
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

    final pageController = usePageController();
    final userNotifier = useProvider(userNotifierProvider);
    final notificationsCount = useProvider(notificationsCountProvider);
    final homeNotifier = useProvider(homeNotifierProvider(pageController));
    final themeData = Theme.of(context);

    useEffect(() {
      final firebaseMessaging = FirebaseMessaging();
      firebaseMessaging.requestNotificationPermissions();
      firebaseMessaging.configure(onMessage: (message) {
        debugPrint('onMessage: $message');
        notificationsCount.state++;
        final data = message['data'];
        if (data != null) {
          final newBalance = int.parse(data['balance']);
          if (newBalance != null) {
            userNotifier.updateBalance(newBalance);
          }
        }
        return;
      }, onLaunch: (message) {
        debugPrint('onLaunch: $message');
        _redirect(context, message, homeNotifier);
        return;
      }, onResume: (message) {
        debugPrint('onResume: $message');
        _redirect(context, message, homeNotifier);
        return;
      });

      return () {};
    }, const []);
    return WillPopScope(
      onWillPop: () async {
        if (homeNotifier.currentPage == 0) {
          if (await _blogsNavigatorKey.currentState.maybePop()) return false;
        }

        if (homeNotifier.currentPage == 1) {
          if (await _analyticsNavigatorKey.currentState.maybePop()) return false;
        }

        if (homeNotifier.currentPage == 3) {
          if (await _balanceNavigatorKey.currentState.maybePop()) return false;
        }

        if (homeNotifier.currentPage == 4) {
          if (await _menuNavigatorKey.currentState.maybePop()) return false;
        }

        return true;
      },
      child: Scaffold(
        body: PageView(
          controller: pageController,
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
            // ReportsPage(),
            SupportPage(),
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
            unselectedItemColor: const Color(0xFFA1A1A1), // TODO: extract colors to theme
            type: BottomNavigationBarType.fixed,
            unselectedFontSize: 10.0,
            selectedFontSize: 10.0,
            iconSize: 26.0,
            currentIndex: homeNotifier.currentPage,
            onTap: homeNotifier.changePage,
            items: [
              BottomNavigationBarItem(icon: Icon(CustomIcons.home), label: 'Головна'),
              BottomNavigationBarItem(icon: Icon(CustomIcons.test), label: 'Дослідження'),
              BottomNavigationBarItem(icon: Icon(CustomIcons.chat), label: 'Чат'),
              BottomNavigationBarItem(icon: Icon(CustomIcons.clients), label: 'Пацієнти'),
              BottomNavigationBarItem(icon: Icon(CustomIcons.menu), label: 'Меню'),
            ]),
      ),
    );
  }
}
