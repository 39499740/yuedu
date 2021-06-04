import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:yuedu/db/bookShelf.dart';
import 'package:yuedu/model/bookDetailModel.dart';
import 'package:yuedu/model/bookShelfModel.dart';
import 'package:yuedu/pages/bookdetail/book_detail_catalogue_page.dart';
import 'package:yuedu/pages/read/battery_widget.dart';
import 'package:yuedu/utils/tools.dart';
import 'package:yuedu/widget/pageWidget.dart';


class ReadPage extends StatefulWidget {
  ReadPage({Key? key}) : super(key: key);

  @override
  _ReadPageState createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  bool showController = false;
  ScrollController _catalogueListController = ScrollController();




  @override
  void initState() {
    super.initState();

  }

  Widget _TopBar() {
    return Container(
      color: Colors.black87,
      height: ScreenTools.getStatusBarHeight() + ScreenTools.getAppBarHeight(),
      padding: EdgeInsets.only(top: ScreenTools.getStatusBarHeight()),
      child: Container(
        child: Row(
          children: [
            BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.white,
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: ScreenTools.getSize(30)),
              child: Text(
                Provider.of<BookDetailModel>(context, listen: false)
                    .openBookInfo
                    .title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                    fontSize: ScreenTools.getSize(50), color: Colors.white),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget _bottomBar() {
    return Container(
      height: ScreenTools.getScreenBottomBarHeight() + ScreenTools.getSize(420),
      color: Colors.black87,
      padding: EdgeInsets.only(bottom: ScreenTools.getScreenBottomBarHeight()),
      child: Container(
        child: Column(
          children: [
            _catalogureControllerWidget(),
            Container(
              margin: EdgeInsets.only(top: ScreenTools.getSize(45)),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _bottomBtn(
                      Icon(
                        Icons.view_list,
                        size: ScreenTools.getSize(60),
                        color: Colors.white,
                      ),
                      "目录", () {
                    _scaffoldKey.currentState!.openDrawer();

                    WidgetsBinding.instance!.addPostFrameCallback((_){

                      _catalogueListController.jumpTo(
                          ScreenTools.getSize(132) *
                              Provider.of<BookDetailModel>(context, listen: false)
                                  .nowCatalogueIndex!);

                    });

                  })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _catalogureControllerWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ScreenTools.getSize(36)),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: ScreenTools.getSize(1), color: Colors.grey))),
      height: ScreenTools.getSize(196),
      child: Row(
        children: [
          GestureDetector(
              onTap: () {
                if (Provider.of<BookDetailModel>(context, listen: false)
                        .nowCatalogueIndex !=
                    0) {
                  Provider.of<BookDetailModel>(context, listen: false)
                      .jumpToCatalogue(
                          Provider.of<BookDetailModel>(context, listen: false)
                              .nowCatalogueIndex!);
                  Provider.of<BookShelfModel>(context, listen: false)
                      .updateBookInfo(
                          Provider.of<BookDetailModel>(context, listen: false)
                              .openBookInfo);
                }
              },
              behavior: HitTestBehavior.translucent,
              child: Container(
                child: Text(
                  "上一章",
                  style: TextStyle(
                      fontSize: ScreenTools.getSize(45),
                      color: Provider.of<BookDetailModel>(context, listen: true)
                                  .nowCatalogueIndex ==
                              0
                          ? Colors.grey
                          : Colors.white),
                ),
              )),
          Expanded(
              child: Container(
            child: Slider(
              min: 1,
              max: Provider.of<BookDetailModel>(context, listen: true)
                      .openBookCatalogue
                      .length *
                  1.0,
              divisions: Provider.of<BookDetailModel>(context, listen: true)
                  .openBookCatalogue
                  .length,
              value: Provider.of<BookDetailModel>(context, listen: true)
                  .catalogureSliderValue,
              label: Provider.of<BookDetailModel>(context, listen: true)
                  .catalogureSliderValue
                  .toStringAsFixed(0),
              onChanged: (v) {
                Provider.of<BookDetailModel>(context, listen: false)
                    .updateSliderValue(v);
              },
              onChangeEnd: (v) {
                Provider.of<BookDetailModel>(context, listen: false)
                    .jumpToCatalogue(v.toInt());
                Provider.of<BookShelfModel>(context, listen: false)
                    .updateBookInfo(
                        Provider.of<BookDetailModel>(context, listen: false)
                            .openBookInfo);
              },
            ),
          )),
          GestureDetector(
              onTap: () {
                if (Provider.of<BookDetailModel>(context, listen: false)
                        .nowCatalogueIndex !=
                    Provider.of<BookDetailModel>(context, listen: false)
                            .openBookCatalogue
                            .length -
                        1) {
                  Provider.of<BookDetailModel>(context, listen: false)
                      .jumpToCatalogue(
                          Provider.of<BookDetailModel>(context, listen: false)
                                  .nowCatalogueIndex! +
                              2);
                  Provider.of<BookShelfModel>(context, listen: false)
                      .updateBookInfo(
                          Provider.of<BookDetailModel>(context, listen: false)
                              .openBookInfo);
                }
              },
              behavior: HitTestBehavior.translucent,
              child: Container(
                child: Text(
                  "下一章",
                  style: TextStyle(
                      fontSize: ScreenTools.getSize(45),
                      color: Provider.of<BookDetailModel>(context, listen: true)
                                  .nowCatalogueIndex ==
                              Provider.of<BookDetailModel>(context,
                                          listen: true)
                                      .openBookCatalogue
                                      .length -
                                  1
                          ? Colors.grey
                          : Colors.white),
                ),
              ))
        ],
      ),
    );
  }

  Widget _bottomBtn(Icon btnIcon, String title, Function func) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        func();
      },
      child: Container(
        height: ScreenTools.getSize(160),
        width: ScreenTools.getSize(160),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: btnIcon,
            ),
            Container(
              child: Text(
                title,
                style: TextStyle(
                    fontSize: ScreenTools.getSize(40), color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _catalogueDrawer(),
      key: _scaffoldKey,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: ScreenTools.getSize(28)),
                  alignment: Alignment.centerLeft,
                  height: ScreenTools.getSize(106),
                  width: double.infinity,
                  child: AutoSizeText(
                    Provider.of<BookDetailModel>(context, listen: true)
                                .nowCatalogueIndex ==
                            null
                        ? ""
                        : Provider.of<BookDetailModel>(context, listen: true)
                            .openBookCatalogue[Provider.of<BookDetailModel>(
                                    context,
                                    listen: true)
                                .nowCatalogueIndex!]
                            .title,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: ScreenTools.getSize(47),
                        fontWeight: FontWeight.w200),
                  ),
                ),
                Expanded(
                    child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenTools.getSize(45)),
                      child: PageWidget(),
                    ),
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                              child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              Provider.of<BookDetailModel>(context,
                                      listen: false)
                                  .pageTurning(false);
                              Provider.of<BookShelfModel>(context,
                                      listen: false)
                                  .updateBookInfo(Provider.of<BookDetailModel>(
                                          context,
                                          listen: false)
                                      .openBookInfo);
                            },
                            child: Container(),
                          )),
                          Expanded(
                              child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              setState(() {
                                showController = true;
                              });
                            },
                            child: Container(),
                          )),
                          Expanded(
                              child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    Provider.of<BookDetailModel>(context,
                                            listen: false)
                                        .pageTurning(true);
                                    Provider.of<BookShelfModel>(context,
                                            listen: false)
                                        .updateBookInfo(
                                            Provider.of<BookDetailModel>(
                                                    context,
                                                    listen: false)
                                                .openBookInfo);
                                  },
                                  child: Container()))
                        ],
                      ),
                    )
                  ],
                )),
                Container(
                  height: ScreenTools.getSize(99),
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: ScreenTools.getSize(45)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            BatteryWidget(),
                            Container(
                              margin: EdgeInsets.only(
                                  left: ScreenTools.getSize(40)),
                              child: Text(Provider.of<BookDetailModel>(context,
                                      listen: true)
                                  .dateTimeShow),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Provider.of<BookDetailModel>(context,
                                        listen: true)
                                    .totalPage ==
                                null
                            ? Container()
                            : Text(
                                "${Provider.of<BookDetailModel>(context, listen: true).nowPage}/${Provider.of<BookDetailModel>(context, listen: true).totalPage}页"),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Offstage(
            offstage: !showController,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                children: [
                  _TopBar(),
                  Expanded(
                      child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      setState(() {
                        showController = false;
                      });
                    },
                  )),
                  _bottomBar()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _catalogueDrawer() {
    return Drawer(
      child: SafeArea(
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: ScreenTools.getSize(132)),
          itemExtent: ScreenTools.getSize(132),
          controller: _catalogueListController,
          itemBuilder: (context, index) {
            BookCatalogue bc =
                Provider.of<BookDetailModel>(context, listen: true)
                    .openBookCatalogue[index];

            return ListTile(
              onTap: () {
                Provider.of<BookDetailModel>(context, listen: false)
                    .jumpToCatalogue(index + 1);
                Provider.of<BookShelfModel>(context, listen: false)
                    .updateBookInfo(
                        Provider.of<BookDetailModel>(context, listen: false)
                            .openBookInfo);
                Navigator.of(context).pop();
              },
              title: AutoSizeText(
                bc.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: ScreenTools.getSize(30),
                    fontWeight:
                        Provider.of<BookDetailModel>(context, listen: false)
                                    .nowCatalogueIndex ==
                                index
                            ? FontWeight.bold
                            : FontWeight.w200),
              ),
              trailing: bc.bookId == null
                  ? null
                  : Container(
                      width: ScreenTools.getSize(60),
                      height: ScreenTools.getSize(60),
                      child: bc.content != ""
                          ? Icon(Icons.cloud_done)
                          : Icon(Icons.cloud_download_outlined)),
            );
          },
          itemCount: Provider.of<BookDetailModel>(context, listen: true)
              .openBookCatalogue
              .length,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
