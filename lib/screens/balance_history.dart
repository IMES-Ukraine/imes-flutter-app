import 'package:flutter/material.dart';
import 'package:imes/blocs/history_notifier.dart';
import 'package:imes/blocs/user_notifier.dart';
import 'package:imes/resources/resources.dart';
import 'package:imes/utils/constants.dart';
import 'package:imes/widgets/base/error_retry.dart';
import 'package:imes/widgets/history_tile.dart';
import 'package:provider/provider.dart';

class BalanceHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final historyNotifier = HistoryNotifier();
        historyNotifier.loadHistory();
        return historyNotifier;
      },
      child: Consumer2<UserNotifier, HistoryNotifier>(
        builder: (context, userNotifier, historyNotifier, _) {
          return Scaffold(
            appBar: AppBar(
              elevation: 1,
              title: Text(
                'Історія обміну'.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                  height: 23 / 17,
                  color: const Color(0xFF606060),
                ),
              ),
              centerTitle: true,
            ),
            body: historyNotifier.state == HistoryState.ERROR
                ? ErrorRetry(onTap: () {
                    historyNotifier.loadHistory();
                  })
                : RefreshIndicator(
                    onRefresh: () => historyNotifier.loadHistory(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 24),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              '${userNotifier.user.balance ?? 0}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 48.0,
                                fontWeight: FontWeight.w700,
                                height: 59 / 48,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(Images.token),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'IMIC',
                                style: TextStyle(
                                  color: Constants.brandBlueColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  height: 22 / 18,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          ListView.separated(
                            padding: const EdgeInsets.all(16),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                                historyNotifier.state == HistoryState.LOADING
                                    ? 1
                                    : historyNotifier.items.length + 1,
                            itemBuilder: (context, index) {
                              if (historyNotifier.state ==
                                  HistoryState.LOADING) {
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

                                if (historyNotifier.items.length ==
                                    historyNotifier.total) {
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
                              return SizedBox(
                                height: historyNotifier.items.length > 1 &&
                                        index !=
                                            historyNotifier.items.length - 1
                                    ? 10
                                    : 0,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
