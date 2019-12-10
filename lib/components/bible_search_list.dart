import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/components/list/bible_list_widget.dart';
import 'package:holybible/components/loading.dart';
import 'package:holybible/components/text.dart';
import 'package:holybible/models/bible.dart';
import 'package:holybible/models/verse.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:holybible/repository/bible_repository.dart';
import 'package:holybible/repository/verse_repository.dart';
import 'package:holybible/screens/bible/verselist_screen.dart';
import 'package:redux/redux.dart';

class BibleSearchList extends StatelessWidget {
  final String query;

  BibleSearchList(this.query);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _BibleSearchViewModel>(
      converter: _BibleSearchViewModel.fromStore,
      builder: (BuildContext context, _BibleSearchViewModel vm) {
        return _BibleSearchListWidget(query, vm.vcode, vm.fontSize);
      },
    );
  }
}

class _BibleSearchViewModel {
  final String vcode;
  final double fontSize;

  _BibleSearchViewModel(this.vcode, this.fontSize);

  static _BibleSearchViewModel fromStore(Store<AppState> store) {
    return _BibleSearchViewModel(
      store.state.selectedVersionCode,
      store.state.fontSize
    );
  }
}

class _BibleSearchListWidget extends StatefulWidget {
  final String query;
  final String vcode;
  final double fontSize;
  _BibleSearchListWidget(this.query, this.vcode, this.fontSize);

  @override
  State<StatefulWidget> createState() => _BibleSearchListWidgetState();
}

class _BibleSearchListWidgetState extends State<_BibleSearchListWidget> {
  bool searched = false;
  List<Bible> bibles = [];
  List<SearchVerse> verses = [];

  @override
  void initState() {
    super.initState();
    if (widget.query.length == 0) {
      setState(() {
        searched = true;
        bibles = [];
        verses = [];
      });
      return;
    }

    _searchResults();
  }

  void _searchResults() {
    BibleRepository()
      .searchBibles(widget.vcode, widget.query)
      .then((results) {
        setState(() {
          searched = true;
          bibles = results;
        });
      });
    VerseRepository()
      .findByKeyword(widget.vcode, widget.query)
      .then((results) {
        setState(() {
          searched = true;
          verses = results;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    if (!searched) {
      return Loading();
    }

    if (bibles.length == 0 && verses.length == 0) {
      return MessageLoading(message: "검색 결과가 없습니다.");
    }

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate(
            bibles.map((item) => BibleListTileWidget(
              bible: item,
              fontSize: widget.fontSize
            )).toList()
          ),
        ),
        _VerseResultWidget(
          verses: verses,
          fontSize: widget.fontSize,
          query: widget.query
        )
      ],
    );
  }
    
}


class _VerseResultWidget extends StatelessWidget {
  final List<SearchVerse> verses;
  final double fontSize;
  final String query;

  _VerseResultWidget({
    this.verses,
    this.fontSize,
    this.query
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(verses.map((verse) => ListTile(
        title: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${verse.bibleName} ${verse.cnum} : ${verse.vnum}',
                style: TextStyle(
                  fontSize: fontSize - 4.0,
                  fontWeight: FontWeight.bold
                )
              ),
              HighlightText(
                content: verse.content,
                keyword: query,
                fontSize: fontSize
              )
            ],
          ),
          padding: EdgeInsets.symmetric(
            vertical: 5.0
          ),
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            VerseListScreen.routeName,
            arguments: VerseListScreenArguments(
              bcode: verse.bcode,
              cnum: verse.cnum
            )
          );
        },
      )).toList()),
    );
  }

}
