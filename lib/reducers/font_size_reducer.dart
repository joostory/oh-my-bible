import 'package:holybible/actions/actions.dart';
import 'package:redux/redux.dart';

final fontSizeReducer = combineReducers<double>([
  TypedReducer<double, ReceiveFontSizeAction>(_setLoaded),
  TypedReducer<double, ChangeFontSizeAction>(_setChanged),
]);


double _setLoaded(double state, ReceiveFontSizeAction action) {
  return action.fontSize;
}

double _setChanged(double state, ChangeFontSizeAction action) {
  return action.fontSize;
}

