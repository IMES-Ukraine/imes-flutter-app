import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final double size;
  final bool value;
  final VoidCallback onTap;

  CustomCheckbox({@required this.value, this.size = 30, this.onTap});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return GestureDetector(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(color: themeData.primaryColor),
        ),
        child: value
            ? Icon(
                Icons.check,
                color: themeData.primaryColor,
              )
            : const SizedBox(),
      ),
      onTap: onTap,
    );
  }
}
