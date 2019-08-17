import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/actions/actions.dart';
import 'package:holybible/components/list.dart';
import 'package:holybible/models/bible.dart';
import 'package:holybible/models/verse.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:redux/redux.dart';

class VerseListScreen extends StatelessWidget {
  static String routeName = '/verse';

  @override
  Widget build(BuildContext context) {
    VerseListScreenArguments args = ModalRoute.of(context).settings.arguments;

    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return _VerseList(args.bible, args.cnum, vm.verses);
      },
      onInit: (store) => store.dispatch(LoadVerseListAction(
          args.bible, args.cnum
      )),
    );
  }

}

class VerseListScreenArguments {
  Bible bible;
  int cnum;
  VerseListScreenArguments(this.bible, this.cnum);
}

class _ViewModel {
  List<Verse> verses;

  _ViewModel(this.verses);

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(store.state.verses);
  }
}


class _VerseList extends StatelessWidget {
  final Bible bible;
  final int cnum;
  final List<Verse> verses;

  _VerseList(this.bible, this.cnum, this.verses);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          TextAppBar('${bible.name} $cnum'),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Container(
                child: Text('${index + 1} ${verses[index].content}'),
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0
                ),
                margin: EdgeInsets.symmetric(
                  vertical: 5.0,
                ),
              ),
              childCount: verses.length
            ),
          )
        ],
      )
    );
  }
}
