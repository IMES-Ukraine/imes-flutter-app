import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:imes/blocs/user_notifier.dart';
import 'package:imes/helpers/utils.dart';
import 'package:imes/hooks/test_timer_hook.dart';
import 'package:imes/resources/resources.dart';
import 'package:imes/screens/setup_password.dart';
import 'package:imes/widgets/base/custom_alert_dialog.dart';
import 'package:imes/widgets/base/custom_dialog.dart';
import 'package:imes/widgets/base/loading_lock.dart';
import 'package:imes/widgets/base/raised_gradient_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class ConfirmCodePage extends StatefulHookWidget {
  final String phoneNumber;

  ConfirmCodePage({Key key, @required this.phoneNumber});

  @override
  _ConfirmCodePageState createState() => _ConfirmCodePageState();
}

class _ConfirmCodePageState extends State<ConfirmCodePage> {
  @override
  Widget build(BuildContext context) {
    final timerState = useCountDownValueNotifier(context, const Duration(seconds: 30));
    useListenable(timerState);

    return Scaffold(
      body: Consumer<UserNotifier>(
        builder: (context, userNotifier, _) {
          return SafeArea(
              child: Stack(
            children: [
              Form(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Image.asset(Images.loginLogo),
                      ),
                      const SizedBox(height: 16.0),
                      Text('Код з СМС', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16.0),
                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {},
                        onCompleted: (value) {
                          userNotifier.verify(widget.phoneNumber, value).then((_) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => SetupPasswordPage(),
                              ),
                            );
                          }).catchError((error) {
                            userNotifier.resetState();
                            if (error is Response) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CustomAlertDialog(
                                      content: CustomDialog(
                                        icon: Icons.close,
                                        color: Theme.of(context).errorColor,
                                        text: Utils.getErrorText(error?.body?.toString() ?? 'unkown_error'),
                                      ),
                                    );
                                  });
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CustomAlertDialog(
                                      content: CustomDialog(
                                          icon: Icons.close,
                                          color: Theme.of(context).errorColor,
                                          text: error.toString()),
                                    );
                                  });
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'На номер ${widget.phoneNumber} було відправлено SMS з кодом',
                        style: TextStyle(fontSize: 12.0, color: Color(0xFF828282)), // TODO: extract colors to theme
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16.0),
                      RaisedGradientButton(
                        child: Text(
                          'ВІДПРАВИТИ',
                          style: TextStyle(
                              color: timerState.value.inSeconds > 0 ? Colors.grey[300] : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                        onPressed: timerState.value.inSeconds > 0
                            ? null
                            : () {
                                userNotifier.auth(widget.phoneNumber).then((value) {
                                  timerState.value = const Duration(seconds: 30);
                                }).catchError((error) {
                                  userNotifier.resetState();
                                  if (error is Response) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CustomAlertDialog(
                                            content: CustomDialog(
                                              icon: Icons.close,
                                              color: Theme.of(context).errorColor,
                                              text: Utils.getErrorText(error?.body?.toString() ?? 'unkown_error'),
                                            ),
                                          );
                                        });
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CustomAlertDialog(
                                            content: CustomDialog(
                                                icon: Icons.close,
                                                color: Theme.of(context).errorColor,
                                                text: error.toString()),
                                          );
                                        });
                                  }
                                });
                              },
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Відправити повторно ${timerState.value.inSeconds} с',
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              if (userNotifier.state == AuthState.VERIFYING) LoadingLock(),
            ],
          ));
        },
      ),
    );
  }
}
