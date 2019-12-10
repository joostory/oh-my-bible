
import 'package:holybible/models/verse.dart';
import 'package:holybible/repository/verse_repository.dart';

abstract class CustomBehavior {
  Future run();
}

class UpdateBookmarkBehavior implements CustomBehavior {
  final Verse verse;
  final bool bookmarked;

  UpdateBookmarkBehavior({this.verse, this.bookmarked});


  @override
  Future run() async {
    await VerseRepository().updateBookmarked(verse, bookmarked);
  }
}

