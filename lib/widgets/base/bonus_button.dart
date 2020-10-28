import 'package:flutter/material.dart';
import 'package:imes/helpers/custom_icons_icons.dart';
import 'package:imes/resources/resources.dart';

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
              Icon(CustomIcons.blog_heart, color: themeData.primaryColor),
              const SizedBox(width: 8.0),
              Text(
                '$points',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: themeData.primaryColor,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
