
import 'package:flutter/material.dart';
import 'package:holybible/components/list.dart';
import 'package:holybible/models/hymn.dart';
import 'package:holybible/repository/hymn_repository.dart';

class HymnListScreen extends StatelessWidget {
  static String routeName = '/hymn';

  @override
  Widget build(BuildContext context) {
    return _HymnListWidget();
  }
}

class _HymnListWidget extends StatefulWidget {
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
              (context, index) => ListTile(
                  title: Text(hymns[index].title),
                  onTap: () {
                    //
                  },
                ),
                childCount: hymns.length
            )
          )
        ],
      )
    );
  }
}
