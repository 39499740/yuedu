import 'package:flutter/material.dart';
import 'package:yuedu/utils/global_data.dart';
import 'package:yuedu/utils/tools.dart';

class PagingTool {
  static List<String> pagingContent(
      String content, double textSize, width, height) {
    List<String> pageList = [];
    int count = 1;
    bool getCount = false;
    while (true) {
      if (count > content.length) {
        pageList.add(content);
        break;
      }
      final painter = TextPainter(
          text: TextSpan(
            text: content.substring(0, count),
            style: TextStyle(fontSize: textSize, height: 2),
          ),
          textDirection: TextDirection.ltr);
      painter.layout(minWidth: width, maxWidth: width);
      if (painter.size.height > height) {
        count--;
        getCount = true;
      } else {
        if (getCount) {
          pageList.add(content.substring(0, count));
          content = content.substring(count);
          getCount = false;
        }
        count++;
      }
    }
    return pageList;
  }

  static int maxChineseCharCount(
      double width, double maxHeight, double textSize) {
    GlobalData global = GlobalData();
    int count = 1;
    while (true) {
      final painter = TextPainter(
        text: TextSpan(
          text: "一" * count,
          style: TextStyle(
            fontSize: textSize,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      painter.layout(minWidth: width, maxWidth: width);
      if (painter.size.height > maxHeight) {
        return count - 1;
      }
      count++;
    }
  }
}
