import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

class BottomAppBarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final Function onTap;

  BottomAppBarButton({Key key, @required this.icon, @required this.label, this.selected = false, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 4.0.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? Theme.of(context).primaryColor : Color(0xFFA1A1A1), size: 22.0.sp),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: TextStyle(fontSize: 7.0.sp, color: selected ? Theme.of(context).primaryColor : Color(0xFFA1A1A1)),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
