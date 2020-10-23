import 'package:flutter/material.dart';
import 'package:imes/blocs/test_notifier.dart';
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
        body: Consumer<TestNotifier>(builder: (context, testNotifier, _) {
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
    );
  }
}
