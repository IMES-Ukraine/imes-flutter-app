import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:imes/widgets/base/bonus_button.dart';
import 'package:octo_image/octo_image.dart';

import 'package:sizer/sizer.dart';

class BlogListTile extends StatelessWidget {
  const BlogListTile({
    Key key,
    this.isOpened = false,
    this.isFavourite = false,
    @required this.date,
    @required this.title,
    @required this.image,
    @required this.points,
    this.onTap,
    this.onFavoriteChanged,
  }) : super(key: key);

  final bool isOpened;
  final bool isFavourite;
  final DateTime date;
  final String title;
  final String image;
  final int points;
  final Function onTap;
  final Function(bool) onFavoriteChanged;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 2.0.w),
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
              height: 25.0.h,
              placeholderBuilder: OctoPlaceholder.blurHash('LKO2?V%2Tw=w]~RBVZRi};RPxuwH'),
              imageBuilder: (context, child) => Stack(
                fit: StackFit.expand,
                children: [
                  child,
                  Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(
                          isFavourite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (onFavoriteChanged != null) {
                            onFavoriteChanged(!isFavourite);
                          }
                        },
                      )),
                ],
              ),
              fit: BoxFit.fitWidth,
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(1.0.h),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0.sp,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (isOpened)
              Padding(
                padding: EdgeInsets.all(2.0.h),
                child: BonusButton(points: points),
              ),
          ],
        ),
      ),
    );
  }
}
