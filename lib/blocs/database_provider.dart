import 'package:path/path.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

final dbProvider = FutureProvider<DbStorage>((ref) async {
  var dir = await getApplicationDocumentsDirectory();
  await dir.create(recursive: true);
  var dbPath = join(dir.path, 'data.bin');
  var db = await databaseFactoryIo.openDatabase(dbPath);
  return DbStorage(db);
});

class DbStorage {
  final Database db;
  final StoreRef store;

  DbStorage(this.db) : store = stringMapStoreFactory.store();

  Future<void> write(String key, Map<String, dynamic> json) async {
    await store.record(key).put(db, json);
  }

  Future<Map<String, dynamic>> read(String key) {
    return store.record(key).get(db);
  }
}
