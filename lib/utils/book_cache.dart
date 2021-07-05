/*
 * @Date: 2021-06-21 15:52:36
 * @LastEditors: 郝怿
 * @LastEditTime: 2021-07-05 09:00:14
 * @FilePath: /yuedu/lib/utils/book_cache.dart
 */
import 'package:yuedu/db/bookShelf.dart';

import 'book_reptile.dart';

class BookCache {
  factory BookCache() => _getInstance();

  static BookCache get instance => _getInstance();

  static BookCache? _instance;

  BookCache._internal();

  static BookCache _getInstance() {
    if (_instance == null) {
      _instance = new BookCache._internal();
    }
    return _instance!;
  }

  Set _cacheSet = {};

  Future<void> cacheBook(BookInfo b, List<BookCatalogue> bl) async {
    Future bc1, bc2, bc3;
    List<Future> downloadList = [];
    for (int i = 0; i < bl.length; i += 3) {
      if (bl[i].content == "") {
        bc1 = Future(() async {
          await getContent(bl[i]);
        });
        downloadList.add(bc1);
      }
      if (i + 1 < bl.length && bl[i + 1].content == "") {
        bc2 = Future(() async {
          await getContent(bl[i + 1]);
        });
        downloadList.add(bc2);
      }
      if (i + 2 < bl.length && bl[i + 2].content == "") {
        bc3 = Future(() async {
          await getContent(bl[i + 2]);
        });
        downloadList.add(bc3);
      }
      Future.wait(downloadList).then((value) {}).catchError((error) {
        print(error.toString());
      });
    }

    return;
  }

  bool isCacheNow(String link) {
    return _cacheSet.contains(link);
  }

  Future<BookCatalogue> getContent(BookCatalogue bc) async {
    if (bc.content == "") {
      if (!_cacheSet.contains(bc.link)) {
        _cacheSet.add(bc.link);
        bc.content = await BookReptile.getBookContentWithCatalouge(bc);
        _cacheSet.remove(bc.link);
      }
    }
    return bc;
  }
}
