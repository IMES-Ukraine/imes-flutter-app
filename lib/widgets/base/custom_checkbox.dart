import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

class CustomCheckbox extends StatelessWidget {
  final double size;
  final bool value;
  final VoidCallback onTap;

  CustomCheckbox({@required this.value, this.size = 8.0, this.onTap});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return InkResponse(
      onTap: onTap,
      child: Container(
        width: size.w,
        height: size.w,
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
    );
  }
}
