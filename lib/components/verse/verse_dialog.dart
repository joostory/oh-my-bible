import 'package:flutter/material.dart';
import 'package:holybible/actions/behaviors.dart';
import 'package:holybible/components/verse/verse_list_item.dart';
import 'package:holybible/models/bible.dart';
import 'package:holybible/models/verse.dart';
import 'package:holybible/utils/font_utils.dart';

void openVerseDialog(BuildContext context, Bible bible, Verse verse, double fontSize, String fontFamily, VerseChangeHandler onChange) {
  showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        elevation: 4.0,
        title: Text('${bible.name} ${verse.cnum} : ${verse.vnum}'),
        children: <Widget>[
          _VerseDialogDetail(
            verse: verse,
            fontSize: fontSize,
            fontFamily: fontFamily,
            onChange: onChange
          )
        ],
      );
    }
  );
}

class _VerseDialogDetail extends StatelessWidget {
  final Verse verse;
  final double fontSize;
  final String fontFamily;
  final VerseChangeHandler onChange;

  const _VerseDialogDetail({
    this.verse,
    this.fontSize,
    this.fontFamily,
    this.onChange
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
      child: Column(
        children: <Widget>[
          _VerseDialogDetailContent(
            verse: verse,
            fontSize: fontSize,
            fontFamily: fontFamily
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20.0),
          ),
          _VerseDialogDetailBookmark(
            verse: verse,
            onChange: onChange
          )
        ],
      ),
    );
  }
}

class _VerseDialogDetailContent extends StatelessWidget {
  final Verse verse;
  final double fontSize;
  final String fontFamily;

  _VerseDialogDetailContent({
    this.verse,
    this.fontSize,
    this.fontFamily
  });

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      verse.content,
      style: TextStyle(
        fontSize: fontSize,
        height: 1.5,
        fontFamily: toGoogleFontFamily(fontFamily)
      ),
    );
  }
}

class _VerseDialogDetailBookmark extends StatefulWidget {
  final Verse verse;
  final VerseChangeHandler onChange;

  _VerseDialogDetailBookmark({this.verse, this.onChange});

  @override
  State<StatefulWidget> createState() {
    return _VerseDialogDetailBookmarkState(verse.bookmarked);
  }
}

class _VerseDialogDetailBookmarkState extends State<_VerseDialogDetailBookmark> {
  bool _bookmarked;
  _VerseDialogDetailBookmarkState(this._bookmarked);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text('즐겨찾기'),
        Switch(
          value: _bookmarked,
          activeColor: Theme.of(context).accentColor,
          onChanged: (bookmarked) {
            setState(() {
              _bookmarked = bookmarked;
            });

            UpdateBookmarkBehavior(
              verse: widget.verse,
              bookmarked: bookmarked
            )
              .run()
              .then((_) {
                var cloneVerse = Verse.from(widget.verse);
                cloneVerse.bookmarked = bookmarked;
                widget.onChange(cloneVerse);
              });
          },
        )
      ],
    );
  }
}

