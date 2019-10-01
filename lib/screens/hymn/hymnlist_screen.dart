
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:holybible/components/layout.dart';
import 'package:holybible/models/hymn.dart';
import 'package:holybible/repository/hymn_repository.dart';
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
          fontSize: vm.fontSize
        );
      },
    );
  }
}

class _ViewModel {
  final double fontSize;
  _ViewModel({this.fontSize});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      fontSize: store.state.fontSize
    );
  }
}

class _HymnListWidget extends StatefulWidget {
  final double fontSize;
  _HymnListWidget({this.fontSize});

  @override
  State<StatefulWidget> createState() {
    return _HymnListState();
  }
}

class _HymnListState extends State<_HymnListWidget> {
  List<Hymn> hymns = [];

  @override
  void initState() {
    super.initState();

    HymnRepository()
      .loadHymns()
      .then((loaded) => setState(() => hymns = loaded));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          ExpandedAppBar("찬송가"),
          SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                var hymn = hymns[index];
                return ListTile(
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: '${hymn.number}.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: widget.fontSize)),
                        TextSpan(text: ' '),
                        TextSpan(text: '${hymn.title}', style: TextStyle(fontSize: widget.fontSize))
                      ],
                      style: Theme.of(context).textTheme.title
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      HymnScoreScreen.routeName,
                      arguments: HymnSoreScreenArguments(
                        number: hymn.number,
                        length: hymns.length
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
