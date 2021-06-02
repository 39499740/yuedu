import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuedu/db/bookShelf.dart';
import 'package:yuedu/model/bookDetailModel.dart';
import 'package:yuedu/utils/tools.dart';

class BookDetailCataloguePage extends StatefulWidget {
  BookDetailCataloguePage({Key? key}) : super(key: key);

  @override
  _BookDetailCataloguePageState createState() =>
      _BookDetailCataloguePageState();
}

class _BookDetailCataloguePageState extends State<BookDetailCataloguePage> {
  Widget _listItemCell(int index) {
    return Container(
      height: ScreenTools.getSize(132),
      margin: EdgeInsets.symmetric(horizontal: ScreenTools.getSize(40)),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
              child: Text(
            Provider.of<BookDetailModel>(context, listen: true)
                .openBookCatalogue[index]
                .title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          )),
          Container(
              margin: EdgeInsets.only(left: ScreenTools.getSize(30)),
              child: Provider.of<BookDetailModel>(context, listen: true)
                          .openBookCatalogue[index]
                          .bookId ==
                      null
                  ? Container()
                  : (Provider.of<BookDetailModel>(context, listen: true)
                              .openBookCatalogue[index]
                              .content !=
                          ""
                      ? Icon(Icons.cloud_done)
                      : Icon(Icons.cloud_download_outlined)))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Color(0xff333333),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffffffff),
        elevation: 0,
        title: Text(
          "${Provider.of<BookDetailModel>(context).openBookInfo.title} 目录",
          style: TextStyle(color: Color(0xff333333)),
        ),
      ),
      body: ListView.builder(
        itemExtent: ScreenTools.getSize(132),
        padding:
            EdgeInsets.only(bottom: ScreenTools.getScreenBottomBarHeight()),
        itemBuilder: (context, index) {
          BookCatalogue bc = Provider.of<BookDetailModel>(context, listen: true)
              .openBookCatalogue[index];

          return ListTile(
            title: Text(
              bc.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: bc.bookId == null
              ?null:Container(
                width: ScreenTools.getSize(120),
                height: ScreenTools.getSize(120),
                child:bc.content != ""
                        ? Icon(Icons.cloud_done)
                        : Icon(Icons.cloud_download_outlined)),
          );
        },
        itemCount: Provider.of<BookDetailModel>(context, listen: true)
            .openBookCatalogue
            .length,
      ),
    );
  }
}
