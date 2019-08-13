import 'package:holybible/actions/actions.dart';
import 'package:holybible/models/verse.dart';
import 'package:redux/redux.dart';

final verseReducer = combineReducers<List<Verse>>([
  TypedReducer<List<Verse>, ReceiveVersesAction>(_setLoaded),
]);

List<Verse> _setLoaded(List<Verse> state, ReceiveVersesAction action) {
  return action.verses;
}
