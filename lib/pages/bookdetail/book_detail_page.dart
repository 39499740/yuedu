import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:extended_sliver/extended_sliver.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuedu/db/bookShelf.dart';
import 'package:yuedu/model/bookDetailModel.dart';
import 'package:yuedu/model/bookShelfModel.dart';
import 'package:yuedu/utils/book_reptile.dart';
import 'package:yuedu/utils/tools.dart';

class BookDetailPage extends StatefulWidget {
  BookDetailPage({Key? key}) : super(key: key);

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    setupCatalogue();
  }

  setupCatalogue() async {
    List<BookCatalogue> catalogueList =
        await BookReptile.getBookCatalogueWithBookInfo(
            Provider.of<BookDetailModel>(context, listen: false).openBookInfo);
    Provider.of<BookDetailModel>(context, listen: false)
        .setupCatalogue(catalogueList);

    setState(() {
      isLoading = false;
    });
  }

  Widget _bookDetailWidget() {
    print(ScreenTools.getStatusBarHeight());
    return Container(
      width: double.infinity,
      height: ScreenTools.getSize(768) + ScreenTools.getStatusBarHeight(),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: ScreenTools.getSize(840),
            alignment: Alignment.center,
            color: Colors.red,
            child: ExtendedImage.network(
              Provider.of<BookDetailModel>(context, listen: false)
                  .openBookInfo
                  .imgUrl,
              cache: true,
              fit: BoxFit.cover,
              height: ScreenTools.getSize(840),
              width: double.infinity,
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: Opacity(
              opacity: 0.5,
              child: Container(
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: ScreenTools.getStatusBarHeight(),
            child: Container(
              height: ScreenTools.getAppBarHeight(),
              child: Row(
                children: [
                  BackButton(
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: ScreenTools.getStatusBarHeight() +
                ScreenTools.getAppBarHeight(),
            bottom: 0,
            child: Container(
              alignment: Alignment.center,
              child: Container(
                height: ScreenTools.getSize(396),
                margin:
                    EdgeInsets.symmetric(horizontal: ScreenTools.getSize(42)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ExtendedImage.network(
                      Provider.of<BookDetailModel>(context, listen: false)
                          .openBookInfo
                          .imgUrl,
                      cache: true,
                      height: ScreenTools.getSize(396),
                      width: ScreenTools.getSize(297),
                    ),
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.only(left: ScreenTools.getSize(42)),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            Provider.of<BookDetailModel>(context, listen: false)
                                .openBookInfo
                                .title,
                            style: TextStyle(
                                fontSize: ScreenTools.getSize(55),
                                color: Colors.white),
                          ),
                          Text(
                            "作者：${Provider.of<BookDetailModel>(context, listen: false).openBookInfo.author}",
                            style: TextStyle(
                                fontSize: ScreenTools.getSize(45),
                                color: Colors.white),
                          ),
                          Text(
                            "类型：${Provider.of<BookDetailModel>(context, listen: false).openBookInfo.cat}",
                            style: TextStyle(
                                fontSize: ScreenTools.getSize(45),
                                color: Colors.white),
                          )
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _bookDetailTextWidget() {
    return Container(
      padding: EdgeInsets.all(ScreenTools.getSize(40)),
      child: Text(
        Provider.of<BookDetailModel>(context, listen: false)
            .openBookInfo
            .detail,
        softWrap: true,
        maxLines: 999,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: ScreenTools.getSize(40),
            height: 1.2,
            color: Color(0xff666666)),
      ),
    );
  }

  Widget _bookCatalogueWidget() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/bookDetailCatalogue");
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: ScreenTools.getSize(180),
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: ScreenTools.getSize(45)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "目录",
              style: TextStyle(
                  fontSize: ScreenTools.getSize(50),
                  color: Color(0xff333333),
                  fontWeight: FontWeight.bold),
            ),
            Text(
                isLoading
                    ? "正在加载"
                    : "共${Provider.of<BookDetailModel>(context, listen: false).openBookCatalogue.length}章",
                style: TextStyle(
                    fontSize: ScreenTools.getSize(45),
                    color: Color(0xff6666666),
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }

  Widget _bottomBar() {
    return Container(
      height: ScreenTools.getSize(180),
      child: Row(
        children: [
          Expanded(
              child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (Provider.of<BookShelfModel>(context, listen: false)
                  .isBookExist(
                      Provider.of<BookDetailModel>(context, listen: false)
                          .openBookInfo)) {
                Provider.of<BookShelfModel>(context, listen: false)
                    .removeBookFromShelf(
                    Provider.of<BookDetailModel>(context, listen: false)
                        .openBookInfo);
              } else {
                Provider.of<BookShelfModel>(context, listen: false)
                    .addBookToShelf(
                        Provider.of<BookDetailModel>(context, listen: false)
                            .openBookInfo);
              }

              setState(() {

              });
            },
            child: Container(
              color: Colors.black12,
              alignment: Alignment.center,
              child: Text(
                Provider.of<BookShelfModel>(context, listen: false).isBookExist(
                        Provider.of<BookDetailModel>(context, listen: false)
                            .openBookInfo)
                    ? "移出书架"
                    : "加入书架",
                style: TextStyle(color: Colors.red),
              ),
            ),
          )),
          Expanded(
              child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {},
            child: Container(
              color: Colors.red,
              alignment: Alignment.center,
              child: Text(
                Provider.of<BookShelfModel>(context, listen: false).isBookExist(
                        Provider.of<BookDetailModel>(context, listen: false)
                            .openBookInfo)
                    ? "继续阅读"
                    : "开始阅读",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _bookDetailWidget(),
                      _bookDetailTextWidget(),
                      _bookCatalogueWidget()
                    ],
                  ),
                ),
              ),
              _bottomBar()
            ],
          )),
    );
  }
}
