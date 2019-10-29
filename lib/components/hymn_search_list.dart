import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/models/hymn.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:holybible/repository/hymn_repository.dart';
import 'package:holybible/screens/hymn/hymnscore_screen.dart';
import 'package:redux/redux.dart';


class HymnSearchList extends StatelessWidget {
  final String query;

  HymnSearchList(this.query);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _HymnSearchViewModel>(
      converter: _HymnSearchViewModel.fromStore,
      builder: (BuildContext context, _HymnSearchViewModel vm) {
        return _HymnSearchListWidget(query, vm.fontSize);
      },
    );
  }
}

class _HymnSearchViewModel {
  final double fontSize;

  _HymnSearchViewModel(this.fontSize);

  static _HymnSearchViewModel fromStore(Store<AppState> store) {
    return _HymnSearchViewModel(
      store.state.fontSize
    );
  }
}

class _HymnSearchListWidget extends StatefulWidget {
  final String query;
  final double fontSize;

  _HymnSearchListWidget(this.query, this.fontSize);

  @override
  State<StatefulWidget> createState() => _HymnSearchListState();
}

class _HymnSearchListState extends State<_HymnSearchListWidget> {
  bool searched = false;
  List<Hymn> hymns = [];

  @override
  void initState() {
    super.initState();
    var result;

    if (int.tryParse(widget.query) != null) {
      result = HymnRepository().findByNumber(widget.query);
    } else {
      result = HymnRepository().findByKeyword(widget.query);
    }
    
    result.then((results) {
      setState(() {
        searched = true;
        hymns = results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!searched) {
      return Container(
        child: Center(
          child: CircularProgressIndicator()
        )
      );
    }

    if (hymns.length == 0) {
      return Container(
        child: Center(
          child: Text("검색 결과가 없습니다.")
        )
      );
    }

    return ListView.builder(
      itemBuilder: (context, index) {
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
              )
            );
          },
        );
      },
      itemCount: hymns.length,
    );
  }

}


