
import 'package:holybible/models/bible.dart';
import 'package:holybible/models/verse.dart';
import 'package:holybible/models/version.dart';
import 'package:holybible/repository/bible_database.dart';

class BibleRepository {

  Future<List<Version>> loadVersions() async {
    var db = await BibleDatabase.getDb();
    var results = await db.query(
      'versions',
      columns: ['vcode', 'name']
    );
    List<Version> versions = List<Version>();
    results.forEach((item) => versions.add(Version.fromMap(item)));
    return versions;
  }

  Future<List<Bible>> loadBibles(String vcode) async {
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

  Future<Bible> loadBible(vcode, bcode) async {
    var db = await BibleDatabase.getDb();
    var results = await db.query(
        'bibles',
        columns: ['vcode', 'bcode', 'type', 'name', 'chapter_count'],
        where: 'vcode=:vcode and bcode=:bcode',
        whereArgs: [vcode, bcode]
    );

    return Bible.fromMap(results[0]);
  }

  Future<List<Verse>> loadVerses(vcode, bcode, cnum) async {
    var db = await BibleDatabase.getDb();
    var results = await db.query(
      'verses',
      columns: ['vcode', 'bcode', 'cnum', 'vnum', 'content'],
      where: 'vcode=:vcode and bcode=:bcode and cnum=:cnum',
      whereArgs: [vcode, bcode, cnum],
      orderBy: 'vnum asc'
    );
    List<Verse> verses = List<Verse>();
    results.forEach((item) => verses.add(Verse.fromMap(item)));
    return verses;
  }

  Future<List<SearchVerse>> searchVerses(String vcode, String keyword) async {
    var db = await BibleDatabase.getDb();
    var results = await db.rawQuery(
      'select verses.*, bibles.name bibleName from verses inner join bibles on verses.bcode = bibles.bcode and bibles.vcode=? where verses.vcode=? and content like ? order by bcode, cnum asc',
      [vcode, vcode, '%$keyword%']
    );
    List<SearchVerse> verses = List<SearchVerse>();
    results.forEach((item) => verses.add(SearchVerse.fromMap(item)));
    return verses;
  }


}
