import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/actions/actions.dart';
import 'package:holybible/components/list.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:redux/src/store.dart';

import '../models/version.dart';
import 'biblelist_screen.dart';

class VersionListScreen extends StatelessWidget {
  static String routeName = '/';
  
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return vm.isInitialized? _VersionList(vm.versions) : _Splash();
      },
      onInit: (store) => store.dispatch(LoadAppInfoAction()),
    );
  }
}

class _ViewModel {
  final bool isInitialized;
  final List<Version> versions;

  _ViewModel({
    this.isInitialized,
    this.versions
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      isInitialized: store.state.isInitialized,
      versions: store.state.versions
    );
  }
}

class _VersionList extends StatelessWidget {
  final List<Version> versions;

  _VersionList(this.versions);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          TextAppBar('성경'),
          SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                title: Text(versions[index].name),
                onTap: () {
                  Navigator.pushNamed(
                      context,
                      BibleListScreen.routeName,
                      arguments: BibleListScreenArguments(versions[index])
                  );
                },
              ),
              childCount: versions.length,
            ),
          )
        ],
      )
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

