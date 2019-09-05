
import 'package:holybible/models/version.dart';

class AppState {
  final bool initialized;
  final List<Version> versions;
  final String selectedVersionCode;
  final double fontSize;
  final bool useDarkMode;

  AppState({
    this.initialized = false,
    this.versions = const [],
    this.selectedVersionCode = '',
    this.fontSize = 16.0,
    this.useDarkMode = false
  });

  factory AppState.newInstance() => AppState();
}
