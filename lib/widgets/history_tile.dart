import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class HistoryListTile extends StatelessWidget {
  final int index;
  final String type;
  final DateTime date;
  final int total;
  final GestureTapCallback onTap;

  const HistoryListTile({
    Key key,
    @required this.index,
    @required this.type,
    @required this.date,
    @required this.total,
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
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(.0),
                child: Text(
                  date != null ? DateFormat.yMd().format(date) : '',
                  style: TextStyle(color: Color(0xff828282)),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                type,
                textAlign: TextAlign.end,
                style: TextStyle(color: Color(0xff828282)),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '$total',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                textAlign: TextAlign.end,
              ),
            )
          ],
        ),
      ),
    );
  }
}
