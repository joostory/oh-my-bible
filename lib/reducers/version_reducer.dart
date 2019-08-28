import 'package:holybible/actions/actions.dart';
import 'package:redux/redux.dart';

import '../models/version.dart';

final versionReducer = combineReducers<List<Version>>([
  TypedReducer<List<Version>, ReceiveVersionsAction>(_setLoaded),
]);

List<Version> _setLoaded(List<Version> state, ReceiveVersionsAction action) {
  return action.versions;
}
