import 'dart:io' show Platform;

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileUtils {
  static Future<String> downloadFile(String url) async {
    var status = await Permission.storage.request();
    var dir = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
    if (!await dir.exists()) {
      dir.create();
    }

    return await FlutterDownloader.enqueue(
      url: url,
      savedDir: dir.path,
      showNotification: true,
      openFileFromNotification: true,
    );
  }
}
