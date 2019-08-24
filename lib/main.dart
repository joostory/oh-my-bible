import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/middleware/middlewares.dart';
import 'package:holybible/reducers/app_reducer.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:holybible/screens/biblelist_screen.dart';
import 'package:holybible/screens/chapterlist_screen.dart';
import 'package:holybible/screens/verselist_screen.dart';
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
      child: MaterialApp(
        title: 'Holybible',
        theme: ThemeData.light(),
        initialRoute: '/',
        routes: {
          MainScreen.routeName: (context) => MainScreen(),
          BibleListScreen.routeName: (context) => BibleListScreen(),
          ChapterListScreen.routeName: (context) => ChapterListScreen(),
          VerseListScreen.routeName: (context) => VerseListScreen(),
        }
      )
    );
  }
}
