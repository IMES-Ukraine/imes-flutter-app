import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:imes/blocs/test_notifier.dart';
import 'package:imes/blocs/tests_notifier.dart';
import 'package:imes/resources/repository.dart';
import 'package:imes/widgets/base/alert_container.dart';
import 'package:imes/widgets/base/custom_alert_dialog.dart';
import 'package:imes/widgets/base/custom_checkbox.dart';
import 'package:imes/widgets/base/custom_flat_button.dart';
import 'package:imes/widgets/base/error_retry.dart';
import 'package:imes/widgets/base/raised_gradient_button.dart';
import 'package:imes/widgets/tests/test_list_tile.dart';
import 'package:imes/widgets/tests/tests_app_bar.dart';
import 'package:provider/provider.dart';

class TestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext mainContext) {
    return ChangeNotifierProvider(
      create: (_) => TestsStateNotifier()..load(),
      // lazy: false,
      child: Builder(
        builder: (context) => Consumer<TestsStateNotifier>(builder: (mainContext, testsNotifier, _) {
          return Scaffold(
            appBar: TestsAppBar(),
            body: testsNotifier.state == TestsState.ERROR
                ? ErrorRetry(onTap: () {
                    testsNotifier.load();
                  })
                : RefreshIndicator(
                    onRefresh: () => testsNotifier.load(),
                    child: ListView.builder(
                      itemCount: testsNotifier.state == TestsState.LOADING ? 1 : testsNotifier.tests.length + 1,
                      itemBuilder: (context, index) {
                        if (testsNotifier.state == TestsState.LOADING) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (index == testsNotifier.tests.length) {
                          if (testsNotifier.tests.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Тести відсутні.'),
                              ),
                            );
                          }

                          if (testsNotifier.tests.length == testsNotifier.total) {
                            return null;
                          }

                          testsNotifier.loadNext();
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        return TestListTile(
                          title: testsNotifier.tests[index]?.title ?? '',
                          bonus: testsNotifier.tests[index]?.bonus ?? 0,
                          image: testsNotifier.tests[index].coverImage?.path ?? '',
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomAlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Почати тест?',
                                            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                          child: CustomFlatButton(
                                              text: 'ПОЇХАЛИ',
                                              color: Theme.of(context).primaryColor,
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              }),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                          child: CustomFlatButton(
                                              text: 'Я ЩЕ ПОЧИТАЮ',
                                              color: Theme.of(context).primaryColor,
                                              onPressed: () {
                                                Navigator.of(context).pop(false);
                                              }),
                                        ),
                                        const SizedBox(height: 16.0),
                                        AlertContainer(
                                          child: Text(
                                            'Внимание!\n\nУбедитесь, что Вы готовы к участию в данном исследовании, так как количество попыток ограничено',
                                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.0),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).then((value) {
                              if (value) {
                                if (testsNotifier.tests[index]?.agreementAccepted?.isEmpty ?? true) {
                                  Repository().api.getAgreement(testsNotifier.tests[index].id).then((response) {
                                    showDialog(
                                        context: context,
                                        builder: (innerContext) {
                                          return HookBuilder(builder: (context) {
                                            final checkBoxState = useState(false);
                                            return CustomAlertDialog(
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(
                                                      'Згода на участь в дослідженні',
                                                      style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(color: Color(0xFFA1A1A1)),
                                                        borderRadius: BorderRadius.circular(5.0)),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: SizedBox(
                                                        height: 250.0,
                                                        child: SingleChildScrollView(
                                                            child: Text(response.body.data.single.agreement,
                                                                style: TextStyle(fontSize: 12.0))),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                    child: Row(
                                                      children: [
                                                        CustomCheckbox(
                                                          value: checkBoxState.value,
                                                          onTap: () => checkBoxState.value = !checkBoxState.value,
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: RichText(
                                                              text: TextSpan(
                                                                text:
                                                                    'Я ознайомлений з Умовами данної згоди для участі в дослідженні',
                                                                style: TextStyle(
                                                                    fontSize: 11.0,
                                                                    color: Color(
                                                                        0xFF828282)), // TODO: extract colors to theme
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                                    child: RaisedGradientButton(
                                                        child: Text('РОЗПОЧАТИ',
                                                            style: TextStyle(
                                                                color: Colors.white, fontWeight: FontWeight.bold)),
                                                        onPressed: checkBoxState.value
                                                            ? () {
                                                                Repository()
                                                                    .api
                                                                    .postAgreement(testsNotifier.tests[index].id);
                                                                Navigator.of(innerContext).pop();
                                                                Navigator.of(mainContext).pushNamed('/tests/view',
                                                                    arguments: testsNotifier.tests[index].id);
                                                              }
                                                            : null),
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                        });
                                  });
                                } else {
                                  Navigator.of(mainContext)
                                      .pushNamed('/tests/view', arguments: testsNotifier.tests[index].id);
                                }
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
          );
        }),
      ),
    );
  }
}
