import 'package:holybible/actions/actions.dart';
import 'package:holybible/repository/hymn_repository.dart';
import 'package:holybible/repository/version_repository.dart';
import 'package:redux/redux.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Middleware<AppState>> createMiddleware() {
  return [
    TypedMiddleware<AppState, dynamic>(_log),
    TypedMiddleware<AppState, LoadAppInfoAction>(_createLoadAppInfo()),
    TypedMiddleware<AppState, ChangeFontSizeAction>(_saveFontSize()),
    TypedMiddleware<AppState, ChangeDarkModeAction>(_saveUseDarkMode()),
  ];
}

void _log(Store<AppState> store, action, NextDispatcher next) {
  print('[Action] ${new DateTime.now()}: $action');
  next(action);
}


Middleware<AppState> _createLoadAppInfo() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    VersionRepository().findAll().then((versions) {
      store.dispatch(ReceiveVersionsAction(versions));
    });

    HymnRepository().findAll().then((hymns) {
      store.dispatch(ReceiveHymnsAction(hymns));
    });

    SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey('fontSize')) {
        store.dispatch(ChangeFontSizeAction(prefs.getDouble('fontSize')));
      }
      if (prefs.containsKey('useDarkMode')) {
        store.dispatch(ChangeDarkModeAction(prefs.getBool('useDarkMode')));
      }
    });
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

Middleware<AppState> _saveUseDarkMode() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('useDarkMode', action.useDarkMode);
    next(action);
  };
}
