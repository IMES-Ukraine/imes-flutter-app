import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:imes/blocs/history_notifier.dart';
import 'package:imes/helpers/custom_icons_icons.dart';
import 'package:imes/helpers/utils.dart';
import 'package:imes/resources/resources.dart';

import 'package:imes/widgets/base/custom_dialog.dart';
import 'package:imes/widgets/base/custom_alert_dialog.dart';
import 'package:imes/widgets/base/custom_flat_button.dart';
import 'package:imes/widgets/base/notifications_button.dart';

import 'package:imes/blocs/user_notifier.dart';
import 'package:imes/blocs/balance_notifier.dart';
import 'package:imes/widgets/base/raised_gradient_button.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

class WithdrawPage extends StatefulHookWidget {
  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  var _timer;

  @override
  Widget build(BuildContext context) {
    final selectedType = useState('card');
    final sendBalance = useState(context.watch<UserNotifier>().user.balance);

    return Scaffold(
      appBar: AppBar(title: Text('ОБМІН', style: TextStyle(fontWeight: FontWeight.w800))),
      body: ChangeNotifierProvider(
        create: (_) => BalanceNotifier(),
        child: Consumer2<UserNotifier, BalanceNotifier>(builder: (context, userNotifier, balanceNotifier, _) {
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
                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: ExpansionTile(
                              title: Text(
                                'БАЛАНС',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(children: [
                                    Image.asset(Images.token),
                                    const SizedBox(width: 16.0),
                                    Text(
                                      '${userNotifier.user.balance ?? 0}',
                                      style: TextStyle(
                                        fontSize: 36.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFA1A1A1),
                                      ),
                                    ),
                                  ]),
                                ),
                              ]),
                        ),
                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: ExpansionTile(
                            title: Text(
                              'ТИП ПЕРЕКАЗУ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            children: [
                              Row(
                                children: [
                                  Radio(
                                      value: 'card',
                                      groupValue: selectedType.value,
                                      onChanged: (value) {
                                        selectedType.value = value;
                                      }),
                                  Text('на карту', style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     Radio(
                              //         value: 'certificate',
                              //         groupValue: selectedType.value,
                              //         onChanged: (value) {
                              //           selectedType.value = value;
                              //         }),
                              //     Text('сертифікати', style: TextStyle(fontWeight: FontWeight.bold)),
                              //   ],
                              // ),
                              // Row(
                              //   children: [
                              //     Radio(
                              //         value: 'special',
                              //         groupValue: selectedType.value,
                              //         onChanged: (value) {
                              //           selectedType.value = value;
                              //         }),
                              //     Text('візит спеціальних заходів', style: TextStyle(fontWeight: FontWeight.bold)),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: ExpansionTile(
                            title: Text(
                              'СУМА ПЕРЕКАЗУ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            children: [
                              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                GestureDetector(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text('-', style: TextStyle(fontSize: 32.0)),
                                  ),
                                  onTap: () => sendBalance.value > 20 ? sendBalance.value-- : null,
                                  onLongPress: () {
                                    _timer = Timer.periodic(const Duration(milliseconds: 30),
                                        (timer) => sendBalance.value > 20 ? sendBalance.value-- : timer.cancel());
                                  },
                                  onLongPressUp: () {
                                    _timer.cancel();
                                  },
                                ),
                                const SizedBox(width: 16.0),
                                Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 64.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Theme.of(context).primaryColor),
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    child: AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 200),
                                      reverseDuration: const Duration(milliseconds: 500),
                                      child: Text('${sendBalance.value}',
                                          key: ValueKey<int>(sendBalance.value),
                                          style: TextStyle(fontSize: 18.0, color: Theme.of(context).primaryColor)),
                                    )),
                                const SizedBox(width: 16.0),
                                GestureDetector(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text('+', style: TextStyle(fontSize: 32.0)),
                                  ),
                                  onTap: () =>
                                      sendBalance.value < userNotifier.user.balance ? sendBalance.value++ : null,
                                  onLongPress: () {
                                    _timer = Timer.periodic(
                                        const Duration(milliseconds: 30),
                                        (timer) => sendBalance.value < userNotifier.user.balance
                                            ? sendBalance.value++
                                            : timer.cancel());
                                  },
                                  onLongPressUp: () {
                                    _timer.cancel();
                                  },
                                ),
                              ]),
                              const SizedBox(height: 16.0),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 48.0),
                          child: RaisedGradientButton(
                              child: Text(
                                'ПЕРЕВЕСТИ БАЛИ',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              onPressed: sendBalance.value >= 20
                                  ? () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => CustomAlertDialog(
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      'Підтвердіть',
                                                      style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(16.0),
                                                      child:
                                                          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                        Image.asset(Images.token),
                                                        const SizedBox(width: 16.0),
                                                        Text(
                                                          '${userNotifier.user.balance ?? 0}',
                                                          style: TextStyle(
                                                            fontSize: 36.0,
                                                            fontWeight: FontWeight.bold,
                                                            color: Color(0xFFA1A1A1),
                                                          ),
                                                        ),
                                                      ]),
                                                    ),
                                                    Text(
                                                      'на карту',
                                                      style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    const SizedBox(height: 16.0),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                                          child: CustomFlatButton(
                                                              text: 'ТАК',
                                                              color: Theme.of(context).primaryColor,
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                                balanceNotifier
                                                                    .submit(
                                                                        amount: sendBalance.value,
                                                                        type: selectedType.value)
                                                                    .then((user) {
                                                                  userNotifier.updateUser(user);
                                                                }).catchError((error) {
                                                                  balanceNotifier.resetState();
                                                                  print(error);
                                                                  showDialog(
                                                                    context: context,
                                                                    builder: (context) {
                                                                      return CustomAlertDialog(
                                                                        content: CustomDialog(
                                                                          icon: Icons.close,
                                                                          color: Theme.of(context).errorColor,
                                                                          text: Utils.getErrorText(
                                                                              error?.body?.toString() ??
                                                                                  'unkown_error'),
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                });
                                                              }),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                                          child: CustomFlatButton(
                                                              text: 'НІ',
                                                              color: Theme.of(context).errorColor,
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              }),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ));
                                    }
                                  : null),
                        ),
                      ],
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
      ),
    );
  }
}
