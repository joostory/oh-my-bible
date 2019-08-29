import 'package:holybible/actions/actions.dart';
import 'package:holybible/repository/bible_repository.dart';
import 'package:redux/redux.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/version.dart';

List<Middleware<AppState>> createMiddleware() {

  final repository = new BibleRepository();

  return [
    TypedMiddleware<AppState, dynamic>(_log),
    TypedMiddleware<AppState, LoadAppInfoAction>(_createLoadAppInfo(repository)),
    TypedMiddleware<AppState, ChangeFontSizeAction>(_saveFontSize()),
  ];
}

void _log(Store<AppState> store, action, NextDispatcher next) {
  print('[Action] ${new DateTime.now()}: $action');
  next(action);
}


Middleware<AppState> _createLoadAppInfo(BibleRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    List<Version> versions = await repository.loadVersions();
    store.dispatch(ReceiveVersionsAction(versions));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    store.dispatch(ReceiveFontSizeAction(prefs.getDouble('fontSize')));
    next(action);
  };
}

Middleware<AppState> _saveFontSize() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('fontSize', action.fontSize);
    next(action);
  };
}
