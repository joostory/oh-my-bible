import 'package:holybible/actions/actions.dart';
import 'package:redux/redux.dart';

final darkModeReducer = combineReducers<bool>([
  TypedReducer<bool, ChangeDarkModeAction>(_setChanged),
]);


bool _setChanged(bool state, ChangeDarkModeAction action) {
  return action.useDarkMode;
}

