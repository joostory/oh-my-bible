import 'package:holybible/actions/actions.dart';
import 'package:redux/redux.dart';

import '../models/hymn.dart';

final hymnReducer = combineReducers<List<Hymn>>([
  TypedReducer<List<Hymn>, ReceiveHymnsAction>(_setLoaded),
]);

List<Hymn> _setLoaded(List<Hymn> state, ReceiveHymnsAction action) {
  return action.hymns;
}
