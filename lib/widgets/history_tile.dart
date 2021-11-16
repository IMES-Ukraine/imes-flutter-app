import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    return Material(
      elevation: 1,
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(5)),
      child: InkWell(
        borderRadius: BorderRadius.circular(4.0),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 32,
            top: 13,
            right: 15,
            bottom: 12,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  '$total',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    height: 25 / 18,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  type,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: Color(0xff333333),
                    fontSize: 14,
                    height: 19 / 14,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(.0),
                  child: Text(
                    // date != null ? DateFormat.yMd().format(date) : '',
                    date != null ? DateFormat('dd.MM.yyyy').format(date) : '',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Color(0xffa1a1a1),
                      fontSize: 12,
                      height: 16 / 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
