
import 'package:holybible/models/hymn.dart';
import 'package:holybible/repository/bible_database.dart';

class HymnRepository {
  Future<List<Hymn>> findAll() async {
    var db = await BibleDatabase.getDb();
    var results = await db.query(
      'hymns',
      columns: ['number', 'title'],
      where: 'version="new"',
      orderBy: 'number asc'
    );

    return Hymn.fromMapList(results);
  }

  Future<List<Hymn>> findByKeyword(String keyword) async {
    var db = await BibleDatabase.getDb();
    var results = await db.query(
      'hymns',
      columns: ['number', 'title'],
      where: 'version="new" and title like ?',
      whereArgs: ["%$keyword%"],
      orderBy: 'number asc'
    );

    return Hymn.fromMapList(results);
  }

  Future<List<Hymn>> findByNumber(String number) async {
    var db = await BibleDatabase.getDb();
    var results = await db.query(
      'hymns',
      columns: ['number', 'title'],
      where: 'version="new" and number like ?',
      whereArgs: ["%$number%"],
      orderBy: 'number asc'
    );

    return Hymn.fromMapList(results);
  }
}