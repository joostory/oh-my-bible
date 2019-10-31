import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/actions/actions.dart';
import 'package:holybible/models/version.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:redux/redux.dart';

class AppSettings extends StatelessWidget {
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
          activeColor: Theme.of(context).accentColor,
          onChanged: (useDark) {
            var store = StoreProvider.of<AppState>(context);
            store.dispatch(ChangeDarkModeAction(useDark));
          },
        )
      ],
    );
  }
}
