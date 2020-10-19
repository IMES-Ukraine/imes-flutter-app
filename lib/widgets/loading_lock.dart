import 'package:flutter/material.dart';

class LoadingLock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.3,
          child: const ModalBarrier(
            dismissible: false,
            color: Colors.grey,
          ),
        ),
        Center(
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }
}
