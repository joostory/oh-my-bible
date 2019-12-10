
import 'package:holybible/models/verse.dart';
import 'package:holybible/repository/bible_database.dart';
import 'package:sqflite/sqflite.dart';

class VerseRepository {
  Future<List<Verse>> findByChapter(vcode, bcode, cnum) async {
    var db = await BibleDatabase.getDb();
    var results = await db.query(
      'verses',
      columns: ['vcode', 'bcode', 'cnum', 'vnum', 'content', 'bookmarked'],
      where: 'vcode=:vcode and bcode=:bcode and cnum=:cnum',
      whereArgs: [vcode, bcode, cnum],
      orderBy: 'vnum asc'
    );
    return results.map((item) => Verse.fromMap(item)).toList();
  }

  Future<List<SearchVerse>> findByKeyword(String vcode, String keyword) async {
    var db = await BibleDatabase.getDb();
    var results = await db.rawQuery(
      'select verses.*, bibles.name bibleName from verses inner join bibles on verses.bcode = bibles.bcode and bibles.vcode=? where verses.vcode=? and content like ? order by bcode, cnum asc',
      [vcode, vcode, '%$keyword%']
    );
    return results.map((item) => SearchVerse.fromMap(item)).toList();
  }

  Future<void> updateBookmarked(Verse verse, bool bookmarked) async {
    Database db = await BibleDatabase.getDb();
    await db.rawUpdate(
      'update verses set bookmarked = ? where vcode=:vcode and bcode=:bcode and cnum=:cnum and vnum=:vnum',
      [bookmarked, verse.vcode, verse.bcode, verse.cnum, verse.vnum]
    );
  }

  Future<List<SearchVerse>> findByBookmark(String vcode) async {
    var db = await BibleDatabase.getDb();
    var results = await db.rawQuery(
      'select verses.*, bibles.name bibleName from verses inner join bibles on verses.bcode = bibles.bcode and bibles.vcode=? where verses.vcode=? and bookmarked=true order by bcode, cnum asc',
      [vcode, vcode]
    );
    return results.map((item) => SearchVerse.fromMap(item)).toList();
  }
}
