import 'package:flutter/material.dart';
import 'package:holybible/components/bible_search_list.dart';
import 'package:holybible/components/hymn_search_list.dart';
import 'package:holybible/components/search.dart';
import 'package:holybible/components/setting.dart';

class BibleExpandedAppBar extends _ExpandedAppBar {
  BibleExpandedAppBar(String title)
    : super(title, [
        SearchButton(),
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

