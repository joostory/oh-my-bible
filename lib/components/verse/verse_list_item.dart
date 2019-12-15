import 'package:flutter/material.dart';
import 'package:holybible/components/verse/verse_dialog.dart';
import 'package:holybible/models/bible.dart';
import 'package:holybible/models/verse.dart';
import 'package:holybible/utils/font_utils.dart';


typedef VerseChangeHandler = void Function(Verse verse);

class VerseListItem extends StatelessWidget {
  final Bible bible;
  final Verse verse;
  final double fontSize;
  final String fontFamily;
  final VerseChangeHandler onChange;

  VerseListItem({
    this.bible,
    this.verse,
    this.fontSize,
    this.fontFamily,
    this.onChange
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _VerseButtons(verse, fontSize),
        GestureDetector(
          child: _VerseContent(verse, fontSize, fontFamily),
          onTap: () {
            openVerseDialog(context, bible, verse, fontSize, fontFamily, onChange);
          },
        ),
        
      ],
    );
  }
}

class _VerseButtons extends StatelessWidget {
  final Verse verse;
  final double fontSize;

  _VerseButtons(this.verse, this.fontSize);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: fontSize / 4,
      left: 0.0,
      child: _VerseBookmarkButton(
        bookmarked: verse.bookmarked,
        size: fontSize
      ),
    );
  }
}

class _VerseBookmarkButton extends StatelessWidget {
  final bool bookmarked;
  final double size;

  const _VerseBookmarkButton({this.bookmarked, this.size});

  @override
  Widget build(BuildContext context) {
    if (!bookmarked) {
      return Container();
    }

    return RotatedBox(
      child: Icon(Icons.bookmark,
        color: Theme.of(context).accentColor,
        size: size,
      ),
      quarterTurns: 3,
    );
  }
}

class _VerseContent extends StatelessWidget {
  final Verse verse;
  final double fontSize;
  final String fontFamily;

  _VerseContent(this.verse, this.fontSize, this.fontFamily);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: _buildVerseNumber(),
          ),
          Expanded(
            flex: 9,
            child: _buildVerseText()
          )
        ],
      ),
      padding: EdgeInsets.fromLTRB(15.0, 3.0, 20.0, 3.0)
    );
  }

  Widget _buildVerseNumber() => Container(
    alignment: Alignment.topRight,
    padding: EdgeInsets.only(
      top: fontSize / 4,
      right: 8.0
    ),
    child: Text(
      '${verse.vnum}',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: fontSize - fontSize / 4,
        fontFamily: toGoogleFontFamily(fontFamily)
      ),
    ),
  );

  Widget _buildVerseText() => Container(
    child: Text(
      verse.content,
      style: TextStyle(
        fontSize: fontSize,
        height: 1.5,
        fontFamily: toGoogleFontFamily(fontFamily)
      ),
    ),
  );
}

