import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imes/blocs/history_notifier.dart';
import 'package:imes/helpers/custom_icons_icons.dart';
import 'package:imes/helpers/utils.dart';
import 'package:imes/resources/resources.dart';
import 'package:imes/screens/withdraw.dart';

import 'package:imes/widgets/base/custom_dialog.dart';
import 'package:imes/widgets/base/custom_alert_dialog.dart';
import 'package:imes/widgets/base/notifications_button.dart';

import 'package:imes/blocs/user_notifier.dart';
import 'package:imes/blocs/balance_notifier.dart';
import 'package:imes/widgets/base/raised_gradient_button.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

class BalancePage extends StatefulWidget {
  @override
  _BalancePageState createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userNotifier = Provider.of<UserNotifier>(context, listen: false);
      await userNotifier.updateProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('БАЛАНС', style: TextStyle(fontWeight: FontWeight.w800))),
      body: ChangeNotifierProvider(
        create: (_) => HistoryNotifier()..load(),
        child: Consumer2<UserNotifier, HistoryNotifier>(builder: (context, userNotifier, historyNotifier, _) {
          return SafeArea(
            child: Stack(
              children: <Widget>[
                NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (notification) {
                    return true;
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Icon(CustomIcons.blog_heart, color: Theme.of(context).primaryColor, size: 36.0),
                            const SizedBox(width: 16.0),
                            Text(
                              '${userNotifier.user.balance ?? 0}',
                              style: TextStyle(
                                fontSize: 50.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFA1A1A1),
                              ),
                            ),
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 48.0),
                          child: RaisedGradientButton(
                              child: Text(
                                'ОБМІНЯТИ БАЛИ',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => WithdrawPage()));
                              }),
                        ),
                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: ExpansionTile(
                            title: Text(
                              'ІСТОРІЯ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onExpansionChanged: (opened) {
                              if (opened) {
                                historyNotifier.load();
                              }
                            },
                            children: historyNotifier.items
                                .map((e) => ListTile(
                                    leading: Text('${e.total ?? 0}',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    title: Text(e.comment ?? ''),
                                    trailing: Text(
                                      DateFormat.yMd().format(e.createdAt ?? ''),
                                      style: TextStyle(fontSize: 11, color: Color(0xFFA1A1A1)),
                                    )))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // if (history.state == BalanceState.PROCESSING)
                //   Stack(
                //     children: <Widget>[
                //       Opacity(
                //         opacity: 0.3,
                //         child: const ModalBarrier(
                //           dismissible: false,
                //           color: Colors.grey,
                //         ),
                //       ),
                //       Center(
                //         child: CircularProgressIndicator(),
                //       ),
                //     ],
                //   )
              ],
            ),
          );
        }),
      ),
    );
  }
}
