import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/actions/actions.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:redux/src/store.dart';

class MainScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return vm.isInitialized? VersionList() : Splash();
      },
      onInit: (store) => store.dispatch(LoadAppInfoAction()),
    );
  }
}

class _ViewModel {
  final bool isInitialized;

  _ViewModel({
    this.isInitialized
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      isInitialized: store.state.isInitialized
    );
  }
}

class VersionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Loaded")
      )
    );
  }

}


class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Loading..."),
      )
    );
  }

}

