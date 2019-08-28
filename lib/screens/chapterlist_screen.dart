
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/components/list.dart';
import 'package:holybible/models/bible.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:holybible/repository/bible_repository.dart';
import 'package:holybible/screens/verselist_screen.dart';
import 'package:redux/redux.dart';

class ChapterListScreen extends StatelessWidget {
  static String routeName = '/chapter';

  @override
  Widget build(BuildContext context) {
    ChapterListScreenArguments args = ModalRoute.of(context).settings.arguments;
    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return _ChapterList(
          vcode: vm.selectedVersion,
          bcode: args.bcode
        );
      },
    );
  }
}

class ChapterListScreenArguments {
  int bcode;
  ChapterListScreenArguments(this.bcode);
}

class _ViewModel {
  final String selectedVersion;
  _ViewModel(this.selectedVersion);

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(store.state.selectedVersionCode);
  }
}

class _ChapterList extends StatefulWidget {
  final String vcode;
  final int bcode;

  _ChapterList({
    this.vcode,
    this.bcode
  });

  @override
  State<StatefulWidget> createState() => _ChapterListState();
}

class _ChapterListState extends State<_ChapterList> {
  Bible bible;

  _ChapterListState();

  @override
  void initState() {
    super.initState();
    _loadBible();
  }

  @override
  didUpdateWidget(_ChapterList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.vcode != oldWidget.vcode || widget.bcode != oldWidget.bcode) {
      _loadBible();
    }
  }

  _loadBible() async {
    var repository = new BibleRepository();
    var loadBible = await repository.loadBible(widget.vcode, widget.bcode);
    setState(() {
      bible = loadBible;
    });
  }


  @override
  Widget build(BuildContext context) {
    if (bible == null) {
      return Scaffold(
        body: Center(
          child: Text("Loading..."),
        )
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          ExpandAppBar(bible.name),
          SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                title: Text('${bible.name} ${index + 1}'),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    VerseListScreen.routeName,
                    arguments: VerseListScreenArguments(
                      bcode: bible.bcode,
                      cnum: index + 1
                    )
                  );
                },
              ),
              childCount: bible.chapterCount
            )
          )
        ],
      )
    );
  }
}