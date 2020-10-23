import 'package:flutter/material.dart';

import 'package:imes/widgets/base/notifications_button.dart';

class MenuAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        elevation: 1.0,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedDefaultTextStyle(
                duration: Duration(milliseconds: 200),
                style: Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.bold, fontSize: 17.0),
                child: Text(
                  'Меню',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: NotificationsButton(),
            ),
          ],
        ),
      ),
    );
  }
}
