import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  CustomDialog({
    Key key,
    @required this.icon,
    @required this.color,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(icon, color: color),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Text(text, textAlign: TextAlign.center,),
        ),
      ],
    );
  }
}
