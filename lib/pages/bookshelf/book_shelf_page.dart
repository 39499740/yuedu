import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuedu/model/bookShelfModel.dart';
import 'package:yuedu/pages/bookshelf/widget/book_item.dart';

class BookShelfPage extends StatefulWidget {
  @override
  _BookShelfPageState createState() => _BookShelfPageState();
}

class _BookShelfPageState extends State<BookShelfPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<BookShelfModel>(context, listen: false).setupProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xffffffff),
        elevation: 0,
        title: Text(
          "书架",
          style: TextStyle(color: Color(0xff333333)),
        ),
      ),
      body: Container(
        child: ListView.separated(
          itemBuilder: (context, index) {
            return BookItemCell(
                b: Provider.of<BookShelfModel>(context, listen: true)
                    .shelfBooks[index]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
          itemCount:
              Provider.of<BookShelfModel>(context, listen: true).shelfBooks.length,
        ),
      ),
    );
  }
}
