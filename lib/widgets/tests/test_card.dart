import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:imes/models/test.dart';
import 'package:imes/widgets/base/bars_card.dart';
import 'package:imes/widgets/base/bonus_button.dart';
import 'package:octo_image/octo_image.dart';
import 'package:url_launcher/url_launcher.dart';

class TestCard extends StatelessWidget {
  final Test test;

  TestCard({
    Key key,
    @required this.test,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: OctoImage(
                    image: CachedNetworkImageProvider(test.coverImage.path),
                    placeholderBuilder: OctoPlaceholder.blurHash('LKO2?V%2Tw=w]~RBVZRi};RPxuwH'),
                    imageBuilder: (context, child) => Container(
                      height: test.hasDescription ? null : 200.0,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          child,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    BarsCard(),
                                    const SizedBox(width: 24.0),
                                    BonusButton(points: test.bonus),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                if (test.hasDescription)
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(test.description.data, style: TextStyle(fontSize: 10.0)),
                  )),
              ],
            ),
          ),
          if (test.hasToLearn)
            InkWell(
              onTap: () async {
                final option = test.toLearn;
                if (await canLaunch(option.data)) {
                  launch(option.data);
                }
              },
              child: Container(
                width: double.infinity,
                color: Theme.of(context).accentColor,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Вивчити інформацію'.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
