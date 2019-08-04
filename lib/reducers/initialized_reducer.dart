import 'package:holybible/actions/actions.dart';
import 'package:redux/redux.dart';

final initializedReducer = combineReducers<bool>([
  TypedReducer<bool, ReceiveVersionsAction>(_setLoaded),
]);

bool _setLoaded(bool state, action) {
  return true;
}