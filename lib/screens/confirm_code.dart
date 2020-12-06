import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imes/blocs/user_notifier.dart';
import 'package:imes/hooks/test_timer_hook.dart';
import 'package:imes/resources/resources.dart';
import 'package:imes/screens/setup_password.dart';
import 'package:imes/widgets/base/loading_lock.dart';
import 'package:imes/widgets/base/raised_gradient_button.dart';
import 'package:imes/widgets/dialogs.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class ConfirmCodePage extends HookWidget {
  final String phoneNumber;

  ConfirmCodePage({Key key, @required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    final userNotifier = useProvider(userNotifierProvider);
    final timerState = useCountDownValueNotifier(context, const Duration(seconds: 30));
    useListenable(timerState);

    final isLoading = useState(false);

    return Scaffold(
      body: SafeArea(
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
                    maxLength: 6,
                    pinBoxWidth: 30,
                    pinBoxHeight: 64,
                    autofocus: true,
                    highlight: true,
                    highlightColor: Colors.black,
                    defaultBorderColor: Colors.transparent,
                    hasTextBorderColor: Colors.blue,
                    maskCharacter: '\u25CF',
                    wrapAlignment: WrapAlignment.spaceAround,
                    pinTextStyle: TextStyle(fontSize: 22.0),
                    pinBoxDecoration: ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
                    pinTextAnimatedSwitcherTransition: ProvidedPinBoxTextAnimation.scalingTransition,
                    pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
                    highlightAnimationBeginColor: Colors.black,
                    highlightAnimationEndColor: Colors.white12,
                    keyboardType: TextInputType.number,
                    onDone: (text) {
                      isLoading.value = true;
                      userNotifier
                          .verify(phoneNumber, text)
                          .then((_) => Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => SetupPasswordPage()),
                              ))
                          .catchError((error) {
                        showErrorDialog(context, error);
                      }).whenComplete(() {
                        isLoading.value = false;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'На номер ${phoneNumber} було відправлено SMS з кодом',
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
                            isLoading.value = true;
                            userNotifier.auth(phoneNumber).then((value) {
                              timerState.value = const Duration(seconds: 30);
                            }).catchError((error) {
                              showErrorDialog(context, error);
                            }).whenComplete(() {
                              isLoading.value = false;
                            });
                          },
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Відправити повторно ${timerState.value.inSeconds} с',
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          if (isLoading.value) LoadingLock(),
        ],
      )),
    );
  }
}
