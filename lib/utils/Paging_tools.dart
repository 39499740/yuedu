import 'package:flutter/material.dart';

class PagingTool {
  static List<String> pagingContent(
      String content, double textSize, width, height) {
    List<String> pageList = [];
    int count = 1;
    bool getCount = false;
    while (true) {
      if (content.startsWith("\n")) {
        content = content.replaceFirst("\n", "");
      }
      if (content.length == 0) {
        break;
      }
      if (count > content.length) {
        pageList.add(content);
        break;
      }
      final painter = TextPainter(
          text: TextSpan(
            text: content.substring(0, count),
            style: TextStyle(fontSize: textSize.toInt().toDouble(), height: 2),
          ),
          textDirection: TextDirection.ltr);
      painter.layout(minWidth: width.toInt().toDouble(), maxWidth: width.toInt().toDouble());
      if (painter.size.height > height.toInt().toDouble()) {
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
}
