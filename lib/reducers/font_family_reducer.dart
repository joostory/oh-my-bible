import 'package:holybible/actions/actions.dart';
import 'package:redux/redux.dart';

final fontFamilyReducer = combineReducers<String>([
  TypedReducer<String, ChangeFontFamilyAction>(_setChanged),
]);


String _setChanged(String state, ChangeFontFamilyAction action) {
  return action.fontFamily;
}

