import 'package:flutter/material.dart';

class CustomAlertDialog extends AlertDialog {
  CustomAlertDialog({Widget content, List<Widget> actions})
      : super(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: content,
          actions: actions,
        );
}
