import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:imes/blocs/test_notifier.dart';
import 'package:imes/blocs/user_notifier.dart';
import 'package:imes/helpers/utils.dart';
import 'package:imes/hooks/test_timer_hook.dart';
import 'package:imes/models/test.dart';
import 'package:imes/widgets/base/custom_alert_dialog.dart';
import 'package:imes/widgets/base/custom_dialog.dart';
import 'package:imes/widgets/base/custom_flat_button.dart';
import 'package:imes/widgets/base/raised_gradient_button.dart';
import 'package:imes/widgets/tests/test_card.dart';
import 'package:imes/widgets/tests/test_title.dart';
import 'package:imes/widgets/tests/test_variant_flat_button.dart';
import 'package:provider/provider.dart';

class SimpleTest extends HookWidget {
  SimpleTest({
    Key key,
    @required this.test,
  });

  final Test test;

  @override
  Widget build(BuildContext context) {
    final durationTimer = useCountDownValueNotifier(context, Duration(seconds: test.duration));
    final controller = useTextEditingController();
    final state = useState<String>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TestTitle(title: 'Тест простой', duration: durationTimer),
          TestCard(test: test),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('ВОПРОС',
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(test.question,
                style: TextStyle(
                  fontSize: 12.0,
                  color: Color(0xFFA1A1A1), // TODO: extract color to theme
                )),
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
                      .map(
                        (v) => TestVariantFlatButton(
                          variant: v.variant,
                          title: v.title,
                          selected: state.value == v.variant,
                          onTap: () {
                            state.value = v.variant;
                          },
                        ),
                      )
                      .toList(),
                ],
              ),
            )
          else if (test.answerType == 'text')
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(border: OutlineInputBorder()),
                minLines: 5,
                maxLines: 5,
              ),
            ),
          Consumer<TestNotifier>(builder: (context, testNotifier, _) {
            return Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 16.0),
              child: RaisedGradientButton(
                  child: Text('ВІДПОВІДЬ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  onPressed: state.value != null || controller.text.isNotEmpty
                      ? () {
                          FocusScope.of(context).unfocus();
                          testNotifier
                              .postAnswer(
                            test.id,
                            [state.value ?? controller.text],
                            durationTimer.value,
                          )
                              .then((user) {
                            Future dialogFuture;
                            if (test.answerType == 'text') {
                              dialogFuture = showDialog(
                                  context: context,
                                  builder: (context) => CustomAlertDialog(
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Відповідь відправлена на модерацію',
                                              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 16.0),
                                            Text(
                                              'Бали можуть бути нараховані тільки після модерації',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: CustomFlatButton(
                                                  text: 'OK',
                                                  color: Theme.of(context).primaryColor,
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ));
                            } else {
                              dialogFuture = showDialog(
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
                                      ));
                            }
                            dialogFuture.then((_) {
                              context.read<UserNotifier>().updateUser(user);
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
                      : null),
            );
          }),
        ],
      ),
    );
  }
}
