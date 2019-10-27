import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/models/verse.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:holybible/repository/bible_repository.dart';
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
  List<SearchVerse> verses = [];

  @override
  void initState() {
    super.initState();
    BibleRepository()
      .searchVerses(widget.vcode, widget.query)
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
      return Container(
        child: Center(
          child: CircularProgressIndicator()
        )
      );
    }

    if (verses.length == 0) {
      return Container(
        child: Center(
          child: Text("검색 결과가 없습니다.")
        )
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(
        top: 15.0,
        bottom: 15.0
      ),
      itemBuilder: (context, index) {
        var verse = verses[index];
        return ListTile(
          title: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${verse.bibleName} ${verse.cnum} : ${verse.vnum}',
                  style: TextStyle(
                    fontSize: widget.fontSize - 4.0,
                    fontWeight: FontWeight.bold
                  )
                ),
                _HighlightText(
                  content: verse.content,
                  keyword: widget.query,
                  fontSize: widget.fontSize
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
        );
      },
      itemCount: verses.length,
    );
  }
}

class _HighlightText extends StatelessWidget {
  final String content;
  final String keyword;
  final double fontSize;

  _HighlightText({
    this.content,
    this.keyword,
    this.fontSize
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(
      style: TextStyle(fontSize: fontSize),
      children: _makeHighlightWidgets()
    ));
  }

  _makeHighlightWidgets() {
    List<TextSpan> contentWidgets = [];
    TextSpan keywordWidget = TextSpan(
      text: keyword,
      style: TextStyle(fontWeight: FontWeight.bold)
    );

    List<String> contents = content.split(keyword);
    contents.asMap().forEach((index, item) {
      contentWidgets.add(TextSpan(text: item));

      if (index < contents.length - 1) {
        contentWidgets.add(keywordWidget);
      }
    });

    return contentWidgets;
  }

}
