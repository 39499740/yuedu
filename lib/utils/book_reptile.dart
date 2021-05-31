import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;

import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';


class BookReptile {
  static Future<List<BookInfo>> getBookListWithKeyWord(String keyWorld) async {
    List<BookInfo> searchResultList = [];
    var url = Uri.parse('https://www.biquge7.com/s?q=' + keyWorld);
    var response = await http.get(url);
    var document = parse(response.body);

    var temp = document.querySelectorAll(".bookbox");
    temp.forEach((element) {
      searchResultList.add(BookInfo().fromElement(element));
    });
    return searchResultList;
  }
}


class BookInfo {
  late String imgUrl;
  late String title;
  late String link;
  late String cat;
  late String author;
  late String updateTime;
  late String detail;
  late String lastUpdate;
  late String uuid;

  BookInfo fromElement(Element element) {
    BookInfo b = BookInfo();
    b.imgUrl = element
        .querySelector(".bookimg")!
        .querySelector("img")!
        .attributes['src']
        .toString();
    b.title = element.querySelector(".bookname")!.text;
    b.link = element
        .querySelector(".bookname")!
        .querySelector("a")!
        .attributes['href']
        .toString();
    b.cat = element.querySelector(".cat")!.text.replaceAll("分类：", "");
    b.author = element.querySelector(".author")!.text.replaceAll("作者：", "");
    b.updateTime =
        element.querySelector(".uptime")!.text.replaceAll("更新时间：", "");
    b.lastUpdate = element.querySelector(".update")!.querySelector("a")!.text;
    b.detail = element.querySelector("p")!.text;
    b.uuid = Uuid().v4();
    return b;
  }
}
