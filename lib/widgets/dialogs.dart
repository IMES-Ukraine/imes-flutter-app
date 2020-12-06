import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imes/helpers/utils.dart';

import 'base/custom_alert_dialog.dart';
import 'base/custom_dialog.dart';
import 'base/custom_flat_button.dart';

Future<T> showErrorDialog<T>(BuildContext context, dynamic error) {
  print(error);
  return showDialog(
    context: context,
    builder: (context) {
      return CustomAlertDialog(
        content: CustomDialog(
          icon: Icons.close,
          color: Theme.of(context).errorColor,
          text: Utils.getErrorText(error),
        ),
      );
    },
  );
}

Future<T> showChoosePictureDialog<T>(BuildContext context) {
  return showDialog<T>(
      context: context,
      builder: (context) => CustomAlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CustomFlatButton(
                          text: 'КАМЕРА',
                          color: Theme.of(context).primaryColor,
                          onPressed: () async {
                            final image = await ImagePicker().getImage(source: ImageSource.camera);
                            Navigator.of(context).pop(image?.path);
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CustomFlatButton(
                          text: 'ГАЛЕРЕЯ',
                          color: Theme.of(context).primaryColor,
                          onPressed: () async {
                            final image = await ImagePicker().getImage(source: ImageSource.gallery);
                            Navigator.of(context).pop(image?.path);
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ));
}
