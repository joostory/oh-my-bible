
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
      version: 2,
      singleInstance: true,
      onUpgrade: _handleUpgrade
    );
  }

  static FutureOr<void> _handleUpgrade(Database db, int oldVersion, int newVersion) {
    var batch = db.batch();
    if (oldVersion < 2 && newVersion >= 2) {
      print('[DB_UPGRADE] ${new DateTime.now()}: upgrade v2');
      batch.execute('update verses set bookmarked=false');
      batch.execute('update hymns set bookmarked=false');
    }
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
