
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuedu/db/bookShelf.dart';
import 'package:yuedu/model/bookDetailModel.dart';
import 'package:yuedu/utils/tools.dart';

class BookItemCell extends StatelessWidget {
  final BookInfo b;

  BookItemCell({Key? key, required this.b}) : super(key: key);

  Widget _coverWidget() {
    return Container(
      height: ScreenTools.getSize(315),
      width: ScreenTools.getSize(240),
      child: ExtendedImage.network(
        b.imgUrl,
        cache: true,

      ),
    );
  }

  Widget _detailWidget() {
    return Container(
      margin: EdgeInsets.only(left: ScreenTools.getSize(42)),
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
              "最新:${b.lastUpdate}",
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: ScreenTools.getSize(40)),
            ),
            margin: EdgeInsets.symmetric(vertical: ScreenTools.getSize(35)),
          ),
          Container(
            child: Row(
              children: [
                Container(
                  child: Icon(
                    Icons.access_time,
                    size: ScreenTools.getSize(35),
                  ),
                  margin: EdgeInsets.only(right: ScreenTools.getSize(15)),
                ),
                Expanded(child: Container(
                  child: Text(
                    b.updateTime,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: ScreenTools.getSize(35)),
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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        Provider.of<BookDetailModel>(context,listen: false).cleanOpenData();
        await Provider.of<BookDetailModel>(context,listen: false).openBook(b);
        Navigator.pushNamed(context, "/read");
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: ScreenTools.getSize(42),
            vertical: ScreenTools.getSize(30)),
        child: Row(
          children: [_coverWidget(), Expanded(child: _detailWidget())],
        ),
      ),
    );
  }
}
