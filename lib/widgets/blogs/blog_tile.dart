import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:imes/widgets/base/bonus_button.dart';
import 'package:octo_image/octo_image.dart';

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
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            OctoImage(
              image: CachedNetworkImageProvider(image),
              height: 200.0,
              placeholderBuilder: OctoPlaceholder.blurHash('LKO2?V%2Tw=w]~RBVZRi};RPxuwH'),
              imageBuilder: (context, child) => Stack(
                fit: StackFit.expand,
                children: [
                  child,
                  // Align(
                  //   alignment: Alignment.topLeft,
                  //   child: IconButton(
                  //       icon: Icon(
                  //         isFavourite ? Icons.favorite : Icons.favorite_border,
                  //         color: Colors.white,
                  //       ),
                  //       onPressed: () {}),
                  // ),
                ],
              ),
              fit: BoxFit.fitWidth,
            ),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: BonusButton(points: points),
            ),
          ],
        ),
      ),
    );
  }
}
