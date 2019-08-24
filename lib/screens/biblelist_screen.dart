
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/components/list.dart';
import 'package:holybible/models/bible.dart';
import 'package:holybible/models/version.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:holybible/repository/bible_repository.dart';
import 'package:redux/redux.dart';

import 'chapterlist_screen.dart';

class BibleListScreen extends StatelessWidget {
  static String routeName = '/bible';

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return _BibleListWidget(vm.selectedVersion);
      },
    );
  }
}


class _ViewModel {
  final selectedVersion;

  _ViewModel(this.selectedVersion);

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      store.state.versions.firstWhere(
        (version) => version.vcode == store.state.selectedVersionCode
      )
    );
  }
}

class _BibleListWidget extends StatefulWidget {
  final Version version;

  _BibleListWidget(this.version);

  @override
  State<StatefulWidget> createState() => _BibleListWidgetState(version);

}

class _BibleListWidgetState extends State<_BibleListWidget> {
  final Version version;
  List<Bible> bibles = [];

  _BibleListWidgetState(this.version);

  @override
  initState() {
    super.initState();
    loadBibles();
  }

  loadBibles() async {
    if (version != null) {
      var repository = BibleRepository();
      var loadedBibles = await repository.loadBibles(version.vcode);
      setState(() {
        bibles = loadedBibles;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          ExpandAppBar(version.name),
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
