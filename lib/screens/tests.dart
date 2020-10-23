import 'package:flutter/material.dart';
import 'package:imes/blocs/tests.dart';
import 'package:imes/widgets/error_retry.dart';
import 'package:imes/widgets/test_list_tile.dart';
import 'package:imes/widgets/tests_app_bar.dart';
import 'package:provider/provider.dart';

class TestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TestsStateNotifier()..load(),
      // lazy: false,
      child: Builder(
        builder: (context) => Consumer<TestsStateNotifier>(builder: (context, testsNotifier, _) {
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
                            Navigator.of(context).pushNamed('/tests/view', arguments: testsNotifier.tests[index].id);
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
