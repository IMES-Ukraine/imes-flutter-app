import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final Widget icon;
  final String text;
  final GestureTapCallback onTap;

  MenuItem({this.icon, this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              icon,
              // Container(
              //   width: 50,
              //   height: 50,
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     gradient: LinearGradient(colors: [Color(0xFF12EC34), Color(0xFF00D0D0)]),
              //   ),
              //   child: icon,
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text,
                  style: TextStyle(fontSize: 12.0),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
