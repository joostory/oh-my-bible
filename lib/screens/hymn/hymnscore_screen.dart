
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class HymnScoreScreen extends StatelessWidget {
  static String routeName = '/hymn/score';

  @override
  Widget build(BuildContext context) {
    HymnSoreScreenArguments args = ModalRoute.of(context).settings.arguments;
    return _HymnScoreWidget(
      selectedNumber: args.number,
      hymnCount: args.length
    );
  }
}

class HymnSoreScreenArguments {
  final int number;
  final int length;
  HymnSoreScreenArguments({
    this.number,
    this.length
  });
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
