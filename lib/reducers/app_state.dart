import 'package:holybible/models/hymn.dart';
import 'package:holybible/models/version.dart';

class AppState {
  final bool initialized;
  final List<Version> versions;
  final String selectedVersionCode;
  final List<Hymn> hymns;
  final double fontSize;
  final String fontFamily;
  final bool useDarkMode;

  AppState({
    this.initialized = false,
    this.versions = const [],
    this.selectedVersionCode = '',
    this.hymns = const [],
    this.fontSize = 16.0,
    this.fontFamily = 'notosans',
    this.useDarkMode = false
  });

  factory AppState.newInstance() => AppState();
}
