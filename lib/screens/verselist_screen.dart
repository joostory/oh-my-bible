import 'package:flutter/material.dart';
import 'package:holybible/models/bible.dart';
import 'package:holybible/models/verse.dart';
import 'package:holybible/repository/bible_repository.dart';

class VerseListScreen extends StatelessWidget {
  static String routeName = '/verse';

  @override
  Widget build(BuildContext context) {
    VerseListScreenArguments args = ModalRoute.of(context).settings.arguments;
    return new _VerseListWidget(
      bible: args.bible,
      selectedChapter: args.cnum,
    );
  }
}

class _VerseListWidget extends StatefulWidget {
  final Bible bible;
  final int selectedChapter;

  _VerseListWidget({
    this.bible,
    this.selectedChapter
  });

  @override
  State<StatefulWidget> createState() => new _VerseListWidgetState(
    bible: bible,
    selectedChapter: selectedChapter
  );
}

class _VerseListWidgetState extends State<_VerseListWidget> {
  Bible bible;
  int selectedChapter;

  _VerseListWidgetState({
    this.bible,
    this.selectedChapter
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${bible.name} $selectedChapter'),
        backgroundColor: Color.fromRGBO(64, 64, 64, 0.9),
      ),
      body: PageView.builder(
        controller: PageController(
            initialPage: selectedChapter - 1
        ),
        itemBuilder: (context, index) => _VerseList(
          bible :bible,
          cnum: index + 1
        ),
        itemCount: bible.chapterCount,
        onPageChanged: (index) => setState(() => selectedChapter = index + 1),
      )
    );
  }
}

class VerseListScreenArguments {
  Bible bible;
  int cnum;
  VerseListScreenArguments(this.bible, this.cnum);
}

class _VerseList extends StatefulWidget {
  final Bible bible;
  final int cnum;

  _VerseList({
    this.bible,
    this.cnum
  });

  @override
  State<StatefulWidget> createState() => _VerseListState(
    bible: bible,
    cnum: cnum
  );
}

class _VerseListState extends State<_VerseList> {
  final Bible bible;
  final int cnum;
  List<Verse> verses = [];

  _VerseListState({
    this.bible,
    this.cnum
  });


  @override
  initState() {
    super.initState();
    loadVerses();
  }

  loadVerses() async {
    var repository = new BibleRepository();
    var loadedVerses = await repository.loadVerses(bible.vcode, bible.bcode, cnum);
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

    return ListView.builder(
      itemBuilder: (context, index) => Container(
        child: Text('${index + 1} ${verses[index].content}'),
        padding: EdgeInsets.symmetric(
            horizontal: 10.0
        ),
        margin: EdgeInsets.symmetric(
          vertical: 5.0,
        ),
      ),
      itemCount: verses.length,
    );
  }
}

