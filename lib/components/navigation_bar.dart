import 'package:flutter/material.dart';

class AppNavigationItem {
  IconData icon;
  String title;
  Widget app;

  AppNavigationItem({this.icon, this.title, this.app});
}

class AppNavigationBar extends StatelessWidget {
  final int _currentIndex;
  final Function(int) _onChange;
  final List<AppNavigationItem> _items;

  AppNavigationBar({index, onChange, items})
    : _currentIndex = index,
      _onChange = onChange,
      _items = items;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      items: _items.map((item) => BottomNavigationBarItem(
        icon: Icon(item.icon),
        title: Text(item.title)
      )).toList(),
      onTap: this._onChange,
    );
  }
  
}
