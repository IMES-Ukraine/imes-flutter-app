import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:imes/blocs/test_notifier.dart';
import 'package:imes/blocs/user_notifier.dart';
import 'package:imes/helpers/utils.dart';
import 'package:imes/hooks/observable.dart';
import 'package:imes/hooks/test_timer_hook.dart';
import 'package:imes/models/test.dart';
import 'package:imes/models/test_answer.dart';
import 'package:imes/widgets/base/custom_alert_dialog.dart';
import 'package:imes/widgets/base/custom_dialog.dart';
import 'package:imes/widgets/base/custom_flat_button.dart';
import 'package:imes/widgets/base/raised_gradient_button.dart';
import 'package:imes/widgets/tests/test_card.dart';
import 'package:imes/widgets/tests/test_title.dart';
import 'package:imes/widgets/tests/test_variant_card_button.dart';
import 'package:imes/widgets/tests/test_variant_flat_button.dart';
import 'package:imes/widgets/tests/test_vide_card.dart';
import 'package:observable/observable.dart';
import 'package:provider/provider.dart';

class ComplexTest extends HookWidget {
  ComplexTest({
    Key key,
    @required this.test,
  });

  final Test test;

  @override
  Widget build(BuildContext context) {
    final durationTimer = useCountDownValueNotifier(context, Duration(seconds: test.duration));
    final state = useValueNotifier(ObservableMap());
    final controller = useScrollController();
    final step = useState(1);

    return CustomScrollView(
      controller: controller,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              TestTitle(title: 'Тест сложный', duration: durationTimer),
              TestCard(test: test),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Column(
                children: [
                  Divider(indent: 8.0, endIndent: 8.0),
                  Text(
                    test.complex[index].question,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (test.complex[index].hasVideo) TestVideoCard(url: test.complex[index].video.data),
                  if (test.complex[index].answerType == 'variants')
                    HookBuilder(builder: (_) {
                      useObservable(state);
                      if (test.complex[index].variants.type == 'text') {
                        return Column(
                            children: test.complex[index].variants.buttons.map((v) {
                          return TestVariantFlatButton(
                            variant: v.variant,
                            title: v.title,
                            selected: state.value[test.complex[index].id] == v.variant,
                            selectedColor: index < step.value - 1
                                ? state.value[test.complex[index].id] == test.complex[index].variants.correctAnswer
                                    ? Theme.of(context).errorColor
                                    : Color(0xFF4CF99E) // TODO: extract color to theme
                                : null,
                            onTap: index < step.value - 1
                                ? null
                                : () {
                                    state.value[test.complex[index].id] = v.variant;
                                  },
                          );
                        }).toList());
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: test.complex[index].variants.buttons.map((v) {
                              return ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: (MediaQuery.of(context).size.width - 24.0) / 2.0),
                                child: TestVariantCardButton(
                                  variant: v.variant,
                                  title: v.title,
                                  descr: v.description,
                                  imageUrl: v.file.path,
                                  selected: state.value[test.complex[index].id] == v.variant,
                                  selectedColor: index < step.value - 1
                                      ? state.value[test.complex[index].id] ==
                                              test.complex[index].variants.correctAnswer
                                          ? Theme.of(context).errorColor
                                          : Color(0xFF4CF99E) // TODO: extract color to theme
                                      : null,
                                  onTap: index < step.value - 1
                                      ? null
                                      : () {
                                          state.value[test.complex[index].id] = v.variant;
                                        },
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      }
                    })
                  else if (test.complex[index].answerType == 'text')
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        // controller: controller,
                        decoration: InputDecoration(border: OutlineInputBorder()),
                        minLines: 5,
                        maxLines: 5,
                      ),
                    ),
                  HookBuilder(builder: (context) {
                    useObservable(state);
                    return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: RaisedGradientButton(
                        child: Text('ВІДПОВІДЬ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        onPressed: state.value[test.complex[index].id] != null && index == step.value - 1
                            ? () {
                                if (step.value < test.complex.length) {
                                  step.value++;
                                  controller.animateTo(
                                      controller.position.maxScrollExtent + controller.position.viewportDimension,
                                      duration: const Duration(milliseconds: 500),
                                      curve: Curves.easeIn);
                                } else {
                                  final testNotifier = context.read<TestNotifier>();
                                  final userNotifier = context.read<UserNotifier>();
                                  testNotifier
                                      .postAnswers(
                                    state.value.entries.map((e) => TestAnswer(id: e.key, variant: e.value)).toList(),
                                    durationTimer.value,
                                  )
                                      .then((user) {
                                    showDialog(
                                        context: context,
                                        builder: (context) => CustomAlertDialog(
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'Ви пройшли тест!',
                                                    style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 16.0),
                                                  Text(
                                                    '${test.bonus} балів',
                                                    style: TextStyle(
                                                      fontSize: 23.0,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF4CF99E),
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    'зараховано на баланс',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF4CF99E),
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Divider(indent: 8.0, endIndent: 8.0),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                                    child: CustomFlatButton(
                                                        text: 'OK',
                                                        color: Theme.of(context).primaryColor,
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        }),
                                                  ),
                                                ],
                                              ),
                                            )).then((_) {
                                      userNotifier.updateUser(user);
                                      Navigator.of(context).pop();
                                    });
                                  }).catchError((error) {
                                    print(error);
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return CustomAlertDialog(
                                          content: CustomDialog(
                                            icon: Icons.close,
                                            color: Theme.of(context).errorColor,
                                            text: Utils.getErrorText(error?.body?.toString() ?? 'unkown_error'),
                                          ),
                                        );
                                      },
                                    );
                                  });
                                }
                              }
                            : null,
                      ),
                    );
                  }),
                ],
              );
            },
            childCount: step.value,
          ),
        ),
      ],
    );
  }
}
