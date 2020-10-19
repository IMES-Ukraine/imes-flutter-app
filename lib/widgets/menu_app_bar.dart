import 'package:flutter/material.dart';

import 'package:pharmatracker/widgets/notifications_button.dart';

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
                style: Theme.of(context).textTheme.body1.copyWith(fontWeight: FontWeight.bold, fontSize: 17.0),
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
