import 'package:flutter/material.dart';

class TextAppBar extends StatelessWidget {
  final String _title;

  TextAppBar(this._title);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: false,
      pinned: true,
      snap: false,
      expandedHeight: 100.0,
      flexibleSpace: FlexibleSpaceBar(
          title: Text(_title),
          centerTitle: true
      ),
      backgroundColor: Color.fromRGBO(64, 64, 64, 0.9),
    );
  }
}