import 'package:flutter/material.dart';
import 'package:imes/blocs/test_notifier.dart';
import 'package:imes/widgets/base/alert_container.dart';
import 'package:imes/widgets/base/custom_alert_dialog.dart';
import 'package:imes/widgets/base/custom_flat_button.dart';
import 'package:imes/widgets/base/error_retry.dart';
import 'package:imes/widgets/tests/complex_test.dart';
import 'package:imes/widgets/tests/simple_test.dart';
import 'package:provider/provider.dart';

class TestViewPage extends StatefulWidget {
  TestViewPage(this.id);

  final num id;

  @override
  _TestViewPageState createState() => _TestViewPageState();
}

class _TestViewPageState extends State<TestViewPage> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return ChangeNotifierProvider(
      create: (_) => TestNotifier()..load(widget.id),
      child: Scaffold(
        appBar: AppBar(),
        body: WillPopScope(
          onWillPop: () {
            return showDialog(
                context: context,
                builder: (context) => CustomAlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Закрити тест?',
                            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16.0),
                          AlertContainer(
                            child: Text(
                              'Внимание!\n\nВы находитесь в режиме прохождения теста. Повторноепрохождение будет недоступно.',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: CustomFlatButton(
                                text: 'ЗАКРИТИ',
                                color: Theme.of(context).errorColor,
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                }),
                          ),
                          const SizedBox(height: 8.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: CustomFlatButton(
                                text: 'ПРОДОВЖИТИ',
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                }),
                          ),
                        ],
                      ),
                    ));
          },
          child: Consumer<TestNotifier>(builder: (context, testNotifier, _) {
            if (testNotifier.state == TestState.ERROR) {
              return ErrorRetry(onTap: () {
                testNotifier.load(widget.id);
              });
            }

            if (testNotifier.state == TestState.LOADING) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            switch (testNotifier.test.testType) {
              case 'complex':
                return ComplexTest(test: testNotifier.test);
              case 'simple':
              default:
                return SimpleTest(test: testNotifier.test);
            }
          }),
        ),
      ),
    );
  }
}
