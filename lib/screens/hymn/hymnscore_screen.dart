
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/models/hymn.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:photo_view/photo_view.dart';
import 'package:redux/redux.dart';
import 'package:wakelock/wakelock.dart';

class HymnScoreScreen extends StatelessWidget {
  static String routeName = '/hymn/score';

  @override
  Widget build(BuildContext context) {
    HymnSoreScreenArguments args = ModalRoute.of(context).settings.arguments;
    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return _HymnScoreWidget(
          selectedNumber: args.number,
          hymnCount: vm.hymns.length,
        );
      },
    );
  }
}

class HymnSoreScreenArguments {
  final int number;
  HymnSoreScreenArguments({
    this.number
  });
}

class _ViewModel {
  final List<Hymn> hymns;
  _ViewModel({this.hymns});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      hymns: store.state.hymns
    );
  }
}

class _HymnScoreWidget extends StatefulWidget {
  final int selectedNumber;
  final int hymnCount;
  _HymnScoreWidget({
    this.selectedNumber,
    this.hymnCount
  });

  @override
  State<StatefulWidget> createState() {
    return _HymnScoreState(
      selectedIndex: selectedNumber - 1,
    );
  }
}

class _HymnScoreState extends State<_HymnScoreWidget> {
  int selectedIndex;
  _HymnScoreState({
    this.selectedIndex,
  });

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PageView.builder(
        controller: PageController(
          initialPage: selectedIndex
        ),
        itemBuilder: (BuildContext context, int index) => _HymnScorePostView(
          index + 1
        ),
        itemCount: widget.hymnCount,
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },

      )
    );
  }
}

class _HymnScorePostView extends StatelessWidget {
  final int number;
  _HymnScorePostView(this.number);

  @override
  Widget build(BuildContext context) {
    var imagePath = 'assets/hymns/newhymn-${number.toString().padLeft(3, '0')}.jpg';
    return Container(
      child: PhotoView(
        imageProvider: AssetImage(imagePath),
        backgroundDecoration: BoxDecoration(
          color: Colors.white
        ),
      )
    );
  }
}
