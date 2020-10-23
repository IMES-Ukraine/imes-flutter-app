import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';

class TestVariantCardButton extends StatelessWidget {
  final String variant;
  final String title;
  final String descr;
  final String imageUrl;
  final Color selectedColor;
  final bool selected;
  final VoidCallback onTap;

  TestVariantCardButton({
    Key key,
    @required this.variant,
    @required this.title,
    @required this.descr,
    @required this.imageUrl,
    this.selectedColor,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final defaultSelectedColor = selectedColor ?? Theme.of(context).accentColor;
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        side: BorderSide(color: selected ? defaultSelectedColor : Theme.of(context).dividerColor),
      ),
      shadowColor: selected ? defaultSelectedColor : Theme.of(context).dividerColor,
      child: InkWell(
        onTap: onTap,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Container(
                decoration: BoxDecoration(
                  color: selected ? defaultSelectedColor : Colors.white,
                  border: Border.all(color: selected ? defaultSelectedColor : Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    variant,
                    style: TextStyle(
                      color: selected ? Colors.white : Theme.of(context).dividerColor,
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
            child: IntrinsicHeight(
              child: Row(children: [
                Expanded(child: Text(descr, style: TextStyle(fontSize: 8.0))),
                Expanded(
                    child: OctoImage(
                  image: CachedNetworkImageProvider(imageUrl),
                  fit: BoxFit.cover,
                ))
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
