import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:imes/hooks/observable.dart';
import 'package:imes/hooks/test_timer_hook.dart';
import 'package:imes/models/test.dart';
import 'package:imes/widgets/tests/test_card.dart';
import 'package:imes/widgets/tests/test_title.dart';
import 'package:imes/widgets/tests/test_variant_flat_button.dart';
import 'package:imes/widgets/tests/test_vide_card.dart';
import 'package:observable/observable.dart';

class ComplexTest extends HookWidget {
  final Test test;

  ComplexTest({
    Key key,
    @required this.test,
  });

  @override
  Widget build(BuildContext context) {
    final durationTimer = useCountDownValueNotifier(context, Duration(seconds: test.duration));
    final state = useValueNotifier(ObservableMap());

    return SingleChildScrollView(
      child: Column(
        children: [
          TestTitle(title: 'Тест сложный', duration: durationTimer),
          TestCard(test: test),
          ...test.complex.map((t) {
            return Column(
              children: [
                Divider(indent: 8.0, endIndent: 8.0),
                Text(
                  t.question,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF00B7FF),
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (t.hasVideo) TestVideoCard(url: t.video.data),
                if (t.answerType == 'variants')
                  HookBuilder(builder: (_) {
                    useObservable(state);
                    return Column(
                        children: t.variants.buttons.map((v) {
                      return TestVariantFlatButton(
                        variant: v.variant,
                        title: v.title,
                        selected: state.value[t.id] == v.variant,
                        onTap: () {
                          state.value[t.id] = v.variant;
                        },
                      );
                    }).toList());
                  })
                else if (t.answerType == 'text')
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      // controller: controller,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      minLines: 5,
                      maxLines: 5,
                    ),
                  ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
