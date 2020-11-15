import 'package:flutter/material.dart';
import 'package:imes/helpers/custom_icons_icons.dart';
import 'package:imes/screens/rules.dart';
import 'package:imes/screens/settings.dart';

import 'package:imes/widgets/menu/menu_item.dart';
import 'package:imes/widgets/menu/menu_app_bar.dart';

import 'package:imes/screens/support.dart';

import 'package:imes/blocs/user_notifier.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:provider/provider.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MenuAppBar(),
      body: Consumer<UserNotifier>(builder: (context, userNotifier, _) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 3,
            children: <Widget>[
              MenuItem(
                icon: Icon(
                  CustomIcons.settings,
                  size: 40.0,
                  color: Theme.of(context).primaryColor,
                ),
                text: 'Налаштування',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
              ),
              MenuItem(
                icon: Icon(
                  CustomIcons.information,
                  size: 40.0,
                  color: Theme.of(context).primaryColor,
                ),
                text: 'Інструкція',
                onTap: () async {
                  // if (await canLaunch('https://pharmatracker.com.ua/PharmaTracker.pdf')) {
                  //   launch('https://pharmatracker.com.ua/PharmaTracker.pdf');
                  // }
                },
              ),
              MenuItem(
                icon: Icon(
                  CustomIcons.rules,
                  size: 40.0,
                  color: Theme.of(context).primaryColor,
                ),
                text: 'Правила користування',
                onTap: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RulesPage()),
                  );
                },
              ),
              MenuItem(
                icon: Icon(
                  CustomIcons.support,
                  size: 40.0,
                  color: Theme.of(context).primaryColor,
                ),
                text: 'Підтримка',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SupportPage()),
                  );
                },
              ),
              MenuItem(
                icon: Icon(
                  Icons.exit_to_app,
                  size: 40.0,
                  color: Theme.of(context).primaryColor,
                ),
                text: 'Вийти',
                onTap: () {
                  userNotifier.logout();
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
