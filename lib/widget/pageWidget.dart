import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuedu/model/pageModel.dart';
import 'package:yuedu/utils/Paging_tools.dart';
import 'package:yuedu/utils/tools.dart';

import '../textfile.dart';

class PageWidget extends StatefulWidget {
  PageWidget({Key? key}) : super(key: key);

  @override
  _PageWidgetState createState() => _PageWidgetState();
}

class _PageWidgetState extends State<PageWidget> {
  @override
  void initState() {
    super.initState();
  }

  List<String> pageStrList = [];
  bool firstBuild = true;

  @override
  Widget build(BuildContext context) {
    if (Provider.of<PageModel>(context, listen: false).pageWidth == 0) {
      firstBuild = false;
      Timer(Duration(milliseconds: 100), () {
        Provider.of<PageModel>(context, listen: false)
            .setTextAreaWH(context.size!.width, context.size!.height);
        pageStrList = PagingTool.pagingContent(bookStr, ScreenTools.getSize(16),
            context.size!.width, context.size!.height);
        Provider.of<PageModel>(context, listen: false)
            .setupChapterData(pageStrList.length, "标题");
        setState(() {});
      });
    } else if (firstBuild) {
      pageStrList = PagingTool.pagingContent(bookStr, ScreenTools.getSize(16),
          context.size!.width, context.size!.height);
      Provider.of<PageModel>(context, listen: false)
          .setupChapterData(pageStrList.length, "标题");
      firstBuild = false;
      setState(() {});
    }
    return PageView.builder(
      itemBuilder: (context, index) {
        return Container(
          child: Text(
            Provider.of<PageModel>(context, listen: false).pageWidth == 0
                ? ""
                : pageStrList[index],
            softWrap: true,
            style: TextStyle(fontSize: ScreenTools.getSize(16), height: 2),
          ),
        );
      },
      itemCount: Provider.of<PageModel>(context, listen: false).pageWidth == 0
          ? 1
          : pageStrList.length,
      onPageChanged: (int index) {
        Provider.of<PageModel>(context, listen: false)
            .updateNowPageNum(index + 1);
      },
    );
  }
}
