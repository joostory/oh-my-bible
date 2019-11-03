import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/components/app_bar.dart';
import 'package:holybible/components/list/bible_list_widget.dart';
import 'package:holybible/models/bible.dart';
import 'package:holybible/models/version.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:holybible/repository/bible_repository.dart';
import 'package:redux/redux.dart';

class BibleListScreen extends StatelessWidget {
  static String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return _BibleListWidget(
          vm.selectedVersion,
          vm.fontSize
        );
      },
    );
  }
}


class _ViewModel {
  final Version selectedVersion;
  final double fontSize;
  _ViewModel({this.selectedVersion, this.fontSize});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      selectedVersion: store.state.versions.firstWhere(
        (version) => version.vcode == store.state.selectedVersionCode
      ),
      fontSize: store.state.fontSize
    );
  }
}

class _BibleListWidget extends StatefulWidget {
  final Version version;
  final double fontSize;

  _BibleListWidget(this.version, this.fontSize);

  @override
  State<StatefulWidget> createState() => _BibleListWidgetState();
}

class _BibleListWidgetState extends State<_BibleListWidget> {
  List<Bible> bibles = [];

  _BibleListWidgetState();

  @override
  initState() {
    super.initState();
    loadBibles();
  }

  @override
  didUpdateWidget(_BibleListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.version.vcode != oldWidget.version.vcode) {
      loadBibles();
    }
  }

  loadBibles() {
    BibleRepository()
      .loadBibles(widget.version.vcode)
      .then((loadedBibles) => setState(() => bibles = loadedBibles));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          BibleExpandedAppBar(widget.version.name),
          SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: SliverChildBuilderDelegate(
              (context, index) => BibleListTileWidget(
                bible: bibles[index],
                fontSize: widget.fontSize
              ),
              childCount: bibles.length
            )
          )
        ],
      ),
      // bottomNavigationBar: AppNavigationBar(0),
    );
  }
}

