import 'package:flutter/material.dart';
import 'package:holybible/components/bible_search_list.dart';
import 'package:holybible/components/hymn_search_list.dart';
import 'package:holybible/components/search.dart';
import 'package:holybible/components/setting.dart';
import 'package:holybible/components/verse/bookmark_list.dart';

class BibleExpandedAppBar extends _ExpandedAppBar {
  BibleExpandedAppBar(String title)
    : super(title, [
        SearchButton(),
        BookmarkButton(),
        SettingButton()
      ]);
}

class HymnExpandedAppBar extends _ExpandedAppBar {
  HymnExpandedAppBar(String title)
    : super(title, [
        SearchHymnButton(),
        SettingButton()
      ]);
}

class _ExpandedAppBar extends StatelessWidget {
  final String _title;
  final List<Widget> _actions;

  _ExpandedAppBar(this._title, this._actions);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: false,
      pinned: true,
      snap: false,
      expandedHeight: 100.0,
      flexibleSpace: FlexibleSpaceBar(
          title: Text(_title),
          centerTitle: true
      ),
      actions: _actions,
    );
  }
}

class SearchHymnButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: () {
        showSearch(
          context: context,
          delegate: AppSearchDelegate(
            hint: "찬송가",
            searchResultWidgetCreator: (String query) => HymnSearchList(query),
          )
        );
      },
    );
  }
}

class BookmarkButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.bookmark_border),
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) {
            return SimpleDialog(
              title: Text('즐겨찾기'),
              elevation: 4.0,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: VerseBookmarkList(context),
                )
              ],
            );
          }
        );
      },
    );
  }
}

class SearchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: () {
        showSearch(
          context: context,
          delegate: AppSearchDelegate(
            hint: "성경",
            searchResultWidgetCreator: (String query) => BibleSearchList(query),
          )
        );
      },
    );
  }
}

class SettingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.tune),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text('설정'),
              elevation: 4.0,
              children: [
                AppSettings()
              ],
            );
          }
        );
      },
    );
  }
}

