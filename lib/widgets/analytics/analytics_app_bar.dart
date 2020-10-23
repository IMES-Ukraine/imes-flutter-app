import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import 'package:imes/widgets/base/notifications_button.dart';

import 'package:timeago/timeago.dart' as timeago;

class AnalyticsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final dateFormat = DateFormat('dd MMMM', 'uk');
  final DateTime date;
  final Function(DateTime) onDatePicked;

  AnalyticsAppBar({this.date, this.onDatePicked});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        elevation: 1.0,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () async {
                  final datePicked = await showDatePicker(
                      context: context, initialDate: date, firstDate: DateTime(2016), lastDate: DateTime.now());
                  if (onDatePicked != null) {
                    onDatePicked(datePicked);
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Вибрати дату',
                      style: TextStyle(fontSize: 10.0, color: Color(0xFF828282)),
                    ),
                    Text(
                      dateFormat.format(date),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0, height: 0.8),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: const SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
//                timeago.format(date, locale: 'ua'),
                format(date),
                style: TextStyle(fontSize: 14.0, color: Color(0xFF828282)),
              ),
            ),
            Expanded(
              flex: 2,
              child: const SizedBox(),
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

  String format(DateTime date) {
    final elapsed = DateTime.now().millisecondsSinceEpoch - date.millisecondsSinceEpoch;
    final num seconds = elapsed / 1000;
    final num minutes = seconds / 60;
    final num hours = minutes / 60;
    final num days = hours ~/ 24;
    final num months = days / 30;
    final num years = days / 365;

    if (hours < 24 && DateTime.now().day == date.day) {
      return 'Сьогодні';
    } else if (hours < 48 && DateTime.now().day != date.day) {
      return 'Вчора';
    } else {
      return timeago.format(date, locale: 'ua');
    }
  }
}
