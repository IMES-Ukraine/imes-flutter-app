import 'package:flutter/material.dart';

import 'package:pharmatracker/blocs/blogs_notifier.dart';

import 'package:pharmatracker/widgets/notifications_button.dart';

import 'package:provider/provider.dart';

class BlogsAppBar extends StatelessWidget implements PreferredSizeWidget {
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
            GestureDetector(
              onTap: () {
                Provider.of<BlogsNotifier>(context, listen: false).changePage(BlogPage.NEWS);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 200),
                  style: Provider.of<BlogsNotifier>(context).page == BlogPage.NEWS
                      ? Theme.of(context).textTheme.body1.copyWith(fontWeight: FontWeight.bold, fontSize: 17.0)
                      : Theme.of(context).textTheme.body1.copyWith(fontSize: 17.0),
                  child: Text(
                    'Новини',
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Provider.of<BlogsNotifier>(context, listen: false).changePage(BlogPage.INFORMATION);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 200),
                  style: Provider.of<BlogsNotifier>(context).page == BlogPage.INFORMATION
                      ? Theme.of(context).textTheme.body1.copyWith(fontWeight: FontWeight.bold, fontSize: 17.0)
                      : Theme.of(context).textTheme.body1.copyWith(fontSize: 17.0),
                  child: Text(
                    'Інформація',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 32.0),
              child: NotificationsButton(),
            ),
          ],
        ),
      ),
    );
  }
}
