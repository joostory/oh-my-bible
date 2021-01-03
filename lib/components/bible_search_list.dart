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
import 'package:holybible/utils/font_utils.dart';
import 'package:redux/redux.dart';

class BibleSearchList extends StatelessWidget {
  final String query;

  BibleSearchList(this.query);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _BibleSearchViewModel>(
      converter: _BibleSearchViewModel.fromStore,
      builder: (BuildContext context, _BibleSearchViewModel vm) {
        return _BibleSearchListWidget(query, vm.vcode, vm.fontSize, vm.fontFamily);
      },
    );
  }
}

class _BibleSearchViewModel {
  final String vcode;
  final double fontSize;
  final String fontFamily;

  _BibleSearchViewModel(this.vcode, this.fontSize, this.fontFamily);

  static _BibleSearchViewModel fromStore(Store<AppState> store) {
    return _BibleSearchViewModel(
      store.state.selectedVersionCode,
      store.state.fontSize,
      store.state.fontFamily
    );
  }
}

class _BibleSearchListWidget extends StatefulWidget {
  final String query;
  final String vcode;
  final double fontSize;
  final String fontFamily;

  _BibleSearchListWidget(this.query, this.vcode, this.fontSize, this.fontFamily);

  @override
  State<StatefulWidget> createState() => _BibleSearchListWidgetState();
}

class _BibleSearchListWidgetState extends State<_BibleSearchListWidget> {
  String keyword = "";
  bool searched = false;
  List<Bible> bibles = [];
  List<SearchVerse> verses = [];

  @override
  void initState() {
    super.initState();
    if (widget.query.length == 0) {
      setState(() {
        keyword = "";
        searched = true;
        bibles = [];
        verses = [];
      });
      return;
    } else {
      _searchResults();
    }
  }

  void _searchResults() {
    BibleRepository()
      .searchBibles(widget.vcode, widget.query)
      .then((results) {
        setState(() {
          keyword = widget.query;
          searched = true;
          bibles = results;
        });
      });
    VerseRepository()
      .findByKeyword(widget.vcode, widget.query)
      .then((results) {
        setState(() {
          keyword = widget.query;
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

    if (widget.query != keyword) {
      _searchResults();
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
              fontSize: widget.fontSize,
              fontFamily: widget.fontFamily,
            )).toList()
          ),
        ),
        _VerseResultWidget(
          verses: verses,
          fontSize: widget.fontSize,
          fontFamily: widget.fontFamily,
          query: widget.query
        )
      ],
    );
  }
    
}


class _VerseResultWidget extends StatelessWidget {
  final List<SearchVerse> verses;
  final double fontSize;
  final String fontFamily;
  final String query;

  _VerseResultWidget({
    this.verses,
    this.fontSize,
    this.fontFamily,
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
                  fontFamily: toGoogleFontFamily(fontFamily),
                  fontWeight: FontWeight.bold
                )
              ),
              HighlightText(
                content: verse.content,
                keyword: query,
                fontSize: fontSize,
                fontFamily: toGoogleFontFamily(fontFamily),
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
