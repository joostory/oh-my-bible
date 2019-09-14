import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/components/layout.dart';
import 'package:holybible/models/bible.dart';
import 'package:holybible/models/verse.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:holybible/repository/bible_repository.dart';
import 'package:redux/redux.dart';

class VerseListScreen extends StatelessWidget {
  static String routeName = '/bible/verse';

  @override
  Widget build(BuildContext context) {
    VerseListScreenArguments args = ModalRoute.of(context).settings.arguments;
    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return _VerseListWidget(
          vcode: vm.selectedVersion,
          bcode: args.bcode,
          selectedChapter: args.cnum,
          fontSize: vm.fontSize
        );
      },
    );
  }
}

class VerseListScreenArguments {
  int bcode;
  int cnum;
  VerseListScreenArguments({
    this.bcode,
    this.cnum
  });
}

class _ViewModel {
  final String selectedVersion;
  final double fontSize;
  _ViewModel(this.selectedVersion, this.fontSize);

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(store.state.selectedVersionCode, store.state.fontSize);
  }
}

class _VerseListWidget extends StatefulWidget {
  final String vcode;
  final int bcode;
  final int selectedChapter;
  final double fontSize;

  _VerseListWidget({
    this.vcode,
    this.bcode,
    this.selectedChapter,
    this.fontSize
  });

  @override
  State<StatefulWidget> createState() => new _VerseListWidgetState(selectedChapter);
}

class _VerseListWidgetState extends State<_VerseListWidget> {
  Bible bible;
  int selectedChapter;

  _VerseListWidgetState(this.selectedChapter);

  @override
  void initState() {
    super.initState();
    _loadBible();
  }

  @override
  didUpdateWidget(_VerseListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.vcode != oldWidget.vcode || widget.bcode != oldWidget.bcode) {
      _loadBible();
    }
  }

  _loadBible() async {
    var repository = BibleRepository();
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
      appBar: AppBar(
        title: Text('${bible.name} $selectedChapter'),
        actions: [
          SearchButton(),
          SettingButton()
        ],
      ),
      body: PageView.builder(
        controller: PageController(
          initialPage: selectedChapter - 1
        ),
        itemBuilder: (context, index) => _VerseList(
          bible :bible,
          cnum: index + 1,
        ),
        itemCount: bible.chapterCount,
        onPageChanged: (index) => setState(() => selectedChapter = index + 1),
      ),
    );
  }
}



class _VerseList extends StatefulWidget {
  final Bible bible;
  final int cnum;

  _VerseList({
    this.bible,
    this.cnum
  });

  @override
  State<StatefulWidget> createState() => _VerseListState();
}

class _VerseListState extends State<_VerseList> {
  List<Verse> verses = [];

  @override
  initState() {
    super.initState();
    _loadVerses();
  }

  @override
  didUpdateWidget(_VerseList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.bible.vcode != oldWidget.bible.vcode || widget.bible.bcode != oldWidget.bible.bcode) {
      _loadVerses();
    }
  }

  _loadVerses() async {
    var repository = new BibleRepository();
    var loadedVerses = await repository.loadVerses(
      widget.bible.vcode,
      widget.bible.bcode,
      widget.cnum
    );
    setState(() {
      verses = loadedVerses;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (verses.length == 0) {
      return Container(
        child: Text('Loading...'),
      );
    }

    return new StoreConnector<AppState, _VerseListViewModel>(
      converter: _VerseListViewModel.fromStore,
      builder: (BuildContext context, _VerseListViewModel vm) {
        return ListView.builder(
          padding: EdgeInsets.only(
            top: 20.0,
            bottom: 20.0
          ),
          itemBuilder: (context, index) => _VerseListitem(verses[index], vm.fontSize),
          itemCount: verses.length,
        );
      },
    );

  }
}

class _VerseListViewModel {
  final double fontSize;
  _VerseListViewModel(this.fontSize);

  static _VerseListViewModel fromStore(Store<AppState> store) {
    return _VerseListViewModel(store.state.fontSize);
  }
}

class _VerseListitem extends StatelessWidget {
  final Verse verse;
  final double fontSize;
  _VerseListitem(this.verse, this.fontSize);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.only(
                top: fontSize / 4,
                right: 8.0
              ),
              child: Text(
                '${verse.vnum}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize - fontSize / 4
                ),
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: Text(
              verse.content,
              style: TextStyle(
                fontSize: fontSize
              )
            )
          )
        ],
      ),
      padding: EdgeInsets.fromLTRB(15.0, 3.0, 20.0, 3.0)
    );
  }
}
