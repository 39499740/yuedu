import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:yuedu/db/bookShelf.dart';
import 'package:yuedu/utils/tools.dart';

class BookItemCell extends StatelessWidget {
  BookInfo b;

  BookItemCell({Key? key, required this.b}) : super(key: key);

  Widget _coverWidget() {
    return Container(
      child: ExtendedImage.network(
        b.imgUrl,
        cache: true,
        height: ScreenTools.getSize(105),
        width: ScreenTools.getSize(80),
      ),
    );
  }

  Widget _detailWidget() {
    return Container(
      margin: EdgeInsets.only(left: ScreenTools.getSize(15)),
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
              style: TextStyle(fontSize: ScreenTools.getSize(16)),
            ),
          ),
          Container(
            child: Text(
              "最新:${b.lastUpdate}",
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: ScreenTools.getSize(16)),
            ),
            margin: EdgeInsets.symmetric(vertical: ScreenTools.getSize(12)),
          ),
          Container(
            child: Row(
              children: [
                Container(
                  child: Icon(
                    Icons.access_time,
                    size: ScreenTools.getSize(12),
                  ),
                  margin: EdgeInsets.only(right: ScreenTools.getSize(4)),
                ),
                Expanded(child: Container(
                  child: Text(
                    b.updateTime,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: ScreenTools.getSize(14)),
                  ),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: ScreenTools.getSize(14),
          vertical: ScreenTools.getSize(10)),
      child: Row(
        children: [_coverWidget(), Expanded(child: _detailWidget())],
      ),
    );
  }
}
