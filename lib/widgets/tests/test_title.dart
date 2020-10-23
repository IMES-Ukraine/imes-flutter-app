import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:imes/helpers/utils.dart';

class TestTitle extends HookWidget {
  final String title;
  final ValueNotifier<Duration> duration;

  TestTitle({
    Key key,
    @required this.duration,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    useListenable(duration);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
          Container(
              decoration: BoxDecoration(
                  border: Border.all(color: themeData.primaryColor), borderRadius: BorderRadius.circular(5.0)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${Utils.formatDuration(duration.value)}',
                    style: TextStyle(
                      color: Color(0xFF32E1C0),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    )),
              )),
        ],
      ),
    );
  }
}
