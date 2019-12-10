
import 'package:holybible/models/bible.dart';
import 'package:holybible/repository/bible_database.dart';

class BibleRepository {
  Future<List<Bible>> findByVersion(String vcode) async {
    var db = await BibleDatabase.getDb();
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

  Future<List<Bible>> searchBibles(String vcode, String query) async {
    var db = await BibleDatabase.getDb();
    var results = await db.query(
      'bibles',
      columns: ['vcode', 'bcode', 'type', 'name', 'chapter_count'],
      where: 'vcode=:vcode and name like :query',
      whereArgs: [vcode, '%$query%'],
      orderBy: 'bcode asc'
    );
    List<Bible> bibles = List<Bible>();
    results.forEach((item) => bibles.add(Bible.fromMap(item)));
    return bibles;
  }

  Future<Bible> find(vcode, bcode) async {
    var db = await BibleDatabase.getDb();
    var results = await db.query(
        'bibles',
        columns: ['vcode', 'bcode', 'type', 'name', 'chapter_count'],
        where: 'vcode=:vcode and bcode=:bcode',
        whereArgs: [vcode, bcode]
    );

    return Bible.fromMap(results[0]);
  }

}
