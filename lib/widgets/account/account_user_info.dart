import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imes/blocs/user_notifier.dart';
import 'package:imes/widgets/base/octo_circle_avatar.dart';

import 'accout_widget_options_mixin.dart';

class AccountUserInfo extends HookWidget with AccountWidgetOptions {
  final VoidCallback onAvatarTap;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController postController;

  AccountUserInfo({
    Key key,
    @required this.onAvatarTap,
    @required this.nameController,
    @required this.phoneController,
    @required this.postController,
  });

  @override
  Widget build(BuildContext context) {
    final userNotifier = useProvider(userNotifierProvider);
    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Row(children: [
          InkResponse(
            onTap: onAvatarTap,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: OctoCircleAvatar(url: userNotifier.user?.basicInformation?.avatar?.path ?? ''),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              TextField(controller: nameController, decoration: inputDecoration('Ім\’я Прізвище'), style: textStyle),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(Icons.phone, color: Theme.of(context).primaryColor, size: 16.0),
                  const SizedBox(width: 4.0),
                  Expanded(
                    child: TextField(
                        controller: phoneController, decoration: inputDecoration('Телефон'), style: textStyleBold),
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              Row(
                children: [
                  Icon(Icons.mail_outline, color: Theme.of(context).primaryColor, size: 16.0),
                  const SizedBox(width: 4.0),
                  Expanded(
                    child: TextField(
                        controller: postController, decoration: inputDecoration('Пошта'), style: textStyleBold),
                  ),
                ],
              ),
            ]),
          )),
        ]));
  }
}
