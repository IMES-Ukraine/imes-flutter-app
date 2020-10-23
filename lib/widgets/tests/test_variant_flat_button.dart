import 'package:flutter/material.dart';

class TestVariantFlatButton extends StatelessWidget {
  final String variant;
  final String title;
  final Color color;
  final bool selected;
  final Color selectedColor;
  final VoidCallback onTap;

  TestVariantFlatButton({
    Key key,
    @required this.variant,
    @required this.title,
    this.color = const Color(0xFFE0E0E0),
    this.selectedColor = const Color(0xFF00B7FF),
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: Colors.white,
                border: Border.all(
                  color: selected ? selectedColor : color,
                )),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: selected ? selectedColor : Colors.white,
                    border: Border(
                      right: BorderSide(
                        width: 1.0,
                        style: BorderStyle.solid,
                        color: selected ? selectedColor : color,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      variant,
                      style: TextStyle(
                        color: selected ? Colors.white : color,
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
