import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/actions/actions.dart';
import 'package:holybible/models/version.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:holybible/screens/searchlist_screen.dart';
import 'package:redux/redux.dart';

class ExpandedAppBar extends StatelessWidget {
  final String _title;

  ExpandedAppBar(this._title);

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
      backgroundColor: Color.fromRGBO(64, 64, 64, 0.9),
      actions: createAppBarActions(context),
    );
  }
}

List<Widget> createAppBarActions(context) => [
  IconButton(
    icon: Icon(Icons.search),
    onPressed: () {
      Navigator.pushNamed(
        context,
        SearchListScreen.routeName,
      );
    },
  ),
  IconButton(
    icon: Icon(Icons.tune),
    onPressed: () {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text('설정'),
              elevation: 4.0,
              children: [
                AppBarPopupSettings()
              ],
            );
          }
      );
    },
  )
];


class AppBarPopupSettings extends StatelessWidget {
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
              _FontSizeSetting(vm.fontSize)
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
  _ViewModel({
    this.versions,
    this.selectedVersionCode,
    this.fontSize
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
        versions: store.state.versions,
        selectedVersionCode: store.state.selectedVersionCode,
        fontSize: store.state.fontSize
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
