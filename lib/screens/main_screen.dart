import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/actions/actions.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:redux/redux.dart';

import '../models/version.dart';
import 'biblelist_screen.dart';

class MainScreen extends StatelessWidget {
  static String routeName = '/';
  
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return _Splash();
      },
      onInit: (store) => store.dispatch(LoadAppInfoAction()),
      onDidChange: (_ViewModel vm) {
        if (vm.initialized) {
          Navigator.pushReplacementNamed(
              context,
              BibleListScreen.routeName
          );
        }
      },
    );
  }
}

class _ViewModel {
  final bool initialized;
  final List<Version> versions;

  _ViewModel({
    this.initialized,
    this.versions
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      initialized: store.state.initialized,
      versions: store.state.versions
    );
  }
}

class _Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Loading..."),
      )
    );
  }

}

