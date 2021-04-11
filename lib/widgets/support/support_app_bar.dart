import 'package:flutter/material.dart';

import 'package:imes/widgets/base/notifications_button.dart';

import 'package:sizer/sizer.dart';

class SupportAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1.0,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0.w),
              child: AnimatedDefaultTextStyle(
                duration: Duration(milliseconds: 200),
                style: Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.bold, fontSize: 13.0.sp),
                child: Text(
                  'Технічна підтримка'.toUpperCase(),
                ),
              ),
            ),
            NotificationsButton(),
          ],
        ),
      ),
    );
  }
}
