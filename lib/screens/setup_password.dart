import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:imes/blocs/user_notifier.dart';
import 'package:imes/helpers/utils.dart';
import 'package:imes/resources/resources.dart';
import 'package:imes/screens/home.dart';
import 'package:imes/widgets/base/custom_alert_dialog.dart';
import 'package:imes/widgets/base/custom_dialog.dart';
import 'package:imes/widgets/base/raised_gradient_button.dart';
import 'package:provider/provider.dart';

class SetupPasswordPage extends StatefulHookWidget {
  @override
  _SetupPasswordPageState createState() => _SetupPasswordPageState();
}

class _SetupPasswordPageState extends State<SetupPasswordPage> {
  final GlobalKey<FormState> _formState = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();

    return Scaffold(body: Consumer<UserNotifier>(builder: (context, userNotifier, _) {
      return SafeArea(
          child: Stack(
        children: [
          Form(
              key: _formState,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Image.asset(Images.loginLogo),
                    ),
                    const SizedBox(height: 16.0),
                    Text('Створити пароль', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                    TextFormField(
                      // focusNode: _passwordFocusNode,
                      controller: passwordController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: 'Пароль'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Пароль не може бути меньш ніж 4 символа';
                        } else {
                          return null;
                        }
                      },
                      // onFieldSubmitted: (value) {
                      //   FocusScope.of(context).requestFocus(FocusNode());
                      // },
                    ),
                    TextFormField(
                      // focusNode: _passwordFocusNode,
                      controller: confirmPasswordController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(labelText: 'Повторити пароль'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Пароль не може бути меньш ніж 4 символа';
                        } else if (value != passwordController.text) {
                          return 'Не співпадає з паролем';
                        } else {
                          return null;
                        }
                      },
                      // onFieldSubmitted: (value) {
                      //   FocusScope.of(context).requestFocus(FocusNode());
                      // },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 16.0),
                      child: RaisedGradientButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (_formState.currentState.validate()) {
                            userNotifier.setupPwd(passwordController.text).then((value) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => HomePage()),
                              );
                            }).catchError((error) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CustomAlertDialog(
                                      content: CustomDialog(
                                        icon: Icons.close,
                                        color: Theme.of(context).errorColor,
                                        text: Utils.getErrorText(error?.body ?? 'unkown_error'),
                                      ),
                                    );
                                  });
                            });
                          }
                        },
                        child: Text(
                          'Далі',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ));
    }));
  }
}
