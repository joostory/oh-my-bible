import 'package:flutter/material.dart';
import 'package:holybible/components/verse/verse_dialog.dart';
import 'package:holybible/models/bible.dart';
import 'package:holybible/models/verse.dart';


typedef VerseChangeHandler = void Function(Verse verse);

class VerseListitem extends StatelessWidget {
  final Bible bible;
  final Verse verse;
  final double fontSize;
  final VerseChangeHandler onChange;

  VerseListitem({this.bible, this.verse, this.fontSize, this.onChange});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _VerseButtons(verse, fontSize),
        GestureDetector(
          child: _VerseContent(verse, fontSize),
          onTap: () {
            openVerseDialog(context, bible, verse, fontSize, onChange);
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

  _VerseContent(this.verse, this.fontSize);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.only(
                top: fontSize / 4,
                right: 8.0
              ),
              child: Text(
                '${verse.vnum}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize - fontSize / 4
                ),
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: Container(
              child: Text(
                verse.content,
                style: TextStyle(
                  fontSize: fontSize
                ),
              ),
            )
          )
        ],
      ),
      padding: EdgeInsets.fromLTRB(15.0, 3.0, 20.0, 3.0)
    );
  }
}

