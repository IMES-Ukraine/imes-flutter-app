import 'package:flutter/material.dart';

import 'package:pharmatracker/widgets/error_retry.dart';

import 'package:pharmatracker/blocs/history_notifier.dart';

import 'package:pharmatracker/widgets/history_tile.dart';

import 'package:provider/provider.dart';

class BalanceHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final historyNotifier = HistoryNotifier();
        historyNotifier.load();
        return historyNotifier;
      },
      child: Consumer<HistoryNotifier>(builder: (context, historyNotifier, _) {
        return Scaffold(
          appBar: AppBar(),
          body: historyNotifier.state == HistoryState.ERROR
              ? ErrorRetry(onTap: () {
                  historyNotifier.load();
                })
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 32.0, top: 16.0),
                      child: Text(
                        'Історія переказів',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        margin: const EdgeInsets.all(16.0),
                        child: RefreshIndicator(
                          onRefresh: () => historyNotifier.load(),
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount:
                                historyNotifier.state == HistoryState.LOADING ? 1 : historyNotifier.items.length + 1,
                            itemBuilder: (context, index) {
                              if (historyNotifier.state == HistoryState.LOADING) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              if (index == historyNotifier.items.length) {
                                if (historyNotifier.items.isEmpty) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Історія відсутня.'),
                                    ),
                                  );
                                }

                                if (historyNotifier.items.length == historyNotifier.total) {
                                  return null;
                                }

                                historyNotifier.loadNext();
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              return HistoryListTile(
                                index: index,
                                date: historyNotifier.items[index].createdAt,
                                total: historyNotifier.items[index].total,
                                type: historyNotifier.items[index].type,
                              );
                            },
                            separatorBuilder: (context, index) {
                              return historyNotifier.items.length > 1 && index != historyNotifier.items.length - 1
                                  ? const Divider(
                                      height: 1.0,
                                    )
                                  : const SizedBox();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        );
      }),
    );
  }
}
