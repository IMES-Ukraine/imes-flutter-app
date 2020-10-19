import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class AnalyticsListTile extends StatelessWidget {
  final int index;
  final String photoId;
  final DateTime date;
  final int count;
  final int status;
  final GestureTapCallback onTap;

  const AnalyticsListTile({
    Key key,
    @required this.index,
    @required this.photoId,
    @required this.date,
    @required this.count,
    @required this.status,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(4.0),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text('${index + 1}'),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Text(photoId),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Text(
                  date != null ? DateFormat.Hm().format(date) : '',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.remove_red_eye,
                    color: Color(0xFFDADADA),
                    size: 14.0,
                  ),
                  const SizedBox(
                    width: 2.0,
                  ),
                  Expanded(
                    child: Text(
                      '$count шт',
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: <Widget>[
                  Text(
                    getText(status),
                    style: TextStyle(fontSize: 7.0),
                  ),
                  getIcon(status) != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: getIcon(status),
                        )
                      : const SizedBox(
                          width: 40.0,
                          height: 20.0,
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getText(int status) {
    switch (status) {
      case 2:
        return 'Відхилено';
      case 1:
        return 'Прийнято';
      case 0:
      default:
        return 'У роботі';
    }
  }

  Widget getIcon(int status) {
    switch (status) {
      case 2:
        return Icon(
          Icons.close,
          color: Colors.red,
        );
      case 1:
        return Icon(
          Icons.check,
          color: Color(0xFF10DE50),
        );
      case 0:
      default:
        return null;
    }
  }
}
