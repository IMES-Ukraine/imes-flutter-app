import 'package:flutter/material.dart';
import 'package:imes/blocs/blogs_notifier.dart';
import 'package:imes/blocs/user_notifier.dart';
import 'package:imes/extensions/color.dart';
import 'package:imes/resources/repository.dart';
import 'package:imes/resources/resources.dart';
import 'package:imes/screens/account.dart';
import 'package:imes/screens/account_edit.dart';
import 'package:imes/screens/balance.dart';
import 'package:imes/widgets/base/notifications_button.dart';
import 'package:imes/widgets/base/octo_circle_avatar.dart';
import 'package:imes/widgets/base/raised_gradient_button.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class BlogsAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(54.0.w);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserNotifier>(builder: (context, userNotifier, _) {
      return Material(
        type: MaterialType.canvas,
        elevation: Theme.of(context).appBarTheme.elevation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(2.0.h),
                      child: OctoCircleAvatar(
                        url: userNotifier.user?.basicInformation?.avatar?.path
                                    ?.isNotEmpty ==
                                true
                            ? '$BASE_URL${userNotifier.user.basicInformation.avatar.path}'
                            : '',
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 3.0.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userNotifier?.user?.basicInformation?.name ??
                                  'Ім\'я Прізвище',
                              style: TextStyle(
                                color:
                                    Theme.of(context).dividerColor.darken(20),
                                fontSize: 11.0.sp,
                              ),
                            ),
                            Text(
                              userNotifier.user?.specializedInformation
                                      ?.specification ??
                                  'Спеціалізація',
                              style: TextStyle(
                                fontSize: 8.0.sp,
                                fontWeight: FontWeight.w600,
                                color: userNotifier.user?.specializedInformation
                                            ?.specification !=
                                        null
                                    ? Colors.black
                                    : Theme.of(context).dividerColor.darken(20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NotificationsButton(),
                        Padding(
                          padding: EdgeInsets.all(4.0.w),
                          child: Row(
                            children: [
                              Image.asset(Images.token, scale: 2.0),
                              const SizedBox(width: 8.0),
                              Text('${userNotifier.user?.balance ?? 0}',
                                  style: TextStyle(
                                    fontSize: 14.0.sp,
                                    fontWeight: FontWeight.bold,
                                    color: (userNotifier.user?.balance ?? 0) > 0
                                        ? Theme.of(context)
                                            .dividerColor
                                            .darken(20)
                                        : Theme.of(context).dividerColor,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(1.0.h),
              child: userNotifier.user.basicInformation != null &&
                      userNotifier.user.specializedInformation != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RaisedGradientButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 1.5.h, horizontal: 10.0.w),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AccountPage()));
                          },
                          child: Row(
                            children: [
                              Icon(Icons.account_circle, color: Colors.white),
                              SizedBox(width: 2.0.w),
                              Text('АКАУНТ',
                                  style: TextStyle(
                                      fontSize: 10.0.sp,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white))
                            ],
                          ),
                        ),
                        RaisedGradientButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 1.5.h, horizontal: 10.0.w),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => BalancePage()));
                          },
                          child: Row(
                            children: [
                              Image.asset(Images.token, scale: 1.5),
                              SizedBox(width: 2.0.w),
                              Text('БАЛАНС',
                                  style: TextStyle(
                                      fontSize: 10.0.sp,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white))
                            ],
                          ),
                        ),
                      ],
                    )
                  : RaisedGradientButton(
                      padding: EdgeInsets.symmetric(
                          vertical: 1.5.h, horizontal: 10.0.w),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AccountEditPage()));
                      },
                      child: Text('ВЕРИФІКУВАТИ АКАУНТ',
                          style: TextStyle(
                              fontSize: 10.0.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white)),
                    ),
            ),
            IntrinsicHeight(
              child: Container(
                // color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Provider.of<BlogsNotifier>(context, listen: false)
                            .changePage(BlogPage.NEWS);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 1.0.w, vertical: 1.0.h),
                        decoration: BoxDecoration(
                          // color: Colors.green,
                          border: Border(
                            bottom: BorderSide(
                                color:
                                    Provider.of<BlogsNotifier>(context).page ==
                                            BlogPage.NEWS
                                        ? Colors.black
                                        : Colors.transparent),
                          ),
                        ),
                        child: AnimatedDefaultTextStyle(
                          duration: Duration(milliseconds: 200),
                          style: Provider.of<BlogsNotifier>(context).page ==
                                  BlogPage.NEWS
                              ? Theme.of(context).textTheme.bodyText2.copyWith(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13.0.sp)
                              : Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(fontSize: 13.0.sp),
                          child: Text('Новини'.toUpperCase()),
                        ),
                      ),
                    ),
                    VerticalDivider(
                        indent: 2.5.h,
                        endIndent: 2.5.h,
                        width: 1.0,
                        thickness: 2.0),
                    InkWell(
                      onTap: () {
                        Provider.of<BlogsNotifier>(context, listen: false)
                            .changePage(BlogPage.INFORMATION);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 1.0.w, vertical: 1.0.h),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color:
                                    Provider.of<BlogsNotifier>(context).page ==
                                            BlogPage.INFORMATION
                                        ? Colors.black
                                        : Colors.transparent),
                          ),
                        ),
                        child: AnimatedDefaultTextStyle(
                          duration: Duration(milliseconds: 200),
                          style: Provider.of<BlogsNotifier>(context).page ==
                                  BlogPage.INFORMATION
                              ? Theme.of(context).textTheme.bodyText2.copyWith(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13.0.sp)
                              : Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(fontSize: 13.0.sp),
                          child: Text('Інформація'.toUpperCase()),
                        ),
                      ),
                    ),
                    VerticalDivider(
                        indent: 2.5.h,
                        endIndent: 2.5.h,
                        width: 1.0,
                        thickness: 2.0),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 1.0.w, vertical: 1.0.h),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Provider.of<BlogsNotifier>(context).page ==
                                      BlogPage.FAVORITES
                                  ? Colors.black
                                  : Colors.transparent),
                        ),
                      ),
                      child: InkResponse(
                        onTap: () {
                          Provider.of<BlogsNotifier>(context, listen: false)
                              .changePage(BlogPage.FAVORITES);
                        },
                        child: Provider.of<BlogsNotifier>(context).page ==
                                BlogPage.FAVORITES
                            ? Icon(Icons.favorite,
                                color: Theme.of(context).accentColor)
                            : Icon(Icons.favorite_border,
                                color: Theme.of(context).dividerColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
