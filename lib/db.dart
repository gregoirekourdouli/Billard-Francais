
import 'dart:io';
import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:synchronized/synchronized.dart';


class Db {

  // Very important to handle migrations
  static const int version = 1;

  Database? _db;
  Lock lock = Lock();

  openDatabase() async {
    _db = sqlite3.open(join(await _localDirPath, 'billard.db'));
    await _handleMigration();
    if (kDebugMode) {
      print('db version: ${_db?.userVersion}');
    }
  }

  Future<String> get _localDirPath async {
    final directory = await getApplicationDocumentsDirectory();
    final appDir = Directory(join(directory.path, 'Kdli'));
    if (!await appDir.exists()) {
      await appDir.create();
    }
    return join(directory.path, 'Kdli');
  }

  _handleMigration() async {
    if (_db!.userVersion == Db.version) {
      return;
    }
    if (kDebugMode) {
      print("db version before migration: ${_db!.userVersion}");
    }
    for (var i = _db!.userVersion; i < Db.version; ++i) {
        var sql = await rootBundle.loadString('db_migrations/migration_$i.sql');
        _db!.execute(sql);
    }
    _db!.userVersion = Db.version;
    if (kDebugMode) {
      print("db version after migration: ${_db!.userVersion}");
    }
  }

  executeQuery(String query) async {
    await lock.synchronized(() async {
      if (_db == null) {
        await openDatabase();
      }
      _db!.execute(query);
    });
  }

  Future<ResultSet> selectQuery(String query) async {
    return await lock.synchronized(() async {
      if (_db == null) {
        await openDatabase();
      }
      return _db!.select(query);
    });
  }
}
