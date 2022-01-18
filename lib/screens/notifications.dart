import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:imes/blocs/home_notifier.dart';
import 'package:imes/blocs/notifications_notifier.dart';
import 'package:imes/blocs/user_notifier.dart';
import 'package:imes/helpers/custom_icons_icons.dart';
import 'package:imes/screens/blog_view.dart';
import 'package:imes/widgets/base/error_retry.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userNotifier = Provider.of<UserNotifier>(context, listen: false);
      userNotifier.resetNotificationsCount();
    });
  }

  Widget _getIcon(String type) {
    switch (type) {
      case 'NEWS':
        return Icon(CustomIcons.news,
            color: Theme.of(context).primaryColor, size: 20);
      case 'SUPPORT':
        return Icon(CustomIcons.support,
            color: Theme.of(context).primaryColor, size: 20);
      case 'SYSTEM':
        return Icon(CustomIcons.settings,
            color: Theme.of(context).primaryColor, size: 20);
      case 'RESEARCHES':
        return Icon(CustomIcons.test,
            color: Theme.of(context).primaryColor, size: 20);
      case 'MESSAGE':
        return Icon(Icons.chat,
            color: Theme.of(context).primaryColor, size: 20);
      default:
        return Icon(Icons.image,
            color: Theme.of(context).primaryColor, size: 20);
    }
  }

  String _getText(String type) {
    switch (type) {
      case 'NEWS':
        return 'НОВИНИ';
      case 'SUPPORT':
        return 'ПІДТРИМКА';
      case 'SYSTEM':
        return 'СИСТЕМА';
      case 'RESEARCHES':
        return 'ДОСЛІДЖЕННЯ';
      case 'MESSAGE':
        return 'ПОВІДОМЛЕННЯ';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationsNotifier()..load(),
      child: Consumer3<NotificationsNotifier, UserNotifier, HomeNotifier>(
        builder:
            (context, notificationsNotifier, userNotifier, homeNotifier, _) {
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
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: notificationsNotifier.state ==
                                NotificationsState.LOADING
                            ? 1
                            : notificationsNotifier.notifications.length + 1,
                        itemBuilder: (context, index) {
                          if (notificationsNotifier.state ==
                              NotificationsState.LOADING) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          if (index ==
                              notificationsNotifier.notifications.length) {
                            if (notificationsNotifier.notifications.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Нотифікації відсутні.'),
                                ),
                              );
                            }

                            if (notificationsNotifier.notifications.length ==
                                notificationsNotifier.total) {
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
                                foregroundColor: Theme.of(context).errorColor,
                                icon: Icons.delete,
                                onTap: () {
                                  notificationsNotifier.delete(index);
                                },
                              ),
                            ],
                            child: Card(
                              margin: const EdgeInsets.all(16.0),
                              child: InkWell(
                                onTap: () {
                                  final notification = notificationsNotifier
                                      .notifications[index];
                                  if (notification.action?.isNotEmpty == true) {
                                    if (notificationsNotifier
                                            .notifications[index].type ==
                                        'MESSAGE') {
                                      print(notification);
                                      try {
                                        final id =
                                            num.parse(notification.action);
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BlogViewPage(id)));
                                      } catch (e) {
                                        print(e.toString());
                                      }
                                    }
                                  }

                                  if (notificationsNotifier
                                          .notifications[index].type ==
                                      'SUPPORT') {
                                    homeNotifier.changePage(2);
                                  }

                                  if (notificationsNotifier
                                          .notifications[index].type ==
                                      'REFILL') {
                                    homeNotifier.changePage(3);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          _getIcon(notificationsNotifier
                                              .notifications[index].type),
                                          const SizedBox(width: 8.0),
                                          Text(
                                            _getText(notificationsNotifier
                                                .notifications[index].type),
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xFF606060),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${timeago.format(notificationsNotifier.notifications[index].updatedAt, locale: 'uk')}',
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Color(0xFF828282)),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                          notificationsNotifier
                                              .notifications[index].text.title,
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1),
                                      Text(
                                          notificationsNotifier
                                              .notifications[index]
                                              .text
                                              .content,
                                          style: TextStyle(fontSize: 12.0),
                                          maxLines: 2),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
