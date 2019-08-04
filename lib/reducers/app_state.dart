
import 'package:holybible/models/version.dart';

class AppState {
  final bool isInitialized;
  final List<Version> versions;

  AppState({
    this.isInitialized = false,
    this.versions = const []
  });

  factory AppState.newInstance() => AppState();
}
