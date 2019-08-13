
import 'package:holybible/models/bible.dart';
import 'package:holybible/models/verse.dart';
import 'package:holybible/models/version.dart';

class LoadAppInfoAction {}

class LoadBibleListAction {
  Version version;
  LoadBibleListAction(this.version);
}

class LoadVerseListAction {
  Bible bible;
  int cnum;
  LoadVerseListAction(this.bible, this.cnum);
}

class ReceiveVersionsAction {
  List<Version> versions;
  ReceiveVersionsAction(this.versions);
}

class ReceiveBiblesAction {
  List<Bible> bibles;
  ReceiveBiblesAction(this.bibles);
}

class ReceiveVersesAction {
  List<Verse> verses;
  ReceiveVersesAction(this.verses);
}
