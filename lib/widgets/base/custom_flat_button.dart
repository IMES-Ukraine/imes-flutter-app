import 'package:flutter/material.dart';

class CustomFlatButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  CustomFlatButton({
    Key key,
    @required this.text,
    @required this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        side: BorderSide(color: color),
      ),
      onPressed: onPressed,
    );
  }
}
