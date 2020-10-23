import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:imes/blocs/test_notifier.dart';
import 'package:imes/helpers/utils.dart';
import 'package:imes/hooks/test_timer_hook.dart';
import 'package:imes/models/test.dart';
import 'package:imes/widgets/base/custom_alert_dialog.dart';
import 'package:imes/widgets/base/custom_dialog.dart';
import 'package:imes/widgets/base/raised_gradient_button.dart';
import 'package:imes/widgets/tests/test_card.dart';
import 'package:imes/widgets/tests/test_title.dart';
import 'package:imes/widgets/tests/test_variant_flat_button.dart';
import 'package:provider/provider.dart';

class SimpleTest extends HookWidget {
  final Test test;

  SimpleTest({
    Key key,
    @required this.test,
  });

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
                          testNotifier
                              .postAnswer(
                            test.id,
                            [state.value ?? controller.text],
                            durationTimer.value,
                          )
                              .then((_) {
                            Navigator.of(context).pop();
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
