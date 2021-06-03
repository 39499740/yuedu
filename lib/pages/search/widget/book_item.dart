import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuedu/db/bookShelf.dart';
import 'package:yuedu/model/bookDetailModel.dart';
import 'package:yuedu/model/bookShelfModel.dart';
import 'package:yuedu/utils/tools.dart';

class BookItemCell extends StatelessWidget {
  BookInfo b;

  BookItemCell({Key? key, required this.b}) : super(key: key);

  Widget _coverWidget() {
    return Container(
      height: ScreenTools.getSize(240),
      width: ScreenTools.getSize(180),
      child: ExtendedImage.network(
        b.imgUrl,
        cache: true,
      ),
    );
  }

  Widget _detailWidget() {
    return Container(
      margin: EdgeInsets.only(left: ScreenTools.getSize(30)),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              b.title,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: ScreenTools.getSize(50)),
            ),
          ),
          Container(
            child: Text(
              "${b.cat} | ${b.author}",
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: ScreenTools.getSize(35)),
            ),
            // margin: EdgeInsets.symmetric(vertical: ScreenTools.getSize(15)),
          ),
          Container(
            child: Text(
              "${b.detail}",
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: ScreenTools.getSize(35)),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<BookDetailModel>(context,listen: false).cleanOpenData();
        BookInfo tempBook = Provider.of<BookShelfModel>(context, listen: false)
            .getBookInfoWithLink(b.link);
        if (tempBook.id != null) {
          Provider.of<BookDetailModel>(context, listen: false)
              .openBook(tempBook);
        } else {
          Provider.of<BookDetailModel>(context, listen: false).openBook(b);
        }
        Navigator.pushNamed(
          context,
          "/bookDetail",
        );
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: ScreenTools.getSize(345),
        padding: EdgeInsets.symmetric(
            horizontal: ScreenTools.getSize(45),
            vertical: ScreenTools.getSize(51)),
        child: Row(
          children: [_coverWidget(), Expanded(child: _detailWidget())],
        ),
      ),
    );
  }
}
