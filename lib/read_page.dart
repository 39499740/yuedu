import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuedu/model/pageModel.dart';
import 'package:yuedu/textfile.dart';
import 'package:yuedu/utils/Paging_tools.dart';
import 'package:yuedu/utils/book_reptile.dart';
import 'package:yuedu/utils/global_data.dart';
import 'package:yuedu/utils/local_storage.dart';
import 'package:yuedu/utils/tools.dart';
import 'package:yuedu/widget/pageWidget.dart';

class ReadPage extends StatefulWidget {
  const ReadPage({Key? key}) : super(key: key);

  @override
  _ReadPageState createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  GlobalData global = GlobalData();

  // List<String> pageStrList = [];

  LocalStorage ls = LocalStorage();

  @override
  void initState() {
    super.initState();
    // pageStrList = PagingTool.pagingContent(bookStr, ScreenTools.getSize(16));
    search();
  }

  late List<BookInfo> bookInfoList;

  search() async {
    bookInfoList =
    await BookReptile.getBookListWithKeyWord("唐家三少");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.yellow,
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    ls.saveBookToShelf(bookInfoList.first);
                  },
                  child: Text("存"),
                ),
                TextButton(onPressed: () {
                  var temp = ls.getShelf();
                }, child: Text("取"))
              ],
            ),
          ),
          // child: Column(
          //   children: [
          //     Container(
          //       color: Colors.red,
          //       height: ScreenTools.getSize(20),
          //     ),
          //     Expanded(child: Container(
          //       padding: EdgeInsets.all(ScreenTools.getSize(5)),
          //       child: PageWidget(),
          //     )),
          //     Container(
          //       color: Colors.blue,
          //       height: ScreenTools.getSize(20),
          //       child: Text("${Provider.of<PageModel>(context,listen: true).nowPage.toString()}/${Provider.of<PageModel>(context,listen: true).totalPage.toString()}"),
          //     )
          //   ],
          // )
        ),
      ),
    );
  }
}
