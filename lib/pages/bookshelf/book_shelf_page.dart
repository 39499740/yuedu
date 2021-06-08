import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuedu/model/bookShelfModel.dart';
import 'package:yuedu/pages/bookshelf/widget/book_item.dart';
import 'package:yuedu/utils/tools.dart';

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
            return Dismissible(
              background: Container(
                alignment: Alignment.centerRight,
                color: Colors.red,
                padding: EdgeInsets.only(right: ScreenTools.getSize(50)),
                child: Text("移出书架",style: TextStyle(color: Colors.white),),

              ),
                confirmDismiss: (DismissDirection direction) async {
                  Provider.of<BookShelfModel>(context,listen: false).removeBookFromShelf(Provider.of<BookShelfModel>(context, listen: false)
                      .shelfBooks[index]);
                },
                key: ValueKey(index),
                child: BookItemCell(
                    b: Provider.of<BookShelfModel>(context, listen: false)
                        .shelfBooks[index]));
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
          itemCount: Provider.of<BookShelfModel>(context, listen: true)
              .shelfBooks
              .length,
        ),
      ),
    );
  }
}
