import 'package:flutter/material.dart';

import 'package:imes/blocs/tests_notifier.dart';

import 'package:imes/widgets/base/notifications_button.dart';

import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';

class TestsAppBar extends StatelessWidget implements PreferredSizeWidget {
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
            GestureDetector(
              onTap: () {
                Provider.of<TestsStateNotifier>(context, listen: false).changePage(TestsPage.NEWS);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                child: AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 200),
                  style: Provider.of<TestsStateNotifier>(context).page == TestsPage.NEWS
                      ? Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.bold, fontSize: 13.0.sp)
                      : Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 13.0.sp),
                  child: Text(
                    'Дослідження'.toUpperCase(),
                  ),
                ),
              ),
            ),
            // GestureDetector(
            //   onTap: () {
            //     Provider.of<TestsStateNotifier>(context, listen: false).changePage(TestsPage.INFORMATION);
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: AnimatedDefaultTextStyle(
            //       duration: Duration(milliseconds: 200),
            //       style: Provider.of<TestsStateNotifier>(context).page == TestsPage.INFORMATION
            //           ? Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.bold, fontSize: 17.0)
            //           : Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 17.0),
            //       child: Text(
            //         'Популярні'.toUpperCase(),
            //       ),
            //     ),
            //   ),
            // ),
            NotificationsButton(),
          ],
        ),
      ),
    );
  }
}
