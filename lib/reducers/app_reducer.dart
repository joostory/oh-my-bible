import 'package:holybible/reducers/app_state.dart';
import 'package:holybible/reducers/darkmode_reducer.dart';
import 'package:holybible/reducers/font_family_reducer.dart';
import 'package:holybible/reducers/font_size_reducer.dart';
import 'package:holybible/reducers/hymn_reducer.dart';
import 'package:holybible/reducers/initialized_reducer.dart';
import 'package:holybible/reducers/version_reducer.dart';
import 'package:holybible/reducers/selected_version_code_reducer.dart';


AppState appReducer(AppState state, action) {
  return AppState(
    initialized: initializedReducer(state.initialized, action),
    versions: versionReducer(state.versions, action),
    selectedVersionCode: selectedVersionCodeReducer(state.selectedVersionCode, action),
    hymns: hymnReducer(state.hymns, action),
    fontSize: fontSizeReducer(state.fontSize, action),
    fontFamily: fontFamilyReducer(state.fontFamily, action),
    useDarkMode: darkModeReducer(state.useDarkMode, action)
  );
}
