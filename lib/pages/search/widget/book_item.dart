import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:yuedu/db/bookShelf.dart';
import 'package:yuedu/utils/tools.dart';

class BookItemCell extends StatelessWidget {
  BookInfo b;

  BookItemCell({Key? key, required this.b}) : super(key: key);

  Widget _coverWidget() {
    return Container(
      // height: ScreenTools.getSize(240),
      // width: ScreenTools.getSize(180),
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
              style: TextStyle(fontSize: ScreenTools.getSize(40)),
            ),
            // margin: EdgeInsets.symmetric(vertical: ScreenTools.getSize(15)),
          ),
          Container(
            child: Text(
              "${b.detail}",
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: ScreenTools.getSize(40)),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenTools.getSize(345),
      padding: EdgeInsets.symmetric(
          horizontal: ScreenTools.getSize(45),
          vertical: ScreenTools.getSize(51)),
      child: Row(
        children: [_coverWidget(), Expanded(child: _detailWidget())],
      ),
    );
  }
}
