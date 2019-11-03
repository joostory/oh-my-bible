import 'package:flutter/material.dart';
import 'package:holybible/models/bible.dart';
import 'package:holybible/screens/bible/chapterlist_screen.dart';

class BibleListTileWidget extends StatelessWidget {
  final Bible bible;
  final double fontSize;

  const BibleListTileWidget({
    this.bible,
    this.fontSize
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        bible.name,
        style: TextStyle(
          fontSize: fontSize
        ),
      ),
      trailing: Text(
        '${bible.chapterCount} / ${bible.getTypeLabel()}',
        style: TextStyle(
          fontSize: fontSize - 4,
          fontWeight: FontWeight.bold
        )
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          ChapterListScreen.routeName,
          arguments: ChapterListScreenArguments(
            bible.bcode
          )
        );
      },
    );
  }
}
