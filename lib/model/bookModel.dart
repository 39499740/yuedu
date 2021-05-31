
import 'package:flutter/cupertino.dart';
import 'package:yuedu/utils/book_reptile.dart';
import 'package:yuedu/utils/local_storage.dart';

class BookModel with ChangeNotifier{
  List<BookInfo> _shelfBooks = [];
  List<BookInfo> get shelfBooks => _shelfBooks;

  LocalStorage ls = LocalStorage();

  void updateShelf(){
    // _shelfBooks = ls.getShelf();
    notifyListeners();
  }

}