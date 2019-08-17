
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/actions/actions.dart';
import 'package:holybible/components/list.dart';
import 'package:holybible/models/bible.dart';
import 'package:holybible/models/version.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:redux/redux.dart';

import 'chapterlist_screen.dart';

class BibleListScreen extends StatelessWidget {
  static String routeName = '/bible';

  @override
  Widget build(BuildContext context) {
    BibleListScreenArguments args = ModalRoute.of(context).settings.arguments;

    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return _BibleList(args.version, vm.bibles);
      },
      onInit: (store) => store.dispatch(LoadBibleListAction(args.version)),
    );
  }
}

class BibleListScreenArguments {
  Version version;
  BibleListScreenArguments(this.version);
}


class _ViewModel {
  final bibles;

  _ViewModel(this.bibles);

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      store.state.bibles
    );
  }
}

class _BibleList extends StatelessWidget {
  final Version version;
  final List<Bible> bibles;

  _BibleList(this.version, this.bibles);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          TextAppBar(version.name),
          SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                title: Text(bibles[index].name),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    ChapterListScreen.routeName,
                    arguments: ChapterListScreenArguments(bibles[index])
                  );
                },
              ),
              childCount: bibles.length
            )
          )
        ],
      )
    );
  }

}
