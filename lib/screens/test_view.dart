import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pharmatracker/blocs/test_notifier.dart';
import 'package:pharmatracker/models/test.dart';
import 'package:pharmatracker/widgets/bonus_button.dart';
import 'package:pharmatracker/widgets/raised_gradient_button.dart';
import 'package:provider/provider.dart';

class TestViewPage extends HookWidget {
  final Test test;

  TestViewPage(this.test);

  @override
  Widget build(BuildContext context) {
    switch (test.testType) {
      case 'simple':
      default:
        return ChangeNotifierProvider(
          create: (_) => TestNotifier(),
          child: Scaffold(
            appBar: AppBar(),
            body: Consumer<TestNotifier>(builder: (context, testNotifier, _) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Тест простой',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.all(16.0),
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(test.coverImage.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Row(children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: BonusButton(points: test.bonus),
                              ),
                            ]),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  width: double.infinity,
                                  color: Colors.lightBlue,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      'Вивчити інфрмацію'.toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('ВОПРОС', style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(test.question, style: TextStyle(fontSize: 12.0)),
                    ),
                    Divider(indent: 8.0, endIndent: 8.0),
                    if (test.answerType == 'variants')
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ОТВЕТ', style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16.0),
                            ...test.variants.buttons
                                .map((v) => InkWell(
                                      onTap: () {
                                        testNotifier.select(v.variant);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(4.0),
                                                color: Colors.white,
                                                border: Border.all(
                                                  color: testNotifier.selectedVarint == v.variant
                                                      ? Colors.lightBlue
                                                      : Colors.grey,
                                                )),
                                            child: Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: testNotifier.selectedVarint == v.variant
                                                        ? Colors.lightBlue
                                                        : Colors.white,
                                                    border: Border(
                                                      right: BorderSide(
                                                        width: 1.0,
                                                        style: BorderStyle.solid,
                                                        color: testNotifier.selectedVarint == v.variant
                                                            ? Colors.lightBlue
                                                            : Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(
                                                      v.variant,
                                                      style: TextStyle(
                                                        color: testNotifier.selectedVarint == v.variant
                                                            ? Colors.white
                                                            : Colors.grey,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(v.title),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ))
                                .toList(),
                          ],
                        ),
                      )
                    else if (test.answerType == 'text')
                      const SizedBox(),
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 16.0),
                      child: RaisedGradientButton(
                          child: Text('ВІДПОВІДЬ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          onPressed: () {
                            testNotifier.postAnswer(test.id, testNotifier.selectedVarint).then((_) {
                              Navigator.of(context).pop(test);
                            });
                          }),
                    ),
                  ],
                ),
              );
            }),
          ),
        );
    }
  }
}
