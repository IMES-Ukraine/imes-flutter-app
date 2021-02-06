import 'package:chopper/chopper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:imes/blocs/login_notifier.dart';
import 'package:imes/blocs/user_notifier.dart';
import 'package:imes/helpers/utils.dart';
import 'package:imes/resources/resources.dart';
import 'package:imes/screens/register.dart';
import 'package:imes/utils/constants.dart';
import 'package:imes/widgets/base/custom_alert_dialog.dart';
import 'package:imes/widgets/base/custom_checkbox.dart';
import 'package:imes/widgets/base/custom_dialog.dart';
import 'package:imes/widgets/base/raised_gradient_button.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formState = GlobalKey();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final MaskTextInputFormatter _phoneFormatter = MaskTextInputFormatter(
      mask: '+38 (###) ### ## ##', filter: {'#': RegExp(r'[0-9]')});

  final FocusNode _loginFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Scaffold(
      body: ChangeNotifierProvider(
        create: (_) => LoginNotifier(),
        child: Consumer2<LoginNotifier, UserNotifier>(
            builder: (context, loginNotifier, userNotifier, _) {
          return SafeArea(
            child: Stack(
              children: <Widget>[
                Form(
                  key: _formState,
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.0.h),
                                child: Image.asset(Images.loginLogo),
                              ),
                              SizedBox(height: 4.0.h),
                              Text('Введіть номер',
                                  style: TextStyle(
                                      fontSize: 13.0.sp,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 4.0.h),
                              TextFormField(
                                focusNode: _loginFocusNode,
                                controller: _loginController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    hintText: '+38 (___) ___ __ __'),
                                textInputAction: TextInputAction.next,
                                inputFormatters: [_phoneFormatter],
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context)
                                      .requestFocus(_passwordFocusNode);
                                },
                              ),
                              TextFormField(
                                focusNode: _passwordFocusNode,
                                controller: _passwordController,
                                obscureText: true,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                decoration:
                                    InputDecoration(labelText: 'Пароль'),
                                validator: (value) {
                                  if (value.trim().isEmpty ||
                                      value.length < 4) {
                                    return 'Пароль не може бути меньш ніж 4 символа';
                                  } else {
                                    return null;
                                  }
                                },
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0.w),
                                child: Row(
                                  children: <Widget>[
                                    CustomCheckbox(
                                      value:
                                          loginNotifier.termsAndConditionsValue,
                                      onTap: () =>
                                          loginNotifier.changeTermsValue(),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2.0.h, horizontal: 2.0.w),
                                        child: RichText(
                                          text: TextSpan(
                                            text: 'согласен с условиями ',
                                            style: TextStyle(
                                                fontSize: 8.0.sp,
                                                color: Color(
                                                    0xFF828282)), // TODO: extract colors to theme
                                            children: [
                                              TextSpan(
                                                  text:
                                                      'Политики конфиденциальности',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () async {
                                                          if (await canLaunch(
                                                              Constants
                                                                  .POLICY_URL)) {
                                                            launch(Constants
                                                                .POLICY_URL);
                                                          }
                                                        }),
                                              TextSpan(text: ' и '),
                                              TextSpan(
                                                  text: 'Правил пользования',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: themeData
                                                          .primaryColor),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () async {
                                                          if (await canLaunch(
                                                              Constants
                                                                  .RULES_URL)) {
                                                            launch(Constants
                                                                .RULES_URL);
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
                                padding: EdgeInsets.symmetric(
                                    vertical: 2.0.h, horizontal: 8.0.w),
                                child: RaisedGradientButton(
                                  child: Text(
                                    'ПІДТВЕРДИТИ',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0.sp),
                                  ),
                                  onPressed: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    if (_formState.currentState.validate()) {
                                      if (!loginNotifier
                                          .termsAndConditionsValue) {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return CustomAlertDialog(
                                                content: CustomDialog(
                                                    icon: Icons.close,
                                                    color: Theme.of(context)
                                                        .errorColor,
                                                    text:
                                                        'Приймить умови користування'),
                                              );
                                            });
                                      } else {
                                        userNotifier
                                            .login(
                                          _phoneFormatter.getUnmaskedText(),
                                          _passwordController.text,
                                        )
                                            .catchError((error) {
                                          userNotifier.resetState();
                                          if (error is Response) {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return CustomAlertDialog(
                                                    content: CustomDialog(
                                                      icon: Icons.close,
                                                      color: Theme.of(context)
                                                          .errorColor,
                                                      text: Utils.getErrorText(
                                                          error?.body
                                                                  ?.toString() ??
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
                                                        color: Theme.of(context)
                                                            .errorColor,
                                                        text: error.toString()),
                                                  );
                                                });
                                          }
                                        });
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverFillRemaining(
                        hasScrollBody: false,
                        fillOverscroll: false,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                                                  child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.0.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkResponse(
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (  context) =>
                                                  RegisterPage()));
                                    },
                                    child: Text('Зареєструвати',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor))),
                                SizedBox(width: 1.0.w),
                                Text('аккаунт')
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                if (userNotifier.state == AuthState.AUTHENTICATING)
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
