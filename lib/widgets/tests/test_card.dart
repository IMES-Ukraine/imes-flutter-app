import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:imes/models/test.dart';
import 'package:imes/resources/repository.dart';
import 'package:imes/resources/resources.dart';
import 'package:imes/screens/blog_view.dart';
import 'package:imes/widgets/base/bonus_button.dart';
import 'package:octo_image/octo_image.dart';

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
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (test?.coverImage?.path?.isNotEmpty == true)
                  Expanded(
                    child: OctoImage(
                      image: CachedNetworkImageProvider(
                          '$BASE_URL${test?.coverImage?.path}'),
                      placeholderBuilder: OctoPlaceholder.blurHash(
                          'LKO2?V%2Tw=w]~RBVZRi};RPxuwH'),
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
                                      Card(
                                        margin: EdgeInsets.zero,
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(9.0),
                                          child: Image.asset(
                                              test.testType == 'complext'
                                                  ? Images.testLevel3
                                                  : test.answerType == 'text'
                                                      ? Images.testLevel2
                                                      : Images.testLevel1),
                                        ),
                                      ),
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
                    child: Text(test.description.data,
                        style: TextStyle(fontSize: 10.0)),
                  )),
              ],
            ),
          ),
          if (test.hasToLearn)
            InkWell(
              onTap: () async {
                final option = test.toLearn;
                if (option.type == 'to_learn' && option.data != null) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => BlogViewPage(option.data as int)));
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
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
