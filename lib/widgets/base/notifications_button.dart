import 'package:flutter/material.dart';

import 'package:imes/screens/notifications.dart';
import 'package:imes/blocs/user_notifier.dart';

import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';

class NotificationsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserNotifier>(builder: (context, userNotifier, _) {
      return Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          IconButton(
            icon: Icon(
          Icons.notifications,
          color: Theme.of(context).dividerColor,
            ),
            onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => NotificationsPage()),
            ),
          ),
          if (userNotifier.notificationsCount > 0)
            Padding(
              padding: EdgeInsets.all(1.0.h),
              child: Container(
                padding: EdgeInsets.all(1.0.w),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).errorColor),
                child: Text(
                  '${userNotifier.notificationsCount}',
                  style: TextStyle(fontSize: 6.0.sp, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            )
        ],
      );
    });
  }
}
