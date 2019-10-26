import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/actions/actions.dart';
import 'package:holybible/models/version.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:holybible/screens/bible/searchlist_screen.dart';
import 'package:redux/redux.dart';

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
        // SearchHymnButton(),
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
          delegate: _SearchHymnDelegate()
        );
      },
    );
  }
}

class _SearchHymnDelegate extends SearchDelegate {

  _SearchHymnDelegate()
    : super(
      searchFieldLabel: "찬송가",
      keyboardType: TextInputType.text
    );

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(
      icon: Icon(Icons.clear),
      onPressed: () {
        query = '';
      },
    ),
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () {
      close(context, null);
    },
  );

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(child: CircularProgressIndicator()),
                ]
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }
}

class SearchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: () {
        Navigator.pushNamed(
          context,
          SearchListScreen.routeName,
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
                _AppSettings()
              ],
            );
          }
        );
      },
    );
  }
}


class _AppSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
          child: Column(
            children: <Widget>[
              _VersionsSetting(vm.versions, vm.selectedVersionCode),
              _FontSizeSetting(vm.fontSize),
              _ThemeSetting(vm.useDarkMode)
            ],
          ),
        );
      },
    );
  }
}

class _ViewModel {
  final List<Version> versions;
  final String selectedVersionCode;
  final double fontSize;
  final bool useDarkMode;
  _ViewModel({
    this.versions,
    this.selectedVersionCode,
    this.fontSize,
    this.useDarkMode
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      versions: store.state.versions,
      selectedVersionCode: store.state.selectedVersionCode,
      fontSize: store.state.fontSize,
      useDarkMode: store.state.useDarkMode
    );
  }
}


class _VersionsSetting extends StatelessWidget {
  final List<Version> versions;
  final String selectedVersionCode;
  _VersionsSetting(this.versions, this.selectedVersionCode);

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      isExpanded: true,
      value: versions.firstWhere((version) => version.vcode == selectedVersionCode),
      items: versions.map((version) => DropdownMenuItem(
        child: Text(version.name),
        value: version,
      )).toList(),
      onChanged: (Version version) {
        var store = StoreProvider.of<AppState>(context);
        store.dispatch(ChangeSelectedVersionAction(version));
      },
    );
  }
}

class _FontSizeSetting extends StatelessWidget {
  final List<double> fontSizeList = [14.0, 16.0, 24.0];
  final double fontSize;
  _FontSizeSetting(this.fontSize);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<double>(
      isExpanded: true,
      value: fontSize,
      items: [
        DropdownMenuItem<double>(child: Text('텍스트 작게'), value: 14.0),
        DropdownMenuItem<double>(child: Text('텍스트 기본 크기'), value: 16.0),
        DropdownMenuItem<double>(child: Text('텍스트 크게'), value: 20.0),
        DropdownMenuItem<double>(child: Text('텍스트 아주 크게'), value: 24.0),
      ],
      onChanged: (double selectedFontSize) {
        var store = StoreProvider.of<AppState>(context);
        store.dispatch(ChangeFontSizeAction(selectedFontSize));
      },
    );
  }
}

class _ThemeSetting extends StatelessWidget {
  final bool useDarkMode;
  _ThemeSetting(this.useDarkMode);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text('다크모드'),
        Switch(
          value: useDarkMode,
          onChanged: (useDark) {
            var store = StoreProvider.of<AppState>(context);
            store.dispatch(ChangeDarkModeAction(useDark));
          },
        )
      ],
    );
  }
}


