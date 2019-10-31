import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/actions/actions.dart';
import 'package:holybible/middleware/middlewares.dart';
import 'package:holybible/reducers/app_reducer.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:holybible/screens/bible/biblelist_screen.dart';
import 'package:holybible/screens/bible/chapterlist_screen.dart';
import 'package:holybible/screens/hymn/hymnlist_screen.dart';
import 'package:holybible/screens/bible/verselist_screen.dart';
import 'package:holybible/screens/hymn/hymnscore_screen.dart';
import 'package:redux/redux.dart';

import 'components/navigation_bar.dart';

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

ThemeData makeThemeData(bool useDarkMode) => ThemeData(
  brightness: useDarkMode? Brightness.dark : Brightness.light,
  appBarTheme: AppBarTheme(
    color: useDarkMode? Color(0xee404040) : Color(0xee333333),
  ),
  primaryColor: Color(0xff333333),
  accentColor: Color(0xfff9dc41),
);

var _appNavigationItems = <AppNavigationItem>[
  AppNavigationItem(
    icon: Icons.book,
    title: '성경',
    app: _BibleApp()
  ),
  AppNavigationItem(
    icon: Icons.music_note,
    title: '찬송가',
    app: _HymnApp()
  )
];



class _ThemeApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ThemeAppState();
  }
}

class _ThemeAppState extends State<_ThemeApp> {
  int _navigationIndex = 0;

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {

        var home;
        if (vm.initialized) {
          home = Scaffold(
            body: _appNavigationItems[_navigationIndex].app,
            bottomNavigationBar: AppNavigationBar(
              index: _navigationIndex,
              onChange: (index) => setState(() {
                _navigationIndex = index;
              }),
              items: _appNavigationItems
            ),
          );
        } else {
          home = Scaffold(
            body: Center(
              child: Text("Loading..."),
            )
          );
        }

        return MaterialApp(
          theme: makeThemeData(vm.useDarkMode),
          home: home,
        );
      },
      onInit: (store) => store.dispatch(LoadAppInfoAction()),
    );
  }
}



class _BibleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Holybible',
          theme: makeThemeData(vm.useDarkMode),
          initialRoute: BibleListScreen.routeName,
          routes: {
            BibleListScreen.routeName: (context) => BibleListScreen(),
            ChapterListScreen.routeName: (context) => ChapterListScreen(),
            VerseListScreen.routeName: (context) => VerseListScreen(),
          },
        );
      },
    );
  }
}

class _HymnApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Holybible',
          theme: makeThemeData(vm.useDarkMode),
          initialRoute: HymnListScreen.routeName,
          routes: {
            HymnListScreen.routeName: (context) => HymnListScreen(),
            HymnScoreScreen.routeName: (context) => HymnScoreScreen(),
          },
        );
      },
    );
  }
}

class _ViewModel {
  final bool initialized;
  final bool useDarkMode;
  
  _ViewModel({
    this.initialized,
    this.useDarkMode
  });

  static _ViewModel fromStore(Store<AppState> store) => _ViewModel(
    initialized: store.state.initialized,
    useDarkMode: store.state.useDarkMode
  );
}


