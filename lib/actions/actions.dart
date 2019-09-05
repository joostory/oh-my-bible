
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

class ReceiveFontSizeAction {
  final double fontSize;
  ReceiveFontSizeAction(this.fontSize);
}

class ChangeSelectedVersionAction {
  final Version version;
  ChangeSelectedVersionAction(this.version);
}

class ChangeFontSizeAction {
  final double fontSize;
  ChangeFontSizeAction(this.fontSize);
}

class ChangeDarkModeAction {
  final bool useDarkMode;
  ChangeDarkModeAction(this.useDarkMode);
}
