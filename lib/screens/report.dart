import 'package:flutter/material.dart';

import 'package:imes/blocs/reports_notifier.dart';
import 'package:imes/resources/resources.dart';

import 'package:imes/widgets/custom_dialog.dart';
import 'package:imes/widgets/custom_alert_dialog.dart';

import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

class ReportsPage extends StatelessWidget {
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
                                  color: Color(0xFF828282),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton.icon(
                            onPressed: () async {
                              final image = await ImagePicker.pickImage(source: ImageSource.gallery);
                              if (image != null) {
                                reportsNotifier.chooseImage(image);
                              }
                            },
                            icon: Icon(Icons.photo, color: Color(0xFF828282)),
                            label: Text(
                              'Бібліотека',
                              style: TextStyle(
                                color: Color(0xFF828282),
                              ),
                            ),
                          ),
                          FlatButton.icon(
                            onPressed: () async {
                              final image = await ImagePicker.pickImage(source: ImageSource.camera);
                              if (image != null) {
                                reportsNotifier.chooseImage(image);
                              }
                            },
                            icon: Icon(Icons.photo_camera, color: Color(0xFF828282)),
                            label: Text(
                              'Зробити фото',
                              style: TextStyle(
                                color: Color(0xFF828282),
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
                                          child: Text('25 гр'),
                                          value: 25,
                                        ),
                                        DropdownMenuItem(
                                          child: Text('40 гр'),
                                          value: 40,
                                        ),
                                        DropdownMenuItem(
                                          child: Text('50 гр'),
                                          value: 50,
                                        ),
                                        DropdownMenuItem(
                                          child: Text('90 гр'),
                                          value: 90,
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
                                FlatButton(
                                  child: Text(reportsNotifier.timeOfDay.format(context)),
                                  onPressed: () async {
                                    final timeOfDay =
                                        await showTimePicker(context: context, initialTime: TimeOfDay.now());
                                    if (timeOfDay != null) {
                                      reportsNotifier.chooseTime(timeOfDay);
                                    }
                                  },
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
                                          decoration: BoxDecoration(border: Border.all(color: Color(0xFFBDBDBD))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("${reportsNotifier.count}"),
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
                          child: OutlineButton(
                            child: Text(
                              'Додати',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            highlightedBorderColor: Theme.of(context).accentColor,
                            borderSide: BorderSide(color: Theme.of(context).accentColor),
                            textColor: Theme.of(context).accentColor,
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
                                          color: Color(0xFFFF5B5E),
                                        ),
                                      );
                                    });
                              });
                            },
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
