import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/actions/actions.dart';
import 'package:holybible/models/version.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:holybible/utils/font_utils.dart';
import 'package:redux/redux.dart';

class AppSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StoreConnector<AppState, _ViewModel>(
    converter: _ViewModel.fromStore,
    builder: (BuildContext context, _ViewModel vm) => Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
      child: Column(
        children: <Widget>[
          _VersionsSetting(vm.versions, vm.selectedVersionCode),
          _FontSizeSetting(vm.fontSize),
          _FontFamilySetting(vm.fontFamily),
          _ThemeSetting(vm.useDarkMode)
        ],
      ),
    )
  );
}

class _ViewModel {
  final List<Version> versions;
  final String selectedVersionCode;
  final double fontSize;
  final String fontFamily;
  final bool useDarkMode;
  _ViewModel({
    this.versions,
    this.selectedVersionCode,
    this.fontSize,
    this.fontFamily,
    this.useDarkMode
  });

  static _ViewModel fromStore(Store<AppState> store) => _ViewModel(
    versions: store.state.versions,
    selectedVersionCode: store.state.selectedVersionCode,
    fontSize: store.state.fontSize,
    fontFamily: store.state.fontFamily,
    useDarkMode: store.state.useDarkMode
  );
}


class _VersionsSetting extends StatelessWidget {
  final List<Version> versions;
  final String selectedVersionCode;
  _VersionsSetting(this.versions, this.selectedVersionCode);

  @override
  Widget build(BuildContext context) => DropdownButton(
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

class _FontSizeSetting extends StatelessWidget {
  final double fontSize;
  _FontSizeSetting(this.fontSize);

  @override
  Widget build(BuildContext context) => DropdownButton<double>(
    isExpanded: true,
    value: fontSize,
    items: FONT_SIZE_LIST.map(
      (m) => DropdownMenuItem<double>(
        child: Text(m['label']),
        value: m['value']
      )
    ).toList(),
    onChanged: (double selectedFontSize) {
      var store = StoreProvider.of<AppState>(context);
      store.dispatch(ChangeFontSizeAction(selectedFontSize));
    },
  );
}

class _FontFamilySetting extends StatelessWidget {
  final String fontFamily;
  const _FontFamilySetting(this.fontFamily);

  @override
  Widget build(BuildContext context) => DropdownButton<String>(
    isExpanded: true,
    value: fontFamily,
    items: FONT_FAMILY_LIST.map(
      (m) => DropdownMenuItem<String>(
        child: Text(
          m['label'],
          style: TextStyle(
            fontFamily: toGoogleFontFamily(m['value'])
          )
        ),
        value: m['value']
      )
    ).toList(),
    onChanged: (String selectedFontFamily) {
      print(selectedFontFamily);
      var store = StoreProvider.of<AppState>(context);
      store.dispatch(ChangeFontFamilyAction(selectedFontFamily));
    },
  );
}

class _ThemeSetting extends StatelessWidget {
  final bool useDarkMode;
  _ThemeSetting(this.useDarkMode);

  @override
  Widget build(BuildContext context) => Row(
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
