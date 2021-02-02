import 'package:flutter/material.dart';

class RaisedGradientButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  // final double width;
  final double radius;
  final double height;
  final EdgeInsets padding;
  final Function onPressed;

  const RaisedGradientButton({
    Key key,
    @required this.child,
    this.gradient,
    this.padding = const EdgeInsets.all(8.0),
    // this.width = double.infinity,
    this.radius = 5.0,
    this.height = 50.0,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultGradient =
        gradient ?? LinearGradient(colors: [Theme.of(context).accentColor, Theme.of(context).primaryColor]);

    return Container(
      // width: width,
      // height: 50.0,
      decoration: BoxDecoration(
        gradient: onPressed != null
            ? defaultGradient
            : LinearGradient(colors: [Colors.grey[400], Colors.grey]), // TODO: extraact colors to theme
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: onPressed != null ? Color(0xFF2F80ED) : Colors.grey[400], // TODO: extract color to theme
            offset: Offset(0.0, 3.0),
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Center(
              child: Padding(
                padding: padding,
                child: child,
              ),
            )),
      ),
    );
  }
}
