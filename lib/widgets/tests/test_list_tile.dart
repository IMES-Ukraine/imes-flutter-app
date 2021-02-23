import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:imes/resources/resources.dart';
import 'package:imes/widgets/base/bonus_button.dart';

class TestListTile extends StatelessWidget {
  final bool isFavourite;
  final String title;
  final String image;
  final int bonus;
  final String testType;
  final String answerType;
  final Function onTap;

  const TestListTile({
    Key key,
    this.isFavourite = false,
    @required this.title,
    @required this.image,
    @required this.bonus,
    @required this.testType,
    @required this.answerType,
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
          decoration: BoxDecoration(
            image: DecorationImage(image: CachedNetworkImageProvider(image), fit: BoxFit.cover),
          ),
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                title.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(color: Colors.white, thickness: 2.0, height: 2.0, indent: 16.0, endIndent: 16.0),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Card(
                              margin: EdgeInsets.zero,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(9.0),
                                child: Image.asset(testType == 'complex'
                                    ? Images.testLevel3
                                    : answerType == 'text'
                                        ? Images.testLevel2
                                        : Images.testLevel1),
                              ),
                            ),
                            const SizedBox(width: 24.0),
                            BonusButton(points: bonus),
                          ],
                        ),
                      ),
                    ],
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
