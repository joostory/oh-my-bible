
import 'package:holybible/models/bible.dart';
import 'package:holybible/models/verse.dart';
import 'package:holybible/models/version.dart';

class AppState {
  final bool isInitialized;
  final List<Version> versions;
  final List<Bible> bibles;
  final List<Verse> verses;

  AppState({
    this.isInitialized = false,
    this.versions = const [],
    this.bibles = const [],
    this.verses = const []
  });

  factory AppState.newInstance() => AppState();
}
