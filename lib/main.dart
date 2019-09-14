import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/middleware/middlewares.dart';
import 'package:holybible/reducers/app_reducer.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:holybible/screens/bible/biblelist_screen.dart';
import 'package:holybible/screens/bible/chapterlist_screen.dart';
import 'package:holybible/screens/hymn/hymnlist_screen.dart';
import 'package:holybible/screens/bible/searchlist_screen.dart';
import 'package:holybible/screens/bible/verselist_screen.dart';
import 'package:holybible/screens/main_screen.dart';
import 'package:redux/redux.dart';

void main() => runApp(HolyBibleApp());

class HolyBibleApp extends StatelessWidget {

  final Store<AppState> store = new Store<AppState>(
      appReducer,
      initialState: AppState.newInstance(),
      middleware: createMiddleware()
  );

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: _ThemeApp()
    );
  }
}


class _ThemeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Holybible',
          theme: ThemeData(
            brightness: vm.useDarkMode? Brightness.dark : Brightness.light,
            appBarTheme: AppBarTheme(
              color: Color.fromRGBO(64, 64, 64, 0.9),
            ),
          ),
          initialRoute: '/',
          routes: {
            MainScreen.routeName: (context) => MainScreen(),
            BibleListScreen.routeName: (context) => BibleListScreen(),
            ChapterListScreen.routeName: (context) => ChapterListScreen(),
            VerseListScreen.routeName: (context) => VerseListScreen(),
            SearchListScreen.routeName: (context) => SearchListScreen(),
            HymnListScreen.routeName: (context) => HymnListScreen()
          }
        );
      },
    );
  }
}

class _ViewModel {
  final bool useDarkMode;
  _ViewModel(this.useDarkMode);

  static _ViewModel fromStore(Store<AppState> store) => _ViewModel(store.state.useDarkMode);
}


