import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imes/helpers/utils.dart';
import 'package:imes/resources/resources.dart';

import 'package:imes/widgets/custom_dialog.dart';
import 'package:imes/widgets/custom_alert_dialog.dart';
import 'package:imes/widgets/notifications_button.dart';

import 'package:imes/blocs/user_notifier.dart';
import 'package:imes/blocs/balance_notifier.dart';

import 'package:provider/provider.dart';

class BalancePage extends StatefulWidget {
  @override
  _BalancePageState createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  final TextEditingController _balanceController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userNotifier = Provider.of<UserNotifier>(context);
      await userNotifier.updateProfile();
      _balanceController.text = '${userNotifier?.user?.balance ?? 0}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final balanceNotifier = BalanceNotifier();
        final int balance = Provider.of<UserNotifier>(context).user?.balance ?? 0;
        balanceNotifier.onAmountChanged(balance.toString());
        return balanceNotifier;
      },
      child: Consumer2<UserNotifier, BalanceNotifier>(builder: (context, userNotifier, balanceNotifier, _) {
        return SafeArea(
          child: Stack(
            children: <Widget>[
              NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (notification) {
                  return true;
                },
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - kBottomNavigationBarHeight - 24.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            NotificationsButton(),
                          ],
                        ),
                        Expanded(
                          flex: 2,
                          child: LayoutBuilder(builder: (context, constraints) {
                            final fontSize = MediaQuery.of(context).size.height / 22.0;
                            return Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: (userNotifier.user?.balance ?? 0) > 0
                                        ? Theme.of(context).accentColor
                                        : Color(0xFFE5E5E5),
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        '${userNotifier?.user?.balance ?? 0}',
                                        style: TextStyle(
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.w500,
                                          color: (userNotifier.user?.balance ?? 0) > 0
                                              ? Theme.of(context).accentColor
                                              : Color(0xFFE5E5E5),
                                        ),
                                      ),
                                      Text(
                                        'балів',
                                        style: TextStyle(
                                          fontSize: fontSize / 2.0,
                                          color:
                                              (userNotifier.user?.balance ?? 0) > 0 ? Colors.black : Color(0xFFE5E5E5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 32.0, bottom: 16.0, top: 32.0),
                          child: Text(
                            'Перекази',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                                  child: Column(
                                    children: <Widget>[
//                                      Row(
//                                        children: <Widget>[
//                                          Expanded(
//                                            child: Padding(
//                                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                                              child: DropdownButton(
//                                                style: Theme.of(context).textTheme.body1,
//                                                icon: Icon(Icons.keyboard_arrow_down),
//                                                isExpanded: true,
//                                                hint: Text('Тип переказу'),
//                                                underline: const SizedBox(),
//                                                value: balanceNotifier.type,
//                                                items: [
//                                                  DropdownMenuItem(
//                                                    child: Text(
//                                                      'тип 1',
//                                                      style: TextStyle(color: Colors.black),
//                                                    ),
//                                                    value: 'тип 1',
//                                                  ),
//                                                ],
//                                                onChanged: balanceNotifier.chooseType,
//                                              ),
//                                            ),
//                                          ),
//                                        ],
//                                      ),
//                                      Divider(),
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 16.0, left: 16.0, top: 8.0, bottom: 16.0),
                                            child: Text(
                                              'Кількість балів',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                            child: TextField(
                                              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                                              controller: _balanceController,
                                              keyboardType: TextInputType.numberWithOptions(signed: true),
                                              decoration: null,
                                              textDirection: TextDirection.rtl,
                                              onChanged: balanceNotifier.onAmountChanged,
                                            ),
                                          ))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 16.0, left: 16.0, top: 16.0, bottom: 8.0),
                                            child: Text(
                                              'Додати коментар',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          )
                                        ],
                                      ),
                                      Divider(),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 8.0, bottom: 16.0),
                                        child: TextField(
                                          controller: _commentController,
                                          scrollPadding: const EdgeInsets.all(0.0),
                                          decoration: null,
                                          onChanged: balanceNotifier.onCommentChanged,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if ((userNotifier.user?.balance ?? 0) > 0)
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                      child: OutlineButton(
                                        child: Text(
                                          'Зробити переказ',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        highlightedBorderColor: Theme.of(context).accentColor,
                                        borderSide: BorderSide(color: Theme.of(context).accentColor),
                                        textColor: Theme.of(context).accentColor,
                                        onPressed: () async {
                                          final result = await showDialog(
                                              context: context,
                                              builder: (context) {
                                                return CustomAlertDialog(
                                                  content: Text.rich(
                                                    TextSpan(
                                                        text: 'Зробити переказ\n',
                                                        style: TextStyle(fontSize: 13.0),
                                                        children: [
                                                          TextSpan(
                                                              text: '${_balanceController.text}',
                                                              style:
                                                                  TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                                          TextSpan(text: ' балів')
                                                        ]),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text(
                                                        'Назад',
                                                        style: TextStyle(fontSize: 13.0, color: Color(0xFFA1A1A1)),
                                                      ),
                                                      onPressed: () => Navigator.of(context).pop(false),
                                                    ),
                                                    FlatButton(
                                                      child: Text('Так', style: TextStyle(fontSize: 13.0)),
                                                      onPressed: () => Navigator.of(context).pop(true),
                                                    )
                                                  ],
                                                );
                                              });
                                          if (result) {
                                            balanceNotifier.submit().then((user) {
                                              userNotifier.updateUser(user);
                                              _commentController.clear();
                                              _balanceController.text = '${user.balance}';
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return CustomAlertDialog(
                                                    content: CustomDialog(
                                                      icon: Icons.check,
                                                      text: 'Переказ зроблено',
                                                      color: Theme.of(context).accentColor,
                                                    ),
                                                  );
                                                },
                                              );
                                            }).catchError((error) {
                                              balanceNotifier.resetState();
                                              print(error);
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return CustomAlertDialog(
                                                    content: CustomDialog(
                                                      icon: Icons.close,
                                                      color: Color(0xFFFF5B5E),
                                                      text:
                                                          Utils.getErrorText(error?.body?.toString() ?? 'unkown_error'),
                                                    ),
                                                  );
                                                },
                                              );
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
//                      if (userNotifier.user.balance > 0)
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('/balance/history');
                          },
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 32.0, bottom: 8.0, top: 8.0),
                                child: Image.asset(Images.history),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, bottom: 8.0, top: 8.0),
                                child: Text('Переглянути історію переказів',
                                    style: TextStyle(fontSize: 12.0, color: Color(0xFF828282))),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (balanceNotifier.state == BalanceState.PROCESSING)
                Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 0.3,
                      child: const ModalBarrier(
                        dismissible: false,
                        color: Colors.grey,
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                )
            ],
          ),
        );
      }),
    );
  }
}
