import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:imes/blocs/user_notifier.dart';
import 'package:imes/helpers/utils.dart';
import 'package:imes/resources/resources.dart';
import 'package:imes/screens/confirm_code.dart';
import 'package:imes/widgets/base/custom_alert_dialog.dart';
import 'package:imes/widgets/base/custom_dialog.dart';
import 'package:imes/widgets/base/loading_lock.dart';
import 'package:imes/widgets/base/raised_gradient_button.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formState = GlobalKey();
  final TextEditingController _loginController = TextEditingController();
  final FocusNode _loginFocusNode = FocusNode();
  final MaskTextInputFormatter _phoneFormatter = MaskTextInputFormatter(
      mask: '+38 (###) ### ## ##', filter: {'#': RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Scaffold(
      body: Consumer<UserNotifier>(builder: (context, userNotifier, _) {
        return SafeArea(
          child: Stack(
            children: <Widget>[
              Form(
                key: _formState,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Image.asset(Images.loginLogo),
                      ),
                      const SizedBox(height: 16.0),
                      Text('Введіть номер',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        focusNode: _loginFocusNode,
                        controller: _loginController,
                        keyboardType: TextInputType.phone,
                        decoration:
                            InputDecoration(hintText: '+38 (___) ___ __ __'),
                        textInputAction: TextInputAction.done,
                        inputFormatters: [_phoneFormatter],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 36.0, horizontal: 16.0),
                        child: RaisedGradientButton(
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (_formState.currentState.validate()) {
                              userNotifier
                                  .auth(_phoneFormatter
                                      .getMaskedText()
                                      .replaceAll(RegExp(r'[^0-9]'), ''))
                                  .then((value) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => ConfirmCodePage(
                                      phoneNumber: _phoneFormatter
                                          .getMaskedText()
                                          .replaceAll(RegExp(r'[^0-9]'), ''),
                                    ),
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
                                            text: Utils.getErrorText(
                                                error?.body?.toString() ??
                                                    'unkown_error'),
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
                                              color:
                                                  Theme.of(context).errorColor,
                                              text: error.toString()),
                                        );
                                      });
                                }
                              });
                            }
                          },
                          child: Text(
                            'ДАЛІ',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (userNotifier.state == AuthState.AUTHENTICATING) LoadingLock()
            ],
          ),
        );
      }),
    );
  }
}
