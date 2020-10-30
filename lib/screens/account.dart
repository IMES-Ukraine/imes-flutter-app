import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:imes/blocs/user_notifier.dart';
import 'package:imes/screens/account_edit.dart';
import 'package:imes/widgets/base/octo_circle_avatar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:imes/extensions/color.dart';

import 'package:permission_handler/permission_handler.dart';

class AccountPage extends StatelessWidget {
  static final days = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'НД'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('АКАУНТ', style: TextStyle(fontWeight: FontWeight.w800)),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountEditPage()));
              },
            ),
          ],
        ),
        body: Consumer<UserNotifier>(builder: (context, userNotifier, _) {
          return SingleChildScrollView(
              child: Column(children: [
            const SizedBox(height: 16.0),
            Card(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: OctoCircleAvatar(
                      url: userNotifier.user?.basicInformation?.avatar?.path ?? '',
                    ),
                  ),
                  Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      userNotifier.user?.basicInformation?.name ?? 'Ім\'я Прізвище',
                      style: TextStyle(
                        color: Theme.of(context).dividerColor.darken(20),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(Icons.phone, color: Theme.of(context).primaryColor, size: 16.0),
                        const SizedBox(width: 4.0),
                        Text(
                          userNotifier.user?.basicInformation?.phone ?? 'Телефон',
                          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        Icon(Icons.mail_outline, color: Theme.of(context).primaryColor, size: 16.0),
                        const SizedBox(width: 4.0),
                        Text(
                          userNotifier.user?.basicInformation?.email ?? 'Пошта',
                          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ])),
                ])),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: ExpansionTile(
                title: Text('Спеціалізована інформація'.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                initiallyExpanded: true,
                childrenPadding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(),
                  Text('Спеціалізація', style: TextStyle(fontSize: 12.0, color: Color(0xFFA1A1A1))),
                  const SizedBox(height: 8.0),
                  Text(userNotifier.user?.specializedInformation?.specification ?? '',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Divider(),
                  Text('Рівень кваліфікації', style: TextStyle(fontSize: 12.0, color: Color(0xFFA1A1A1))),
                  const SizedBox(height: 8.0),
                  Text(userNotifier.user?.specializedInformation?.qualification ?? '',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Divider(),
                  Text('Місце роботи', style: TextStyle(fontSize: 12.0, color: Color(0xFFA1A1A1))),
                  const SizedBox(height: 8.0),
                  Text(userNotifier.user?.specializedInformation?.workplace ?? '',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Divider(),
                  Text('Графік роботи', style: TextStyle(fontSize: 12.0, color: Color(0xFFA1A1A1))),
                  const SizedBox(height: 8.0),
                  Column(
                    children: List.generate(3, (index) {
                          final s = userNotifier.user?.specializedInformation?.schedule?.elementAt(index);
                          return Row(
                            children: [
                              for (var i = 0; i < days.length; i++)
                                Row(
                                  children: [
                                    Text('${days[i]}${i != days.length - 1 ? ', ' : ':'}',
                                        style: TextStyle(
                                            color: s?.days?.contains(i) ?? false ? Colors.black : Color(0xFFBDBDBD))),
                                  ],
                                ),
                              Expanded(
                                child: Text(s?.time ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          );
                        })?.toList() ??
                        [],
                  ),
                  Divider(),
                  Text('Посада', style: TextStyle(fontSize: 12.0, color: Color(0xFFA1A1A1))),
                  const SizedBox(height: 8.0),
                  Text(userNotifier.user?.specializedInformation?.position ?? '',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Divider(),
                  Text('Номер ліцензії лікаря', style: TextStyle(fontSize: 12.0, color: Color(0xFFA1A1A1))),
                  const SizedBox(height: 8.0),
                  Text(userNotifier.user?.specializedInformation?.licenseNumber ?? '',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Divider(),
                  Text('Документ про освіту', style: TextStyle(fontSize: 12.0, color: Color(0xFFA1A1A1))),
                  const SizedBox(height: 8.0),
                  InkWell(
                    onTap: () async {
                      var status = await Permission.storage.request();
                      var dir = Platform.isAndroid
                          ? await getExternalStorageDirectory()
                          : await getApplicationDocumentsDirectory();
                      var exists = await dir.exists();
                      if (!exists) {
                        dir.create();
                      }

                      final taskId = await FlutterDownloader.enqueue(
                        url: userNotifier.user.specializedInformation.educationDocument.path,
                        savedDir: dir.path,
                        showNotification: true,
                        openFileFromNotification: true,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(userNotifier.user?.specializedInformation?.educationDocument != null ? 'Показать' : '',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                        Text(userNotifier.user?.specializedInformation?.educationDocument?.fileName ?? '',
                            style: TextStyle(color: Theme.of(context).primaryColor)),
                      ],
                    ),
                  ),
                  Divider(),
                  Text('Дата (період) навчання', style: TextStyle(fontSize: 12.0, color: Color(0xFFA1A1A1))),
                  const SizedBox(height: 8.0),
                  Text(userNotifier.user?.specializedInformation?.studyPeriod ?? '',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Divider(),
                  Text('Додаткова кваліфікація', style: TextStyle(fontSize: 12.0, color: Color(0xFFA1A1A1))),
                  const SizedBox(height: 8.0),
                  Text(userNotifier.user?.specializedInformation?.additionalQualification ?? '',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
            Card(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: ExpansionTile(
                  title: Text('Фінансова інформація'.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  initiallyExpanded: true,
                  childrenPadding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(),
                    Text('Номер картки', style: TextStyle(fontSize: 12.0, color: Color(0xFFA1A1A1))),
                    const SizedBox(height: 8.0),
                    Text(userNotifier.user?.financialInformation?.card ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16.0),
                  ],
                )),
          ]));
        }));
  }

  // Future<Directory> _getDownloadDirectory() async {
  //   if (Platform.isAndroid) {
  //     return await DownloadsPathProvider.downloadsDirectory;
  //   }

  //   // in this example we are using only Android and iOS so I can assume
  //   // that you are not trying it for other platforms and the if statement
  //   // for iOS is unnecessary

  //   // iOS directory visible to user
  //   return await getApplicationDocumentsDirectory();
  // }
}
