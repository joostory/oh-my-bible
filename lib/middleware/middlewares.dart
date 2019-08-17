import 'package:holybible/actions/actions.dart';
import 'package:holybible/models/bible.dart';
import 'package:holybible/repository/bible_repository.dart';
import 'package:redux/redux.dart';
import 'package:holybible/reducers/app_state.dart';

import '../models/version.dart';

List<Middleware<AppState>> createMiddleware() {

  final repository = new BibleRepository();

  return [
    TypedMiddleware<AppState, dynamic>(_log),
    TypedMiddleware<AppState, LoadAppInfoAction>(createLoadAppInfo(repository)),
    TypedMiddleware<AppState, LoadBibleListAction>(loadBibleList(repository)),
  ];
}

void _log(Store<AppState> store, action, NextDispatcher next) {
  print('[Action] ${new DateTime.now()}: $action');
  next(action);
}


Middleware<AppState> createLoadAppInfo(BibleRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    List<Version> versions = await repository.loadVersions();
    store.dispatch(ReceiveVersionsAction(versions));
    next(action);
  };
}


Middleware<AppState> loadBibleList(BibleRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    List<Bible> bibles = await repository.loadBibles(action.version.vcode);
    store.dispatch(ReceiveBiblesAction(bibles));
    next(action);
  };
}

