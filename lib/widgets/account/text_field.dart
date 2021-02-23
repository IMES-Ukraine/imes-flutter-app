import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AccountTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final FormFieldValidator<String> validator;

  AccountTextField({Key key, this.controller, this.labelText, this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        isDense: true,
        labelText: labelText,
        labelStyle: TextStyle(fontSize: 10.0.sp),
        errorStyle: TextStyle(height: 0),
        contentPadding: EdgeInsets.zero,
      ),
      style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.w600),
      validator: validator,
    );
  }
}
