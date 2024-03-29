import 'dart:io';

import 'package:flutter/material.dart';

import 'package:imes/blocs/reports_notifier.dart';
import 'package:imes/resources/resources.dart';

import 'package:imes/widgets/base/custom_dialog.dart';
import 'package:imes/widgets/base/custom_alert_dialog.dart';

import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

class ReportsPage extends StatelessWidget {
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (_) {
          final reportsNotifier = ReportsNotifier();
          return reportsNotifier;
        },
        child: Consumer<ReportsNotifier>(builder: (context, reportsNotifier, _) {
          return SafeArea(
            child: Stack(
              children: <Widget>[
                if (reportsNotifier.state == ReportsState.NOT_ADDED)
                  Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Image.asset(Images.camera),
                              Text(
                                'Додати чек',
                                style: TextStyle(
                                  color: Color(0xFF828282), // TODO: extract colors to theme
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextButton.icon(
                            onPressed: () async {
                              final image = await picker.getImage(source: ImageSource.gallery);
                              if (image != null) {
                                reportsNotifier.chooseImage(File(image.path));
                              }
                            },
                            icon: Icon(Icons.photo, color: Color(0xFF828282)), // TODO: extract colors to theme
                            label: Text(
                              'Бібліотека',
                              style: TextStyle(
                                color: Color(0xFF828282), // TODO: extract colors to theme
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              final image = await picker.getImage(source: ImageSource.camera);
                              if (image != null) {
                                reportsNotifier.chooseImage(File(image.path));
                              }
                            },
                            icon: Icon(Icons.photo_camera, color: Color(0xFF828282)), // TODO: extract colors to theme
                            label: Text(
                              'Зробити фото',
                              style: TextStyle(
                                color: Color(0xFF828282), // TODO: extract colors to theme
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                if (reportsNotifier.state == ReportsState.ADDED || reportsNotifier.state == ReportsState.UPLOADING)
                  Column(
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.file(reportsNotifier.image),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(Images.weightIcon),
                                  ),
                                  Expanded(child: Text('Вибрати дозування')),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: DropdownButton(
                                      value: reportsNotifier.amount,
                                      underline: const SizedBox(),
                                      items: [
                                        DropdownMenuItem(
                                          value: 25,
                                          child: Text('25 гр'),
                                        ),
                                        DropdownMenuItem(
                                          value: 40,
                                          child: Text('40 гр'),
                                        ),
                                        DropdownMenuItem(
                                          value: 50,
                                          child: Text('50 гр'),
                                        ),
                                        DropdownMenuItem(
                                          value: 90,
                                          child: Text('90 гр'),
                                        ),
                                      ],
                                      onChanged: reportsNotifier.chooseAmount,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(Images.clock),
                                ),
                                Expanded(child: Text('Час')),
                                TextButton(
                                  onPressed: () async {
                                    final timeOfDay =
                                        await showTimePicker(context: context, initialTime: TimeOfDay.now());
                                    if (timeOfDay != null) {
                                      reportsNotifier.chooseTime(timeOfDay);
                                    }
                                  },
                                  child: Text(reportsNotifier.timeOfDay.format(context)),
                                ),
                              ],
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(Images.bottle),
                                  ),
                                  Expanded(child: Text('Кількість')),
                                  Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.arrow_left),
                                        onPressed: () => reportsNotifier.decrementCount(),
                                      ),
                                      Container(
                                          decoration:
                                              BoxDecoration(border: Border.all(color: Theme.of(context).dividerColor)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('${reportsNotifier.count}'),
                                          )),
//                                    ConstrainedBox(
//                                        constraints: BoxConstraints(maxWidth: 52.0, maxHeight: 32.0),
//                                        child: TextField(
//                                          scrollPadding: const EdgeInsets.all(0.0),
//                                          maxLines: 1,
//                                          maxLength: 3,
//                                          decoration: InputDecoration(
//                                            counterText: '',
//                                            border: OutlineInputBorder(gapPadding: 0.0),
//                                          ),
//                                        )),
                                      IconButton(
                                        icon: Icon(Icons.arrow_right),
                                        onPressed: () => reportsNotifier.incrementCount(),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        )),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Theme.of(context).accentColor),
                              textStyle: TextStyle(color: Theme.of(context).accentColor),
                            ),
                            onPressed: () {
                              reportsNotifier.uploadImage().then((_) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomAlertDialog(
                                        content: CustomDialog(
                                          icon: Icons.check,
                                          text: 'Ваш звіт додано в аналітику',
                                          color: Theme.of(context).accentColor,
                                        ),
                                      );
                                    }).then((_) => reportsNotifier.resetState());
                              }).catchError((error) {
                                reportsNotifier.resetState();
                                print(error);
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomAlertDialog(
                                        content: CustomDialog(
                                          icon: Icons.close,
                                          text: 'Виникла помилка. Повторіть будь ласка',
                                          color: Theme.of(context).errorColor,
                                        ),
                                      );
                                    });
                              });
                            },
                            child: Text(
                              'Додати',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                if (reportsNotifier.state == ReportsState.UPLOADING)
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
                        child: CircularProgressIndicator(
                          value: reportsNotifier.progress,
                        ),
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
