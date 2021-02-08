import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imes/widgets/base/custom_alert_dialog.dart';
import 'package:imes/widgets/base/custom_flat_button.dart';

import 'package:sizer/sizer.dart';

Future<T> showBlogInfoDialog<T>(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Увага!',
                  style: TextStyle(fontSize: 12.0.sp, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8.0),
              Icon(Icons.warning, color: Theme.of(context).errorColor, size: 90.0),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Для отримання балів за вивчення статті, необхідно повністю її прочитати',
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomFlatButton(
                    text: 'РОЗПОЧАТИ',
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomFlatButton(
                    text: 'ПОВЕРНУТИСЯ ПІЗНІШЕ',
                    color: Theme.of(context).errorColor,
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    }),
              ),
            ],
          ),
        );
      });
}

Future<T> showCameraGalleryChooseDialog<T>(BuildContext context) {
  return showDialog(
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
                      final image =
                          await ImagePicker().getImage(source: ImageSource.camera, maxWidth: 800, maxHeight: 600);
                      Navigator.of(context).pop(image?.path);
                    }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomFlatButton(
                    text: 'ГАЛЕРЕЯ',
                    color: Theme.of(context).primaryColor,
                    onPressed: () async {
                      final image =
                          await ImagePicker().getImage(source: ImageSource.gallery, maxWidth: 800, maxHeight: 600);
                      Navigator.of(context).pop(image?.path);
                    }),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
