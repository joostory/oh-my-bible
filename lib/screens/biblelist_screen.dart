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
  State<StatefulWidget> createState() => _BibleListWidgetState();
}

class _BibleListWidgetState extends State<_BibleListWidget> {
  List<Bible> bibles = [];

  _BibleListWidgetState();

  @override
  initState() {
    super.initState();
    loadBibles();
  }

  @override
  didUpdateWidget(_BibleListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.version.vcode != oldWidget.version.vcode) {
      loadBibles();
    }
  }

  loadBibles() async {
    var repository = BibleRepository();
    var loadedBibles = await repository.loadBibles(widget.version.vcode);
    setState(() {
      bibles = loadedBibles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          ExpandAppBar(widget.version.name),
          SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                title: Text(bibles[index].name),
                onTap: () {
                  Bible bible = bibles[index];
                  Navigator.pushNamed(
                    context,
                    ChapterListScreen.routeName,
                    arguments: ChapterListScreenArguments(
                      bible.bcode
                    )
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
