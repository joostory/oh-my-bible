
import 'package:flutter/material.dart';
import 'package:holybible/components/list.dart';
import 'package:holybible/models/bible.dart';
import 'package:holybible/screens/verselist_screen.dart';

class ChapterListScreen extends StatelessWidget {
  static String routeName = '/chapter';

  @override
  Widget build(BuildContext context) {
    ChapterListScreenArguments args = ModalRoute.of(context).settings.arguments;
    return _ChapterList(args.bible);
  }
}

class ChapterListScreenArguments {
  Bible bible;
  ChapterListScreenArguments(this.bible);
}

class _ChapterList extends StatelessWidget {
  final Bible bible;

  _ChapterList(this.bible);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          TextAppBar(bible.name),
          SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                title: Text('${bible.name} ${index + 1}'),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    VerseListScreen.routeName,
                    arguments: VerseListScreenArguments(bible, index + 1)
                  );
                },
              ),
              childCount: bible.chapterCount
            )
          )
        ],
      )
    );
  }
}

