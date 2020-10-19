import 'package:flutter/material.dart';
import 'package:pharmatracker/widgets/bonus_button.dart';

import 'package:timeago/timeago.dart' as timeago;

class BlogListTile extends StatelessWidget {
  const BlogListTile({
    Key key,
    this.isFavourite = false,
    @required this.date,
    @required this.title,
    @required this.image,
    @required this.points,
    this.onTap,
  }) : super(key: key);

  final bool isFavourite;
  final DateTime date;
  final String title;
  final String image;
  final int points;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Stack(
              children: [
                Container(
                  constraints: BoxConstraints(
                    minWidth: double.infinity,
                    maxHeight: image.isNotEmpty ? 200.0 : double.infinity,
                  ),
                  decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(image), fit: BoxFit.fitWidth)),
                ),
                IconButton(
                    icon: Icon(
                      isFavourite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                    ),
                    onPressed: () {}),
              ],
            ),
            // if (image.isNotEmpty)
            //   ConstrainedBox(
            //     constraints: BoxConstraints(maxHeight: 200.0),
            //     child: Stack(
            //       fit: StackFit.expand,
            //       alignment: Alignment.center,
            //       children: <Widget>[
            //         if (image.isNotEmpty)
            //           Image.network(
            //             image,
            //             height: 200.0,
            //             fit: BoxFit.cover,
            //           ),
            //         Align(
            //           alignment: Alignment.topRight,
            //           child: Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: Text(
            //               date != null ? timeago.format(date, locale: 'ua') : '',
            //               style: TextStyle(
            //                 fontSize: 12.0,
            //                 color: image.isNotEmpty ? Colors.white : const Color(0xFFBDBDBD),
            //                 fontWeight: FontWeight.w400,
            //               ),
            //               textAlign: TextAlign.end,
            //             ),
            //           ),
            //         ),
            //         Align(
            //           alignment: Alignment.centerLeft,
            //           child: Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: Text(
            //               title,
            //               overflow: TextOverflow.ellipsis,
            //               maxLines: 5,
            //               style: TextStyle(
            //                 fontWeight: FontWeight.bold,
            //                 fontSize: image.isNotEmpty ? 22.0 : 18.0,
            //                 color: image.isNotEmpty ? Colors.white : Colors.black,
            //                 backgroundColor: themeData.primaryColor,
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   )
            // else
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: <Widget>[
            // Row(
            //   children: <Widget>[
            //     Expanded(
            //       child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Text(
            //           date != null ? timeago.format(date, locale: 'ua') : '',
            //           style: TextStyle(
            //             fontSize: 12.0,
            //             color: image.isNotEmpty ? Colors.white : const Color(0xFFBDBDBD),
            //             fontWeight: FontWeight.w400,
            //           ),
            //           textAlign: TextAlign.end,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //   ],
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     text,
            //     maxLines: 5,
            //     overflow: TextOverflow.ellipsis,
            //     style: TextStyle(fontSize: 12.0),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: BonusButton(points: points),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Container(
            //     padding: const EdgeInsets.all(8.0),
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(5.0),
            //       border: Border.all(
            //         color: Colors.black.withOpacity(0.1),
            //       ),
            //     ),
            //     child: BonusButton(points: points),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
