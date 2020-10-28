import 'package:flutter/material.dart';

class AlertContainer extends StatelessWidget {
  final Widget child;

  AlertContainer({
    Key key,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: Theme.of(context).errorColor),
          ),
          child: child,
        ),
        Positioned(left: 8.0, top: -13.0, child: Icon(Icons.warning, color: Theme.of(context).errorColor)),
      ],
    );
  }
}
