import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuedu/db/bookShelf.dart';
import 'package:yuedu/model/bookShelfModel.dart';
import 'package:yuedu/pages/bookshelf/widget/book_item.dart';
import 'package:yuedu/utils/book_reptile.dart';
import 'package:yuedu/utils/local_storage.dart';
import 'package:yuedu/utils/tools.dart';

class BookShelfPage extends StatefulWidget {
  @override
  _BookShelfPageState createState() => _BookShelfPageState();
}

class _BookShelfPageState extends State<BookShelfPage> {
  late Timer _getNewCatalogueTimer;

  @override
  void initState() {
    super.initState();
    Provider.of<BookShelfModel>(context, listen: false).setupProvider();
    _getNewCatalogueTimer =
        new Timer.periodic(new Duration(minutes: 3), (timer) {
      LocalStorage ls = LocalStorage();
      List<BookInfo> bl =
          Provider.of<BookShelfModel>(context, listen: false).shelfBooks;
      bl.forEach((b) async {
        List<BookCatalogue> bcl =
            await ls.getAllCatalogueFromLocalStorage(b.id!);
        List<BookCatalogue> result =
            await BookReptile.getBookCatalogueWithBookInfo(b);
        if (result.length != bcl.length) {
          List<BookCatalogue> tempBcl = result.sublist(bcl.length);
          ls.insertBookCatalogueToLocalStorage(b, tempBcl);
          b.lastUpdate = tempBcl.last.title;
          Provider.of<BookShelfModel>(context, listen: false).updateBookInfo(b);
          BotToast.showSimpleNotification(
              title: "《${b.title}》有新章节", subTitle: b.lastUpdate);
        }
      });
    });
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
                  child: Text(
                    "移出书架",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                confirmDismiss: (DismissDirection direction) async {
                  Provider.of<BookShelfModel>(context, listen: false)
                      .removeBookFromShelf(
                          Provider.of<BookShelfModel>(context, listen: false)
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
  @override
  void dispose() {
    _getNewCatalogueTimer.cancel();
    super.dispose();
  }
}
