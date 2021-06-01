import 'package:flutter/material.dart';
import 'package:yuedu/pages/bookshelf/book_shelf_page.dart';
import 'package:yuedu/pages/search/search_page.dart';

class TabPage extends StatefulWidget {
  TabPage({Key? key}) : super(key: key);

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _currentIndex = 0;
  List<Widget> _pageList = [
    BookShelfPage(),
    SearchPage(),
    BookShelfPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageList[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.amp_stories), label: "书架"),
          BottomNavigationBarItem(icon: Icon(Icons.wb_cloudy), label: "搜书"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "我的")
        ],
      ),
    );
  }
}