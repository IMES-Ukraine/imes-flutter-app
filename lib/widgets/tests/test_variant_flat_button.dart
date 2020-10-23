import 'package:flutter/material.dart';

class TestVariantFlatButton extends StatelessWidget {
  final String variant;
  final String title;
  final Color color;
  final bool selected;
  final bool resolved;
  final Color selectedColor;
  final VoidCallback onTap;

  TestVariantFlatButton({
    Key key,
    @required this.variant,
    @required this.title,
    this.selected = false,
    this.resolved = false,
    this.color,
    this.selectedColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColor = color ?? Theme.of(context).dividerColor;
    final defaultSelectedColor = selectedColor ?? Theme.of(context).accentColor;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: Colors.white,
                border: Border.all(
                  color: selected ? defaultSelectedColor : defaultColor,
                )),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: selected ? defaultSelectedColor : Colors.white,
                    border: Border(
                      right: BorderSide(
                        width: 1.0,
                        style: BorderStyle.solid,
                        color: selected ? defaultSelectedColor : defaultColor,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      variant,
                      style: TextStyle(
                        color: selected ? Colors.white : defaultColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(title),
                ),
              ],
            )),
      ),
    );
  }
}
