
import 'package:holybible/models/version.dart';

class AppState {
  final bool initialized;
  final List<Version> versions;
  final String selectedVersionCode;
  final double fontSize;

  AppState({
    this.initialized = false,
    this.versions = const [],
    this.selectedVersionCode = '',
    this.fontSize = 16.0
  });

  factory AppState.newInstance() => AppState();
}
