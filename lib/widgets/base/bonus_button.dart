import 'package:flutter/material.dart';
import 'package:imes/resources/resources.dart';

import 'package:sizer/sizer.dart';

class BonusButton extends StatelessWidget {
  final int points;
  final VoidCallback onTap;

  BonusButton({
    Key key,
    @required this.points,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.zero,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Image.asset(Images.token, scale: 2.0),
              SizedBox(width: 2.0.w),
              Text(
                '$points',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: themeData.primaryColor,
                  fontSize: 15.0.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
