import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:imes/blocs/user_notifier.dart';
import 'package:imes/helpers/custom_icons_icons.dart';
import 'package:imes/helpers/utils.dart';
import 'package:imes/hooks/settings.dart';
import 'package:provider/provider.dart';
import 'package:imes/widgets/base/custom_alert_dialog.dart';
import 'package:imes/widgets/base/custom_dialog.dart';
import 'package:imes/widgets/base/raised_gradient_button.dart';

class SettingsPage extends StatefulHookWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<FormState> _formState = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final notificationsAllController = useLocalStorageBool('all', defaultValue: true);
    final notificationsNewsController = useLocalStorageBool('news', defaultValue: true);
    final notificationsTestsController = useLocalStorageBool('tests', defaultValue: true);
    final notificationsBalanceController = useLocalStorageBool('balance', defaultValue: true);
    final notificationsMessagesController = useLocalStorageBool('messages', defaultValue: true);

    return Scaffold(
      appBar: AppBar(title: Text('НАЛАШТУВАННЯ', style: TextStyle(fontWeight: FontWeight.w800))),
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 16.0),
          /*Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Мова', style: TextStyle(fontWeight: FontWeight.bold)),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                            color: Theme.of(context).accentColor,
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('UA', style: TextStyle(fontWeight: FontWeight.bold)),
                      )),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Відгук', style: TextStyle(fontWeight: FontWeight.bold)),
                  CustomFlatButton(
                    text: 'ЗАЛИШИТИ ВІДГУК',
                    color: Theme.of(context).accentColor,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),*/
          HookBuilder(builder: (context) {
            final state = useState<bool>(false);
            final notificationsAll = useStream(notificationsAllController.stream);
            final notificationsNews = useStream(notificationsNewsController.stream);
            final notificationsTests = useStream(notificationsTestsController.stream);
            final notificationsBalance = useStream(notificationsBalanceController.stream);
            final notificationsMessages = useStream(notificationsMessagesController.stream);

            // useEffect(() {
            //   final sub = notificationsAllController.stream.listen((event) {
            //     notificationsNewsController.add(event);
            //     notificationsTestsController.add(event);
            //     notificationsBalanceController.add(event);
            //     notificationsMessagesController.add(event);
            //   });
            //   return sub.cancel;
            // }, const []);

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: ExpansionTile(
                trailing: AnimatedSwitcher(
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    state.value ? CustomIcons.minus : CustomIcons.plus,
                    size: 14.0,
                    key: ValueKey<bool>(state.value),
                  ),
                ),
                onExpansionChanged: (value) {
                  state.value = value;
                },
                title: Text('Сповіщення',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                childrenPadding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Всі'),
                    Switch(value: notificationsAll?.data ?? false, onChanged: (v) => notificationsAllController.add(v)),
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Новини'),
                    Switch(
                        value: notificationsNews?.data ?? false, onChanged: (v) => notificationsNewsController.add(v)),
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Тести'),
                    Switch(
                        value: notificationsTests?.data ?? false,
                        onChanged: (v) => notificationsTestsController.add(v)),
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Бали'),
                    Switch(
                        value: notificationsBalance?.data ?? false,
                        onChanged: (v) => notificationsBalanceController.add(v)),
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Повідомлення'),
                    Switch(
                        value: notificationsMessages?.data ?? false,
                        onChanged: (v) => notificationsMessagesController.add(v)),
                  ]),
                ],
              ),
            );
          }),
          HookBuilder(builder: (context) {
            final state = useState<bool>(false);

            final oldPasswordController = useTextEditingController();
            final newPasswordController = useTextEditingController();
            final confirmPasswordController = useTextEditingController();

            final oldPasswordFocusNode = useFocusNode();
            final newPasswordFocusNode = useFocusNode();
            final confirmPasswordFocusNode = useFocusNode();
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Form(
                key: _formState,
                child: ExpansionTile(
                  trailing: AnimatedSwitcher(
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      state.value ? CustomIcons.minus : CustomIcons.plus,
                      size: 14.0,
                      key: ValueKey<bool>(state.value),
                    ),
                  ),
                  onExpansionChanged: (value) {
                    state.value = value;
                  },
                  title: Text('Зміна пароля',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  childrenPadding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                  children: [
                    TextFormField(
                      focusNode: oldPasswordFocusNode,
                      controller: oldPasswordController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: 'Старий пароль'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Пароль не може бути меньш ніж 4 символа';
                        } else {
                          return null;
                        }
                      },
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(newPasswordFocusNode);
                      },
                    ),
                    TextFormField(
                      focusNode: newPasswordFocusNode,
                      controller: newPasswordController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: 'Новий пароль'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Пароль не може бути меньш ніж 4 символа';
                        } else {
                          return null;
                        }
                      },
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(confirmPasswordFocusNode);
                      },
                    ),
                    TextFormField(
                      focusNode: confirmPasswordFocusNode,
                      controller: confirmPasswordController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(labelText: 'Підтвердити пароль'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Пароль не може бути меньш ніж 4 символа';
                        } else if (value != newPasswordController.text) {
                          return 'Не співпадає з паролем';
                        } else {
                          return null;
                        }
                      },
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 16.0),
                      child: RaisedGradientButton(
                        onPressed: () {
                          final userNotifier = context.read<UserNotifier>();
                          FocusScope.of(context).unfocus();
                          if (_formState.currentState.validate()) {
                            userNotifier.setupPwd(newPasswordController.text).then((value) {}).catchError((error) {
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
                            });
                          }
                        },
                        child: Text(
                          'ЗБЕРЕГТИ',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ]),
      ),
    );
  }
}
