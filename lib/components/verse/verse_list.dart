import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/components/app_bar.dart';
import 'package:holybible/components/loading.dart';
import 'package:holybible/components/verse/verse_list_item.dart';
import 'package:holybible/models/bible.dart';
import 'package:holybible/models/verse.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:holybible/repository/bible_repository.dart';
import 'package:holybible/repository/verse_repository.dart';
import 'package:redux/redux.dart';
import 'package:wakelock/wakelock.dart';

class VerseListWidget extends StatefulWidget {
  final String vcode;
  final int bcode;
  final int selectedChapter;
  final double fontSize;

  VerseListWidget({
    this.vcode,
    this.bcode,
    this.selectedChapter,
    this.fontSize
  });

  @override
  State<StatefulWidget> createState() => new _VerseListWidgetState(selectedChapter);
}

class _VerseListWidgetState extends State<VerseListWidget> {
  Bible bible;
  int selectedChapter;

  _VerseListWidgetState(this.selectedChapter);

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    _loadBible();
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  @override
  didUpdateWidget(VerseListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.vcode != oldWidget.vcode || widget.bcode != oldWidget.bcode) {
      _loadBible();
    }
  }

  _loadBible() async {
    var repository = BibleRepository();
    var loadBible = await repository.find(widget.vcode, widget.bcode);
    setState(() {
      bible = loadBible;
    });
  }


  @override
  Widget build(BuildContext context) {
    if (bible == null) {
      return Loading();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${bible.name} $selectedChapter'),
        actions: [
          SearchButton(),
          BookmarkButton(),
          SettingButton()
        ],
      ),
      body: PageView.builder(
        controller: PageController(
          initialPage: selectedChapter - 1
        ),
        itemBuilder: (context, index) => _VerseList(
          bible: bible,
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

  _loadVerses() {
    VerseRepository()
      .findByChapter(
        widget.bible.vcode,
        widget.bible.bcode,
        widget.cnum
      )
      .then((loadedVerses) {
        setState(() {
          verses = loadedVerses;
        });
      });
  }

  _handleChangeVerseBookmark(Verse verse) {
    var verseIndex = verses.indexWhere((item) => item.vnum == verse.vnum);
    if (verseIndex >= 0) {
      setState(() {
        verses.replaceRange(verseIndex, verseIndex + 1, [verse]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (verses.length == 0) {
      return Loading();
    }

    return new StoreConnector<AppState, _VerseListViewModel>(
      converter: _VerseListViewModel.fromStore,
      builder: (BuildContext context, _VerseListViewModel vm) {
        return ListView.builder(
          padding: EdgeInsets.only(
            top: 20.0,
            bottom: 20.0,
          ),
          itemBuilder: (context, index) => VerseListitem(
            bible: widget.bible,
            verse: verses[index],
            fontSize: vm.fontSize,
            onChange: _handleChangeVerseBookmark
          ),
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

