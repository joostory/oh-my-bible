import 'package:flutter/material.dart';

class HighlightText extends StatelessWidget {
  final String content;
  final String keyword;
  final double fontSize;

  HighlightText({
    this.content,
    this.keyword,
    this.fontSize
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(
      style: TextStyle(fontSize: fontSize),
      children: _makeHighlightWidgets()
    ));
  }

  _makeHighlightWidgets() {
    List<TextSpan> contentWidgets = [];
    TextSpan keywordWidget = TextSpan(
      text: keyword,
      style: TextStyle(fontWeight: FontWeight.bold)
    );

    List<String> contents = content.split(keyword);
    contents.asMap().forEach((index, item) {
      contentWidgets.add(TextSpan(text: item));

      if (index < contents.length - 1) {
        contentWidgets.add(keywordWidget);
      }
    });

    return contentWidgets;
  }

}
