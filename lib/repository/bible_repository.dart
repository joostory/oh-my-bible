

import 'package:holybible/models/version.dart';
import 'package:sqflite/sqflite.dart';

class BibleRepository {
  Database db;

  BibleRepository() {
    this.init();
  }

  init() async {
    String documentDir = await getDatabasesPath();
    db = await openDatabase('$documentDir/bible.db');
  }

  loadVersions() async {
    var results = await db.rawQuery('select vcode, name from versions');
    return results.isNotEmpty? results.map((item) => Version.fromMap(item)).toList() : [];
  }
}
