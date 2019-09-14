
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/components/layout.dart';
import 'package:holybible/models/verse.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:holybible/repository/bible_repository.dart';
import 'package:holybible/screens/bible/verselist_screen.dart';
import 'package:redux/redux.dart';

class SearchListScreen extends StatelessWidget {
  static String routeName = '/bible/search';

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return _SearchListWidget(vm.vcode, vm.fontSize);
      },
    );
  }
}

class _ViewModel {
  final String vcode;
  final double fontSize;

  _ViewModel(this.vcode, this.fontSize);

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      store.state.selectedVersionCode,
      store.state.fontSize
    );
  }
}

class _SearchListWidget extends StatefulWidget {
  final String vcode;
  final double fontSize;
  _SearchListWidget(this.vcode, this.fontSize);

  @override
  State<StatefulWidget> createState() => _SearchListWidgetState();
}

class _SearchListWidgetState extends State<_SearchListWidget> {
  String keyword = '';
  List<SearchVerse> verses = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          textInputAction: TextInputAction.search,
          style: TextStyle(
            color: Colors.white
          ),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: '검색',
            hintStyle: TextStyle(color: Colors.grey),
            suffixIcon: Icon(Icons.search, color: Colors.white),
            focusColor: Colors.white,
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))
          ),
          onSubmitted: (value) async {
            var repository = BibleRepository();
            var results = await repository.searchVerses(widget.vcode, value);
            setState(() {
              keyword = value;
              verses = results;
            });
          },
        ),
        actions: <Widget>[
          SettingButton()
        ],
      ),
      body: ListView.builder(
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
                    keyword: keyword,
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
      ),
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
