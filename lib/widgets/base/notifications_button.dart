import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:imes/screens/notifications.dart';
import 'package:imes/blocs/user_notifier.dart';

class NotificationsButton extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final notificationsCount = useProvider(notificationsCountProvider);
    return Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        Center(
            child: IconButton(
          icon: Icon(
            Icons.notifications,
            color: Theme.of(context).dividerColor,
          ),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => NotificationsPage()),
          ),
        )),
        if (notificationsCount.state > 0)
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
              child: Text(
                '${notificationsCount.state}',
                style: TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          )
      ],
    );
  }
}
