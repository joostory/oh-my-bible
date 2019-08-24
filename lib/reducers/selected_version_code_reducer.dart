import 'package:holybible/actions/actions.dart';
import 'package:redux/redux.dart';

import '../models/version.dart';

final selectedVersionCodeReducer = combineReducers<String>([
  TypedReducer<String, ReceiveVersionsAction>(_setLoaded),
]);

String _setLoaded(String state, ReceiveVersionsAction action) {
  List<Version> versions = action.versions;
  if (versions.isEmpty) {
    return state;
  }

  if (versions.any((version) => version.vcode == 'GAE')) {
    return 'GAE';
  } else {
    return versions[0].vcode;
  }
}
