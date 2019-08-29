import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/actions/actions.dart';
import 'package:holybible/models/version.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:holybible/screens/searchlist_screen.dart';
import 'package:redux/redux.dart';

class ExpandAppBar extends StatelessWidget {
  final String _title;

  ExpandAppBar(this._title);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: false,
      pinned: true,
      snap: false,
      expandedHeight: 100.0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(_title),
        centerTitle: true
      ),
      leading: Container(
        padding: EdgeInsets.all(10.0),
        child: Image.asset('assets/icon/ico_holybible.png'),
      ),
      titleSpacing: 1.0,
      backgroundColor: Color.fromRGBO(64, 64, 64, 0.9),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Navigator.pushNamed(
              context,
              SearchListScreen.routeName,
            );
          },
        ),
        AppBarPopupMenu()
      ],
    );
  }
}

class AppBarPopupMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return _AppBarPopupMenuWidget(vm.versions);
      },
    );
  }
}


class _ViewModel {
  List<Version> versions = [];
  _ViewModel({this.versions});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
        versions: store.state.versions
    );
  }
}


class _AppBarPopupMenuWidget extends StatelessWidget {
  final List<Version> versions;
  _AppBarPopupMenuWidget(this.versions);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Version>(
      onSelected: (version) {
        var store = StoreProvider.of<AppState>(context);
        store.dispatch(ChangeSelectedVersionAction(version));
      },
      itemBuilder: (context) {
        return versions.map((version) =>
          PopupMenuItem(
            child: Text(version.name),
            value: version,
          )
        ).toList();
      },
    );
  }
}
