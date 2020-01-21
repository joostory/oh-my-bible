
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/components/app_bar.dart';
import 'package:holybible/models/bible.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:holybible/repository/bible_repository.dart';
import 'package:holybible/screens/bible/verselist_screen.dart';
import 'package:holybible/utils/font_utils.dart';
import 'package:redux/redux.dart';

class ChapterListScreen extends StatelessWidget {
  static String routeName = '/bible/chapter';

  @override
  Widget build(BuildContext context) {
    ChapterListScreenArguments args = ModalRoute.of(context).settings.arguments;
    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return _ChapterList(
          vcode: vm.selectedVersionCode,
          bcode: args.bcode,
          fontSize: vm.fontSize,
          fontFamily: vm.fontFamily
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
  final String selectedVersionCode;
  final double fontSize;
  final String fontFamily;

  _ViewModel({
    this.selectedVersionCode,
    this.fontSize,
    this.fontFamily
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      selectedVersionCode: store.state.selectedVersionCode,
      fontSize: store.state.fontSize,
      fontFamily: store.state.fontFamily
    );
  }
}

class _ChapterList extends StatefulWidget {
  final String vcode;
  final int bcode;
  final double fontSize;
  final String fontFamily;

  _ChapterList({
    this.vcode,
    this.bcode,
    this.fontSize,
    this.fontFamily
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

  _loadBible() {
    BibleRepository()
      .find(widget.vcode, widget.bcode)
      .then((loadBible) {
        setState(() {
          bible = loadBible;
        });
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
          BibleExpandedAppBar(bible.name),
          SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                title: Text(
                  '${bible.name} ${index + 1}',
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    fontFamily: toGoogleFontFamily(widget.fontFamily)
                  )
                ),
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