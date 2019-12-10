import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/components/verse/verse_list.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:redux/redux.dart';

class VerseListScreen extends StatelessWidget {
  static String routeName = '/bible/verse';

  @override
  Widget build(BuildContext context) {
    VerseListScreenArguments args = ModalRoute.of(context).settings.arguments;
    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return VerseListWidget(
          vcode: vm.selectedVersion,
          bcode: args.bcode,
          selectedChapter: args.cnum,
          fontSize: vm.fontSize
        );
      },
    );
  }
}

class VerseListScreenArguments {
  int bcode;
  int cnum;
  VerseListScreenArguments({
    this.bcode,
    this.cnum
  });
}

class _ViewModel {
  final String selectedVersion;
  final double fontSize;
  _ViewModel(this.selectedVersion, this.fontSize);

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(store.state.selectedVersionCode, store.state.fontSize);
  }
}
