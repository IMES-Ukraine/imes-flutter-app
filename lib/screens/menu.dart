import 'package:flutter/material.dart';
import 'package:imes/resources/resources.dart';

import 'package:imes/widgets/menu_item.dart';
import 'package:imes/widgets/menu_app_bar.dart';

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
                icon: Image.asset(
                  Images.headphones,
                  color: Colors.white,
                ),
                text: 'Підтримка',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SupportPage()),
                  );
                },
              ),
              MenuItem(
                icon: Image.asset(
                  Images.info,
                  color: Colors.white,
                ),
                text: 'Інструкція',
                onTap: () async {
                  if (await canLaunch('https://pharmatracker.com.ua/PharmaTracker.pdf')) {
                    launch('https://pharmatracker.com.ua/PharmaTracker.pdf');
                  }
                },
              ),
              MenuItem(
                icon: Image.asset(
                  Images.rules,
                  color: Colors.white,
                ),
                text: 'Правила користування',
                onTap: () async {
                  if (await canLaunch('https://pharmatracker.com.ua/rules')) {
                    launch('https://pharmatracker.com.ua/rules');
                  }
                },
              ),
              MenuItem(
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                  size: 25,
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
