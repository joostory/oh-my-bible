
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:holybible/components/app_bar.dart';
import 'package:holybible/models/hymn.dart';
import 'package:holybible/screens/hymn/hymnscore_screen.dart';
import 'package:redux/redux.dart';

class HymnListScreen extends StatelessWidget {
  static String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return _HymnListWidget(
          hymns: vm.hymns,
          fontSize: vm.fontSize
        );
      },
    );
  }
}

class _ViewModel {
  final List<Hymn> hymns;
  final double fontSize;
  _ViewModel({this.hymns, this.fontSize});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      hymns: store.state.hymns,
      fontSize: store.state.fontSize
    );
  }
}

class _HymnListWidget extends StatelessWidget {
  final List<Hymn> hymns;
  final double fontSize;
  _HymnListWidget({this.hymns, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          HymnExpandedAppBar("찬송가"),
          SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                var hymn = hymns[index];
                return ListTile(
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: '${hymn.number}.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
                        TextSpan(text: ' '),
                        TextSpan(text: '${hymn.title}', style: TextStyle(fontSize: fontSize))
                      ],
                      style: Theme.of(context).textTheme.title
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      HymnScoreScreen.routeName,
                      arguments: HymnSoreScreenArguments(
                        number: hymn.number
                      )
                    );
                  },
                );
              },
              childCount: hymns.length
            )
          )
        ],
      ),
      // bottomNavigationBar: AppNavigationBar(1),
    );
  }
}

