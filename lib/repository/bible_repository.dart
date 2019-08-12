

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:holybible/models/version.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BibleRepository {
  Database _dbInstance;

  Future<Database> getDb() async {
    String documentDir = await getDatabasesPath();
    String dbPath = join(documentDir, "asset_holybible.db");

    if (FileSystemEntity.typeSync(dbPath) == FileSystemEntityType.notFound) {
      ByteData data = await rootBundle.load(join('assets', 'holybible.db'));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Save copied asset to documents
      await new File(dbPath).writeAsBytes(bytes);
    }

    if (_dbInstance == null) {
      _dbInstance = await openDatabase(dbPath, readOnly: true);
    }
    return _dbInstance;

  }

  Future<List<Version>> loadVersions() async {
    var db = await getDb();
    var results = await db.query('versions', columns: ['vcode', 'name']);
    List<Version> versions = List<Version>();
    results.forEach((item) => versions.add(Version.fromMap(item)));
    return versions;
  }
}
