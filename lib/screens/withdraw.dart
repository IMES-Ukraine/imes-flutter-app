import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:imes/helpers/utils.dart';
import 'package:imes/resources/resources.dart';

import 'package:imes/widgets/base/custom_dialog.dart';
import 'package:imes/widgets/base/custom_alert_dialog.dart';
import 'package:imes/widgets/base/custom_flat_button.dart';

import 'package:imes/blocs/user_notifier.dart';
import 'package:imes/blocs/balance_notifier.dart';
import 'package:imes/widgets/base/raised_gradient_button.dart';

import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';

class WithdrawPage extends StatefulHookWidget {
  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  @override
  Widget build(BuildContext context) {
    final userBalance = context.watch<UserNotifier>().user.balance;
    final selectedType = useState('card');
    // final sendBalance = useState(userBalance);
    final sendInputController = useTextEditingController.fromValue(TextEditingValue(text: '$userBalance'));

    // if (sendBalance.value > userBalance) sendBalance.value = userBalance;

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
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                                  child: RaisedGradientButton(
                                    radius: 10.0,
                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                                    onPressed: () {
                                      var val = int.tryParse(sendInputController.text) ?? 0;
                                      if (val > 20) val -= 10;
                                      sendInputController.text = '$val';
                                    },
                                    child: Text('-10',
                                        style: TextStyle(
                                            fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.w500)),
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: sendInputController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                        borderRadius: BorderRadius.circular(36.0),
                                      ),
                                      contentPadding: const EdgeInsets.all(4.0),
                                    ),
                                    style: TextStyle(fontSize: 18.0, color: Theme.of(context).primaryColor),
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      TextInputFormatter.withFunction((oldValue, newValue) {
                                        final val = int.tryParse(newValue.text) ?? 0;
                                        if (val < 20) return TextEditingValue(text: '20');
                                        if (val > userBalance) {
                                          return TextEditingValue(text: '$userBalance');
                                        }
                                        return newValue;
                                      }),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                                  child: RaisedGradientButton(
                                    radius: 10.0,
                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                                    onPressed: () {
                                      var val = int.tryParse(sendInputController.text) ?? 0;
                                      if (val < userBalance) val += 10;
                                      if (val > userBalance) val = userBalance;
                                      sendInputController.text = '$val';
                                    },
                                    child: Text('+10',
                                        style: TextStyle(
                                            fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.w500)),
                                  ),
                                ),
                              ]),
                              const SizedBox(height: 16.0),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 48.0),
                          child: RaisedGradientButton(
                            onPressed: () {
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
                                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                Image.asset(Images.token),
                                                const SizedBox(width: 16.0),
                                                Text(
                                                  sendInputController.text,
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
                                                        balanceNotifier
                                                            .submit(
                                                                amount: int.tryParse(sendInputController.text) ?? 0,
                                                                type: selectedType.value)
                                                            .then((user) {
                                                          userNotifier.updateUser(user);
                                                          Navigator.of(context).pop(true);
                                                        }).catchError((error) {
                                                          balanceNotifier.resetState();
                                                          print(error);
                                                          Navigator.of(context).pop(true);
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return CustomAlertDialog(
                                                                content: CustomDialog(
                                                                  icon: Icons.close,
                                                                  color: Theme.of(context).errorColor,
                                                                  text: Utils.getErrorText(
                                                                      error?.body?.toString() ?? 'unkown_error'),
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
                                                        Navigator.of(context).pop(false);
                                                      }),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )).then(((v) {
                                        showDialog(context: context, builder: (context) {
                                          return CustomAlertDialog(content: Text('Бали успішно виведено'),);
                                        });
                                      }));
                            },
                            child: Text(
                              'ПЕРЕВЕСТИ БАЛИ',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
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
