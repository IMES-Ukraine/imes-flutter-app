import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:pharmatracker/blocs/confirm_code_notifier.dart';
import 'package:pharmatracker/blocs/user_notifier.dart';
import 'package:pharmatracker/helpers/utils.dart';
import 'package:pharmatracker/screens/home.dart';
import 'package:pharmatracker/widgets/custom_alert_dialog.dart';
import 'package:pharmatracker/widgets/custom_dialog.dart';
import 'package:pharmatracker/widgets/loading_lock.dart';
import 'package:pharmatracker/widgets/raised_gradient_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class ConfirmCodePage extends StatefulWidget {
  final String phoneNumber;

  ConfirmCodePage({Key key, @required this.phoneNumber});

  @override
  _ConfirmCodePageState createState() => _ConfirmCodePageState();
}

class _ConfirmCodePageState extends State<ConfirmCodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => ConfirmCodeNotifier()..startIsolatedTimer(),
        child: Consumer2<ConfirmCodeNotifier, UserNotifier>(
          builder: (context, confirmCodeNotifier, userNotifier, _) {
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
                          child: Image.asset('assets/login_logo.png'),
                        ),
                        const SizedBox(height: 16.0),
                        Text('Код з СМС', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16.0),
                        PinCodeTextField(
                          appContext: context,
                          length: 6,
                          onChanged: (value) {},
                          onCompleted: (value) {
                            userNotifier
                                .verify(widget.phoneNumber, value)
                                .then((_) => () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(builder: (context) => HomePage()),
                                      );
                                    })
                                .catchError((error) {
                              userNotifier.resetState();
                              if (error is Response) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomAlertDialog(
                                        content: CustomDialog(
                                          icon: Icons.close,
                                          color: Color(0xFFFF5B5E),
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
                                            icon: Icons.close, color: Color(0xFFFF5B5E), text: error.toString()),
                                      );
                                    });
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'На номер ${widget.phoneNumber} було відправлено SMS з кодом',
                          style: TextStyle(fontSize: 12.0, color: Color(0xFF828282)),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16.0),
                        RaisedGradientButton(
                          child: Text(
                            'ВІДПРАВИТИ',
                            style: TextStyle(
                                color: confirmCodeNotifier.sendAgainCounter > 0 ? Colors.grey[300] : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                          onPressed: confirmCodeNotifier.sendAgainCounter > 0
                              ? null
                              : () {
                                  userNotifier
                                      .auth(widget.phoneNumber)
                                      .then((value) => confirmCodeNotifier.startIsolatedTimer())
                                      .catchError((error) {
                                    userNotifier.resetState();
                                    if (error is Response) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return CustomAlertDialog(
                                              content: CustomDialog(
                                                icon: Icons.close,
                                                color: Color(0xFFFF5B5E),
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
                                                  icon: Icons.close, color: Color(0xFFFF5B5E), text: error.toString()),
                                            );
                                          });
                                    }
                                  });
                                },
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'Відправити повторно ${confirmCodeNotifier.sendAgainCounter} с',
                          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: Color(0xFF00B7FF)),
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
      ),
    );
  }
}
