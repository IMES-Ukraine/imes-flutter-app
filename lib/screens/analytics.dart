import 'package:flutter/material.dart';

import 'package:imes/blocs/analytics_notifier.dart';

import 'package:imes/widgets/base/error_retry.dart';
import 'package:imes/widgets/analytics/analytics_tile.dart';
import 'package:imes/widgets/analytics/analytics_app_bar.dart';

import 'package:provider/provider.dart';

class AnalyticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final analyticsNotifier = AnalyticsNotifier();
        analyticsNotifier.load(DateTime.now());
        return analyticsNotifier;
      },
      child: Consumer<AnalyticsNotifier>(
        builder: (context, analyticsNotifier, _) {
          return Scaffold(
            appBar: AnalyticsAppBar(
              date: analyticsNotifier.date,
              onDatePicked: (date) {
                if (date != null) {
                  analyticsNotifier.load(date);
                }
              },
            ),
            body: analyticsNotifier.state == AnalyticsState.ERROR
                ? ErrorRetry(onTap: () {
                    analyticsNotifier.load(null);
                  })
                : Card(
                    margin: const EdgeInsets.all(16.0),
                    child: RefreshIndicator(
                      onRefresh: () => analyticsNotifier.load(null),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: analyticsNotifier.state == AnalyticsState.LOADING
                            ? 1
                            : analyticsNotifier.analytics.length + 1,
                        itemBuilder: (context, index) {
                          if (analyticsNotifier.state == AnalyticsState.LOADING) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          if (index == analyticsNotifier.analytics.length) {
                            if (analyticsNotifier.analytics.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Аналітика відсутня.'),
                                ),
                              );
                            }

                            if (analyticsNotifier.analytics.length == analyticsNotifier.total) {
                              return null;
                            }

                            analyticsNotifier.loadNext();
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          return AnalyticsListTile(
                            index: index,
                            photoId: analyticsNotifier.analytics[index].photoId?.toUpperCase() ?? '',
                            date: analyticsNotifier.analytics[index].createdAt,
                            count: analyticsNotifier.analytics[index]?.count ?? 0,
                            status: analyticsNotifier.analytics[index]?.status ?? 0,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => GestureDetector(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/tlogic-aed50.appspot.com/o/bills%2F${analyticsNotifier.analytics[index].photoId}.jpg?alt=media',
                                          fit: BoxFit.scaleDown,
                                          height: MediaQuery.of(context).size.height / 1.5,
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;

                                            return Center(
                                                child: CircularProgressIndicator(
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded /
                                                      loadingProgress.expectedTotalBytes
                                                  : null,
                                            ));
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return analyticsNotifier.analytics.length > 1 &&
                                  index != analyticsNotifier.analytics.length - 1
                              ? const Divider(
                                  height: 1.0,
                                )
                              : const SizedBox();
                        },
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
