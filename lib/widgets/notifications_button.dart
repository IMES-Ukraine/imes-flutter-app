import 'package:flutter/material.dart';

import 'package:pharmatracker/screens/notifications.dart';
import 'package:pharmatracker/blocs/user_notifier.dart';

import 'package:provider/provider.dart';

class NotificationsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserNotifier>(builder: (context, userNotifier, _) {
      return Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          Center(
            child: IconButton(
              icon: Icon(
                Icons.notifications,
                color: Color(0xFFDADADA),
              ),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              ),
            ),
          ),
          if (userNotifier.notificationsCount > 0)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFF10DE50)),
                child: Text(
                  '${userNotifier.notificationsCount}',
                  style: TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            )
        ],
      );
    });
  }
}
