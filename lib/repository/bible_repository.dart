

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:holybible/models/bible.dart';
import 'package:holybible/models/verse.dart';
import 'package:holybible/models/version.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BibleRepository {
  Database _dbInstance;

  Future<Database> _getDb() async {
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
    var db = await _getDb();
    var results = await db.query(
      'versions',
      columns: ['vcode', 'name']
    );
    List<Version> versions = List<Version>();
    results.forEach((item) => versions.add(Version.fromMap(item)));
    return versions;
  }

  loadBibles(String vcode) async {
    var db = await _getDb();
    var results = await db.query(
      'bibles',
      columns: ['vcode', 'bcode', 'type', 'name', 'chapter_count'],
      where: 'vcode=:vcode',
      whereArgs: [vcode],
      orderBy: 'bcode asc'
    );
    List<Bible> bibles = List<Bible>();
    results.forEach((item) => bibles.add(Bible.fromMap(item)));
    return bibles;
  }

  loadVerses(vcode, bcode, cnum) async {
    var db = await _getDb();
    var results = await db.query(
      'verses',
      columns: [],
      where: 'vcode=:vcode and bcode=:bcode and cnum=:cnum',
      whereArgs: [vcode, bcode, cnum],
      orderBy: 'vnum asc'
    );
    List<Verse> verses = List<Verse>();
    results.forEach((item) => verses.add(Verse.fromMap(item)));
    return verses;
  }
}
