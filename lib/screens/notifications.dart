import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:imes/blocs/notifications_notifier.dart';
import 'package:imes/helpers/custom_icons_icons.dart';

import 'package:imes/widgets/base/error_retry.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:timeago/timeago.dart' as timeago;

class NotificationsPage extends HookWidget {
  IconData _getIconData(String type) {
    switch (type) {
      case 'NEWS':
        return CustomIcons.news;
      case 'SUPPORT':
        return CustomIcons.support;
      case 'SYSTEM':
        return CustomIcons.settings;
      case 'RESEARCHES':
        return CustomIcons.test;
      case 'MESSAGE':
        return Icons.chat;
      default:
        return Icons.image;
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
    final notificationsNotifier = useProvider(notificationsNotifierProvider);

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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(_getIconData(notificationsNotifier.notifications[index].type),
                                        color: Theme.of(context).primaryColor, size: 20),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      _getText(notificationsNotifier.notifications[index].type),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF606060),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${timeago.format(notificationsNotifier.notifications[index].updatedAt, locale: 'uk')}',
                                        style: TextStyle(fontSize: 12.0, color: Color(0xFF828282)),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(notificationsNotifier.notifications[index].text.title,
                                    style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold), maxLines: 1),
                                Text(notificationsNotifier.notifications[index].text.content,
                                    style: TextStyle(fontSize: 12.0), maxLines: 2),
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
  }
}
