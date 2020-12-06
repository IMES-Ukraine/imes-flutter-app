import 'package:flutter/material.dart';

mixin AccountWidgetOptions {
  InputDecoration inputDecoration(String hint) => InputDecoration(
      isDense: true, hintText: hint, hintStyle: TextStyle(fontSize: 12.0), contentPadding: EdgeInsets.zero);

  TextStyle get textStyle => TextStyle(fontSize: 12.0);
  TextStyle get textStyleBold => TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600);
}
