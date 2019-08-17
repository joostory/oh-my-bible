
import 'package:holybible/models/bible.dart';
import 'package:holybible/models/version.dart';

class AppState {
  final bool isInitialized;
  final List<Version> versions;
  final List<Bible> bibles;

  AppState({
    this.isInitialized = false,
    this.versions = const [],
    this.bibles = const [],
  });

  factory AppState.newInstance() => AppState();
}
