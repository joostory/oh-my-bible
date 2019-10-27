import 'package:flutter/material.dart';

typedef SearchWidgetCreator = Widget Function(String query);

class AppSearchDelegate extends SearchDelegate {

  final SearchWidgetCreator searchResultWidgetCreator;

  AppSearchDelegate({
    this.searchResultWidgetCreator,
    String hint = ""
  }): super(
    searchFieldLabel: hint,
    keyboardType: TextInputType.text
  );

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(
      icon: Icon(Icons.clear),
      onPressed: () {
        query = '';
      },
    ),
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () {
      close(context, null);
    },
  );

  @override
  Widget buildResults(BuildContext context) => searchResultWidgetCreator(query);

  @override
  Widget buildSuggestions(BuildContext context) => Column();
}

