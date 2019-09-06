
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/components/list.dart';
import 'package:holybible/models/verse.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:holybible/repository/bible_repository.dart';
import 'package:holybible/screens/verselist_screen.dart';
import 'package:redux/redux.dart';

class SearchListScreen extends StatelessWidget {
  static String routeName = '/search';

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return _SearchListWidget(vm.vcode);
      },
    );
  }
}

class _ViewModel {
  final String vcode;

  _ViewModel(this.vcode);

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(store.state.selectedVersionCode);
  }
}

class _SearchListWidget extends StatefulWidget {
  final String vcode;
  _SearchListWidget(this.vcode);

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
                    '${verse.bibleName} ${verse.cnum}장 ${verse.vnum}절',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  _HighlightText(verse.content, keyword)
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
  String content;
  String keyword;

  _HighlightText(this.content, this.keyword);

  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(
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
