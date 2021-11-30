import 'package:flutter/material.dart';
import 'package:imes/utils/constants.dart';

class InstructionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: SingleChildScrollView(
          child: Image.asset(
            Constants.INSTRUCTION_URL,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
