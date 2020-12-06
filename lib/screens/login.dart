import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imes/widgets/base/loading_lock.dart';
import 'package:imes/widgets/dialogs.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:imes/resources/resources.dart';
import 'package:imes/screens/register.dart';

import 'package:imes/widgets/base/custom_dialog.dart';
import 'package:imes/widgets/base/custom_alert_dialog.dart';

import 'package:imes/widgets/base/custom_checkbox.dart';
import 'package:imes/widgets/base/raised_gradient_button.dart';

import 'package:imes/blocs/user_notifier.dart';

import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulHookWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formState = GlobalKey();

  final MaskTextInputFormatter _phoneFormatter =
      MaskTextInputFormatter(mask: '+38 (###) ### ## ##', filter: {'#': RegExp(r'[0-9]')});

  final FocusNode _loginFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final _loginController = useTextEditingController();
    final _passwordController = useTextEditingController();

    final userNotifier = useProvider(userNotifierProvider);
    final termsAndCondsState = useState(false);
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
                      textInputAction: TextInputAction.next,
                      inputFormatters: [_phoneFormatter],
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                    ),
                    TextFormField(
                      focusNode: _passwordFocusNode,
                      controller: _passwordController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(labelText: 'Пароль'),
                      validator: (value) {
                        if (value.trim().isEmpty || value.length < 4) {
                          return 'Пароль не може бути меньш ніж 4 символа';
                        } else {
                          return null;
                        }
                      },
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
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
                                  text: 'согласен с условиями ',
                                  style: TextStyle(
                                      fontSize: 11.0, color: Color(0xFF828282)), // TODO: extract colors to theme
                                  children: [
                                    TextSpan(
                                        text: 'Политики конфиденциальности',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            if (await canLaunch('https://pharmatracker.com.ua/policy')) {
                                              launch('https://pharmatracker.com.ua/policy');
                                            }
                                          }),
                                    TextSpan(text: ' и '),
                                    TextSpan(
                                        text: 'Правил пользования',
                                        style: TextStyle(fontWeight: FontWeight.bold, color: themeData.primaryColor),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            if (await canLaunch('https://pharmatracker.com.ua/rules')) {
                                              launch('https://pharmatracker.com.ua/rules');
                                            }
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
                            } else {
                              isLoading.value = true;
                              userNotifier
                                  .login(
                                _phoneFormatter.getUnmaskedText(),
                                _passwordController.text,
                              )
                                  .catchError((error) {
                                showErrorDialog(context, error);
                              }).whenComplete(() {
                                isLoading.value = false;
                              });
                            }
                          }
                        },
                      ),
                    ),
                    // Expanded(child: SizedBox()),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () => Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(builder: (context) => RegisterPage())),
                              child: Text('Зарегистрировать', style: TextStyle(color: Theme.of(context).accentColor))),
                          const SizedBox(width: 5),
                          Text('аккаунт')
                        ],
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
