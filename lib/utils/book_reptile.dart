import 'package:html/parser.dart' show parse;

import 'package:http/http.dart' as http;
import 'package:yuedu/db/bookShelf.dart';


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

  static Future<List<BookCatalogue>> getBookCatalogueWithBookInfo(
      BookInfo b) async {
    List<BookCatalogue> resultList = [];
    var url = Uri.parse(b.link);
    var response = await http.get(url);
    var document = parse(response.body);
    var temp = document.querySelectorAll(".listmain").first.querySelectorAll("dd");
    temp.forEach((element) {
      resultList.add(BookCatalogue().fromElement(element, b.id));
    });

    return resultList;
  }
}

