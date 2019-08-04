
import 'package:holybible/models/version.dart';

class LoadAppInfoAction {}

class ReceiveVersionsAction {
  List<Version> versions;

  ReceiveVersionsAction(this.versions);
}