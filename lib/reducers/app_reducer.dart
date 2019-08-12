import 'package:holybible/reducers/app_state.dart';
import 'package:holybible/reducers/initialized_reducer.dart';

import 'version_reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    isInitialized: initializedReducer(state.isInitialized, action),
    versions: versionReducer(state.versions, action)
  );
}
