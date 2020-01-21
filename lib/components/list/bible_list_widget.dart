import 'package:flutter/material.dart';
import 'package:holybible/models/bible.dart';
import 'package:holybible/screens/bible/chapterlist_screen.dart';
import 'package:holybible/utils/font_utils.dart';

class BibleListTileWidget extends StatelessWidget {
  final Bible bible;
  final double fontSize;
  final String fontFamily;

  const BibleListTileWidget({
    this.bible,
    this.fontSize,
    this.fontFamily
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        bible.name,
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: toGoogleFontFamily(fontFamily)
        ),
      ),
      trailing: Text(
        '${bible.chapterCount} / ${bible.getTypeLabel()}',
        style: TextStyle(
          fontSize: fontSize - 4,
          fontWeight: FontWeight.bold,
          fontFamily: toGoogleFontFamily(fontFamily)
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
