import 'package:flutter/material.dart';
import 'package:pharmatracker/blocs/home_notifier.dart';

import 'package:pharmatracker/blocs/user_notifier.dart';
import 'package:pharmatracker/blocs/notifications_notifier.dart';

import 'package:pharmatracker/widgets/error_retry.dart';

import 'package:pharmatracker/screens/support.dart';
import 'package:pharmatracker/screens/blog_view.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:provider/provider.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userNotifier = Provider.of<UserNotifier>(context);
      userNotifier.resetNotificationsCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final notificationsNotifier = NotificationsNotifier();
        notificationsNotifier.load();
        return notificationsNotifier;
      },
      child: Consumer3<NotificationsNotifier, UserNotifier, HomeNotifier>(
        builder: (context, notificationsNotifier, userNotifier, homeNotifier, _) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 1.0,
            ),
            body: notificationsNotifier.state == NotificationsState.ERROR
                ? ErrorRetry(onTap: () {
                    notificationsNotifier.load();
                  })
                : Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: RefreshIndicator(
                      onRefresh: () => notificationsNotifier.load(),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: notificationsNotifier.state == NotificationsState.LOADING
                            ? 1
                            : notificationsNotifier.notifications.length + 1,
                        itemBuilder: (context, index) {
                          if (notificationsNotifier.state == NotificationsState.LOADING) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          if (index == notificationsNotifier.notifications.length) {
                            if (notificationsNotifier.notifications.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Нотифікації відсутні.'),
                                ),
                              );
                            }

                            if (notificationsNotifier.notifications.length == notificationsNotifier.total) {
                              return null;
                            }

                            notificationsNotifier.loadNext();
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          return Slidable(
                            actionPane: SlidableBehindActionPane(),
                            actionExtentRatio: 0.15,
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                color: Colors.red,
                                icon: Icons.delete,
                                onTap: () {
                                  notificationsNotifier.delete(index);
                                },
                              ),
                            ],
                            child: Container(
                              color: Colors.white,
                              child: ListTile(
                                leading: notificationsNotifier.notifications[index].type == "NEWS"
                                    ? CircleAvatar(
                                        child: Image.network(notificationsNotifier.notifications[index]?.image ?? ''),
                                      )
                                    : Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(colors: [Color(0xFF12EC34), Color(0xFF00D0D0)]),
                                        ),
                                        child: _getIcon(notificationsNotifier.notifications[index].type),
                                      ),
                                title: Text(notificationsNotifier.notifications[index].text),
                                onTap: () async {
                                  if (notificationsNotifier.notifications[index].action?.isNotEmpty ?? false) {
                                    if (notificationsNotifier.notifications[index].type == 'NEWS') {
                                      final values = notificationsNotifier.notifications[index].action.split(':');
                                      if (values.length > 1) {
                                        try {
                                          final id = num.parse(values[1]);
//                                          Navigator.of(context).pushNamed('/blogs/view', arguments: id);
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(builder: (context) => BlogViewPage(id)));
                                        } catch (e) {
                                          print(e.toString());
                                        }
                                      }
                                    }

                                    if (notificationsNotifier.notifications[index].type == 'MESSAGE') {
                                      if (await canLaunch(notificationsNotifier.notifications[index].action)) {
                                        launch(notificationsNotifier.notifications[index].action);
                                      }
                                    }
                                  }

                                  if (notificationsNotifier.notifications[index].type == 'SUPPORT') {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => SupportPage()),
                                    );
                                  }

                                  if (notificationsNotifier.notifications[index].type == 'REFILL') {
                                    homeNotifier.changePage(3);
                                  }
                                },
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Divider(indent: 16.0),
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _getIcon(String type) {
    switch (type) {
      case 'REFILL':
        return Center(
            child: Text(
          '\$',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 24),
        ));
      case 'WITHDRAW':
        return Image.asset('assets/reply.png');
      case 'MESSAGE':
        return Image.asset('assets/settings.png');
      case 'SUPPORT':
        return Image.asset('assets/headphones.png');
      case 'DEFAULT':
        return Image.asset('assets/hamburger.png');
      default:
        return Image.asset('assets/hamburger.png');
    }
  }
}
