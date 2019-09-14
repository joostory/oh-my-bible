
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:holybible/models/hymn.dart';
import 'package:photo_view/photo_view.dart';

class HymnScoreScreen extends StatelessWidget {
  static String routeName = '/hymn/score';

  @override
  Widget build(BuildContext context) {
    HymnSoreScreenArguments args = ModalRoute.of(context).settings.arguments;
    return _HymnScoreWidget(args.hymn);
  }
}

class HymnSoreScreenArguments {
  final Hymn hymn;
  HymnSoreScreenArguments(this.hymn);
}

class _HymnScoreWidget extends StatelessWidget {
  final Hymn hymn;
  _HymnScoreWidget(this.hymn);

  @override
  Widget build(BuildContext context) {
    var imagePath = 'assets/hymns/newhymn-${hymn.number.toString().padLeft(3, '0')}.jpg';
    print(imagePath);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: PhotoView(
          imageProvider: AssetImage(imagePath),
          backgroundDecoration: BoxDecoration(
            color: Colors.white
          ),
        ),
      )
    );
  }
}
