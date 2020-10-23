import 'package:flutter/material.dart';

import 'package:imes/widgets/custom_dialog.dart';

class ErrorRetry extends StatelessWidget {
  final String text;
  final GestureTapCallback onTap;

  ErrorRetry({this.onTap, this.text = 'Виникла помилка'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CustomDialog(
            icon: Icons.close,
            color: Color(0xFFFF5B5E),
            text: text,
          ),
          OutlineButton(
            child: Text(
              'Спробувати ще',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            highlightedBorderColor: Theme.of(context).accentColor,
            borderSide: BorderSide(color: Theme.of(context).accentColor),
            textColor: Theme.of(context).accentColor,
            onPressed: onTap,
//                () {
//              historyNotifier.load();
//            },
          ),
        ],
      ),
    );
  }
}
