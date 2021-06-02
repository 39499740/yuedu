import 'package:flutter/cupertino.dart';
import 'package:yuedu/db/bookShelf.dart';
import 'package:yuedu/utils/book_reptile.dart';
import 'package:yuedu/utils/local_storage.dart';

class BookShelfModel with ChangeNotifier {
  List<BookInfo> _shelfBooks = [];

  List<BookInfo> get shelfBooks => _shelfBooks;

  LocalStorage ls = LocalStorage();



  void updateShelf() {
    // _shelfBooks = ls.getShelf();
    notifyListeners();
  }

  Future<void> setupProvider() async {
    LocalStorage ls = LocalStorage();
    await ls.setupLocalStorage();
    _shelfBooks = (await ls.getAllBooksFromLocalStorage())!;
    notifyListeners();
  }

  bool isBookExist(BookInfo b){
    bool exist = false;
    for(BookInfo book in _shelfBooks){
      if (b.link == book.link){
        exist = true;
        break;
      }
    }
    return exist;

  }

  Future<void> addBookToShelf(BookInfo b) async {
    LocalStorage ls = LocalStorage();
    BookInfo book =  await ls.insertBookToLocalstorage(b);
    _shelfBooks.insert(0, book);
    notifyListeners();
  }

  Future<void> removeBookFromShelf(BookInfo b) async {
    LocalStorage ls = LocalStorage();
    await ls.deleteBookFromLocalStorage(b);
    for(BookInfo book in _shelfBooks){
      if (b.id == book.id){
        _shelfBooks.remove(book);
        break;
      }
    }
    notifyListeners();
  }

}
