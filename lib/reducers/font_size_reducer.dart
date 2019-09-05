import 'package:holybible/actions/actions.dart';
import 'package:redux/redux.dart';

final fontSizeReducer = combineReducers<double>([
  TypedReducer<double, ChangeFontSizeAction>(_setChanged),
]);


double _setChanged(double state, ChangeFontSizeAction action) {
  return action.fontSize;
}

