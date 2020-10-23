import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:imes/widgets/bars_card.dart';
import 'package:imes/widgets/bonus_button.dart';

class TestListTile extends StatelessWidget {
  final bool isFavourite;
  final String title;
  final String image;
  final int bonus;
  final Function onTap;

  const TestListTile({
    Key key,
    this.isFavourite = false,
    @required this.title,
    @required this.image,
    @required this.bonus,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          onTap: onTap,
          child: Container(
            // height: 150.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withOpacity(0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        title.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Divider(color: Colors.white, thickness: 2.0, height: 2.0, indent: 16.0, endIndent: 16.0),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BarsCard(),
                          const SizedBox(width: 24.0),
                          BonusButton(points: bonus),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
