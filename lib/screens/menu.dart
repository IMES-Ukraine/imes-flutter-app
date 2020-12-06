import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imes/helpers/custom_icons_icons.dart';
import 'package:imes/screens/rules.dart';
import 'package:imes/screens/settings.dart';

import 'package:imes/widgets/menu/menu_item.dart';
import 'package:imes/widgets/menu/menu_app_bar.dart';

import 'package:imes/screens/support.dart';

import 'package:imes/blocs/user_notifier.dart';

class MenuPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final userNotifier = useProvider(userNotifierProvider);
    return Scaffold(
      appBar: MenuAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 3,
          children: <Widget>[
            MenuItem(
              icon: Icon(CustomIcons.settings, size: 40.0, color: Theme.of(context).primaryColor),
              text: 'Налаштування',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SettingsPage()),
              ),
            ),
            MenuItem(
              icon: Icon(CustomIcons.information, size: 40.0, color: Theme.of(context).primaryColor),
              text: 'Інструкція',
              onTap: () {},
            ),
            MenuItem(
              icon: Icon(CustomIcons.rules, size: 40.0, color: Theme.of(context).primaryColor),
              text: 'Правила користування',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => RulesPage()),
              ),
            ),
            MenuItem(
              icon: Icon(CustomIcons.support, size: 40.0, color: Theme.of(context).primaryColor),
              text: 'Підтримка',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SupportPage()),
              ),
            ),
            MenuItem(
              icon: Icon(Icons.exit_to_app, size: 40.0, color: Theme.of(context).primaryColor),
              text: 'Вийти',
              onTap: () => userNotifier.logout(),
            ),
          ],
        ),
      ),
    );
  }
}
