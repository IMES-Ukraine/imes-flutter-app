import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';

class TestVariantCardButton extends StatelessWidget {
  final String variant;
  final String title;
  final String descr;
  final String imageUrl;
  final bool selected;
  final VoidCallback onTap;

  TestVariantCardButton({
    Key key,
    @required this.variant,
    @required this.title,
    @required this.descr,
    @required this.imageUrl,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        side: BorderSide(color: selected ? Color(0xFF4CF99E) : Color(0xFFE0E0E0)),
      ),
      shadowColor: selected ? Color(0xFF4CF99E) : Color(0xFFE0E0E0),
      child: InkWell(
        onTap: onTap,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Container(
                decoration: BoxDecoration(
                  color: selected ? Color(0xFF4CF99E) : Colors.white,
                  border: Border.all(color: selected ? Color(0xFF4CF99E) : Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    variant,
                    style: TextStyle(
                      color: selected ? Colors.white : Color(0xFFE0E0E0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              Text(title),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Expanded(child: Text(descr, style: TextStyle(fontSize: 8.0))),
              Expanded(
                  child: OctoImage(
                image: CachedNetworkImageProvider(imageUrl),
                placeholderBuilder: OctoPlaceholder.blurHash('LKO2?V%2Tw=w]~RBVZRi};RPxuwH'),
                fit: BoxFit.scaleDown,
              ))
            ]),
          ),
        ]),
      ),
    );
  }
}
