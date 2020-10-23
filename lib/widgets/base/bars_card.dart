import 'package:flutter/material.dart';
import 'package:imes/resources/resources.dart';

class BarsCard extends StatelessWidget {
  // final VoidCallback onTap;

  BarsCard({
    Key key,
    // this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return InkWell(
      // onTap: onTap,
      child: Card(
        margin: EdgeInsets.zero,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Image.asset(Images.twoBars),
        ),
      ),
    );
  }
}
