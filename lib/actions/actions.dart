
import 'package:holybible/models/bible.dart';
import 'package:holybible/models/verse.dart';
import 'package:holybible/models/version.dart';

class LoadAppInfoAction {}

class LoadBibleListAction {
  final Version version;
  LoadBibleListAction(this.version);
}

class ReceiveVersionsAction {
  final List<Version> versions;
  ReceiveVersionsAction(this.versions);
}
