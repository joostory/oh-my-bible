import 'package:holybible/reducers/app_state.dart';
import 'package:holybible/reducers/initialized_reducer.dart';
import 'package:holybible/reducers/version_reducer.dart';
import 'package:holybible/reducers/selected_version_code_reducer.dart';


AppState appReducer(AppState state, action) {
  return AppState(
    initialized: initializedReducer(state.initialized, action),
    versions: versionReducer(state.versions, action),
    selectedVersionCode: selectedVersionCodeReducer(state.selectedVersionCode, action)
  );
}
