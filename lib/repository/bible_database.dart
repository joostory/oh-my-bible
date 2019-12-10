
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BibleDatabase {
  static Future<Database> getDb() async {
    String documentDir = await getDatabasesPath();
    String dbPath = join(documentDir, "holybible.db");

    if (!await databaseExists(dbPath)) {
      await _prepareDatabaseFile(dbPath);
      _removeOldDatabaseFile(documentDir);
    }

    return await openDatabase(
      dbPath,
      version: 1,
      singleInstance: true,
      onUpgrade: _handleUpgrade
    );
  }

  static FutureOr<void> _handleUpgrade(Database db, int oldVersion, int newVersion) {
    // 나중에 필요할 때 사용
  }

  static _prepareDatabaseFile(dbPath) async {
    ByteData data = await rootBundle.load(join('assets', 'holybible.db'));
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    await new File(dbPath).writeAsBytes(bytes);
  }

  static _removeOldDatabaseFile(String documentDir) async {
    var oldDatabases = [
      "asset_holybible.db",
      "holybible-1.db"
    ];

    oldDatabases.forEach((filename) async {
      var path = join(documentDir, filename);
      if (!await databaseExists(path)) {
        await deleteDatabase(path);
      }
    });
  }
}
