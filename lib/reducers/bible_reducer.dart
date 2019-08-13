import 'package:holybible/actions/actions.dart';
import 'package:holybible/models/bible.dart';
import 'package:redux/redux.dart';

final bibleReducer = combineReducers<List<Bible>>([
  TypedReducer<List<Bible>, ReceiveBiblesAction>(_setLoaded),
]);

List<Bible> _setLoaded(List<Bible> state, ReceiveBiblesAction action) {
  return action.bibles;
}
