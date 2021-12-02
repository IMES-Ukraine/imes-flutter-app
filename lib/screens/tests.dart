import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:imes/blocs/tests_notifier.dart';
import 'package:imes/models/test.dart';
import 'package:imes/resources/repository.dart';
import 'package:imes/widgets/base/alert_container.dart';
import 'package:imes/widgets/base/custom_alert_dialog.dart';
import 'package:imes/widgets/base/custom_checkbox.dart';
import 'package:imes/widgets/base/custom_flat_button.dart';
import 'package:imes/widgets/base/error_retry.dart';
import 'package:imes/widgets/base/raised_gradient_button.dart';
import 'package:imes/widgets/tests/test_list_tile.dart';
import 'package:imes/widgets/tests/tests_app_bar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class TestsPage extends StatefulWidget {
  @override
  _TestsPageState createState() => _TestsPageState();
}

class _TestsPageState extends State<TestsPage> {
  final _notifier = TestsStateNotifier();

  @override
  Widget build(BuildContext mainContext) {
    return ChangeNotifierProvider(
      create: (_) => _notifier..init(),
      child: Builder(
        builder: (context) => Consumer<TestsStateNotifier>(
          builder: (mainContext, testsNotifier, _) {
            return Scaffold(
              appBar: TestsAppBar(),
              body: testsNotifier.state == TestsState.ERROR
                  ? ErrorRetry(onTap: () {
                      testsNotifier.pagingController.refresh();
                    })
                  : RefreshIndicator(
                      onRefresh: () async {
                        testsNotifier.pagingController.refresh();
                        await Future.delayed(const Duration(seconds: 1));
                      },
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return _Content(
                            testsNotifier: testsNotifier,
                            constraints: constraints,
                          );
                        },
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key key,
    @required this.testsNotifier,
    @required this.constraints,
  }) : super(key: key);

  final TestsStateNotifier testsNotifier;
  final BoxConstraints constraints;

  Future<void> _openTest(BuildContext context, Test test) async {
    await Navigator.of(context).pushNamed('/tests/view', arguments: test.id);
    testsNotifier.pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Test>(
      pagingController: testsNotifier.pagingController,
      builderDelegate: PagedChildBuilderDelegate<Test>(
        itemBuilder: (context, item, index) => TestListTile(
          title: item?.title ?? '',
          bonus: item?.bonus ?? 0,
          image: item.coverImage?.path ?? '',
          answerType: item.answerType,
          testType: item.testType,
          onTap: () async {
            final result = await showDialog(
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
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.bold),
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
                            'Увага!\n\nПереконайтеся, що Ви готові до участі в даному дослідженні, так як кількість спроб обмежена',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 12.0),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                }) as bool;
            if (result) {
              print(result.toString());
              if (item?.agreementAccepted?.isEmpty ?? true) {
                final response = await Repository().api.getAgreement(item.id);
                showDialog(
                    context: context,
                    builder: (innerContext) {
                      return HookBuilder(builder: (ctx) {
                        final checkBoxState = useState(false);
                        return CustomAlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Згода на участь в дослідженні',
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              if (response?.body?.data?.agreement?.isNotEmpty ==
                                  true) ...[
                                Container(
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xFFA1A1A1)),
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 250.0,
                                      child: SingleChildScrollView(
                                          child: Text(
                                              response.body.data.agreement,
                                              style:
                                                  TextStyle(fontSize: 12.0))),
                                    ),
                                  ),
                                ),
                              ],
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    CustomCheckbox(
                                      value: checkBoxState.value,
                                      onTap: () => checkBoxState.value =
                                          !checkBoxState.value,
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: RaisedGradientButton(
                                  onPressed: checkBoxState.value
                                      ? () async {
                                          await Repository()
                                              .api
                                              .postAgreement(item.id);
                                          Navigator.of(innerContext).pop();
                                          _openTest(context, item);
                                        }
                                      : null,
                                  child: Text(
                                    'РОЗПОЧАТИ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                    });
              } else {
                _openTest(context, item);
              }
            }
          },
        ),
      ),
    );
  }
}
