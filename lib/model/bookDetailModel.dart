import 'package:flutter/cupertino.dart';
import 'package:yuedu/db/bookShelf.dart';

class BookDetailModel with ChangeNotifier {
  late BookInfo _openBookInfo = BookInfo();

  BookInfo get openBookInfo => _openBookInfo;

  List<BookCatalogue> _openBookCatalogue = [];

  List<BookCatalogue> get openBookCatalogue => _openBookCatalogue;

  void openBook(BookInfo b) {
    _openBookInfo = b;
    notifyListeners();
  }

  void setupCatalogue(List<BookCatalogue> bc) {
    _openBookCatalogue = bc;
    notifyListeners();
  }

  void updateContent(int index, String content) {
    _openBookCatalogue[index].content = content;
    notifyListeners();
  }
}
