
import 'package:holybible/models/hymn.dart';
import 'package:holybible/repository/bible_database.dart';

class HymnRepository {
  Future<List<Hymn>> loadHymns() async {
    var db = await BibleDatabase.getDb();
    var results = await db.query(
      'hymns',
      columns: ['number', 'title'],
      where: 'version="new"',
      orderBy: 'number asc'
    );

    List<Hymn> list = new List<Hymn>();
    results.forEach((item) {
      list.add(Hymn.fromMap(item));
    });
    return list;
  }
}