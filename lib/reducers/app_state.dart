
import 'package:holybible/models/version.dart';

class AppState {
  final bool initialized;
  final List<Version> versions;
  final String selectedVersionCode;

  AppState({
    this.initialized = false,
    this.versions = const [],
    this.selectedVersionCode = ''
  });

  factory AppState.newInstance() => AppState();
}
