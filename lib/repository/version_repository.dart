
import 'package:holybible/models/version.dart';
import 'package:holybible/repository/bible_database.dart';

class VersionRepository {
  Future<List<Version>> findAll() async {
    var db = await BibleDatabase.getDb();
    var results = await db.query(
      'versions',
      columns: ['vcode', 'name']
    );
    List<Version> versions = List<Version>();
    results.forEach((item) => versions.add(Version.fromMap(item)));
    return versions;
  }
}