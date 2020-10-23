import 'package:flutter/material.dart';
import 'package:imes/models/test.dart';
import 'package:imes/widgets/bars_card.dart';
import 'package:imes/widgets/bonus_button.dart';
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
                  child: Container(
                    height: test.hasDescription ? double.infinity : 200.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(test.coverImage.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Row(
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
                color: Colors.lightBlue,
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
