import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';

import 'package:sizer/sizer.dart';

class OctoCircleAvatar extends StatelessWidget {
  final String url;
  final double size;

  OctoCircleAvatar({
    Key key,
    @required this.url,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final size = this.size ?? 8.0.h;
    return OctoImage(
      image: CachedNetworkImageProvider(url),
      placeholderBuilder: (context) => Icon(Icons.account_circle, size: size, color: Theme.of(context).dividerColor),
      imageBuilder: (context, child) => Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(blurRadius: 1.0, offset: Offset(0.0, 2.0), color: Colors.black26, spreadRadius: 2.0)],
          ),
          child: AspectRatio(aspectRatio: 1.0, child: ClipOval(child: child)),
        ),
      ),
      fit: BoxFit.cover,
      width: size,
      height: size,
    );
  }
}
