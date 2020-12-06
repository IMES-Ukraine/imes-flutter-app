import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imes/widgets/dialogs.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:imes/resources/resources.dart';
import 'package:imes/screens/confirm_code.dart';
import 'package:imes/widgets/base/loading_lock.dart';

import 'package:imes/widgets/base/custom_dialog.dart';
import 'package:imes/widgets/base/custom_alert_dialog.dart';

import 'package:imes/widgets/base/custom_checkbox.dart';
import 'package:imes/widgets/base/raised_gradient_button.dart';

import 'package:imes/blocs/user_notifier.dart';

class RegisterPage extends StatefulHookWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formState = GlobalKey();
  final TextEditingController _loginController = TextEditingController();
  final FocusNode _loginFocusNode = FocusNode();
  final MaskTextInputFormatter _phoneFormatter =
      MaskTextInputFormatter(mask: '+38 (###) ### ## ##', filter: {'#': RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    final userNotifier = useProvider(userNotifierProvider);
    final termsAndCondsState = useState(false);
    final doctorState = useState(false);
    final isLoading = useState(false);
    final themeData = Theme.of(context);

    return Scaffold(
      body: SafeArea(
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
                    Text('Введіть номер', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      focusNode: _loginFocusNode,
                      controller: _loginController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(hintText: '+38 (___) ___ __ __'),
                      textInputAction: TextInputAction.done,
                      inputFormatters: [_phoneFormatter],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: <Widget>[
                          CustomCheckbox(
                            value: termsAndCondsState.value,
                            onTap: () => termsAndCondsState.value = !termsAndCondsState.value,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RichText(
                                text: TextSpan(
                                  text: 'Я згоден з ',
                                  style: TextStyle(
                                      fontSize: 11.0, color: Color(0xFF828282)), // TODO: extract colors to theme
                                  children: [
                                    TextSpan(
                                        text: 'Умовами',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            // if (await canLaunch('https://pharmatracker.com.ua/rules')) {
                                            //   launch('https://pharmatracker.com.ua/rules');
                                            // }
                                          }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          CustomCheckbox(
                            value: doctorState.value,
                            onTap: () => doctorState.value = !doctorState.value,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RichText(
                                text: TextSpan(
                                  text: 'Я підтверджую, що я лікар ',
                                  style: TextStyle(
                                      fontSize: 11.0, color: Color(0xFF828282)), // TODO: extract colors to theme
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 16.0),
                      child: RaisedGradientButton(
                        child: Text(
                          'ПІДТВЕРДИТИ',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (_formState.currentState.validate()) {
                            if (!termsAndCondsState.value) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CustomAlertDialog(
                                      content: CustomDialog(
                                          icon: Icons.close,
                                          color: Theme.of(context).errorColor,
                                          text: 'Приймить умови користування'),
                                    );
                                  });
                              return;
                            }
                            if (!doctorState.value) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CustomAlertDialog(
                                      content: CustomDialog(
                                          icon: Icons.close,
                                          color: Theme.of(context).errorColor,
                                          text: 'Підтвердіть, що Ви лікар'),
                                    );
                                  });
                              return;
                            }
                            isLoading.value = true;
                            userNotifier
                                .auth(_phoneFormatter.getUnmaskedText())
                                .then((_) => Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => ConfirmCodePage(
                                          phoneNumber: _phoneFormatter.getUnmaskedText(),
                                        ),
                                      ),
                                    ))
                                .catchError((error) {
                              showErrorDialog(context, error);
                              isLoading.value = false;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading.value) LoadingLock()
          ],
        ),
      ),
    );
  }
}
