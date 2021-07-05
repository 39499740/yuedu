/*
 * @Date: 2021-06-03 19:57:52
 * @LastEditors: 郝怿
 * @LastEditTime: 2021-07-02 10:49:41
 * @FilePath: /yuedu/lib/utils/local_storage.dart
 */
import 'package:sqflite/sqflite.dart';
import 'package:yuedu/db/bookShelf.dart';

class LocalStorage {
  factory LocalStorage() => _getInstance();

  static LocalStorage get instance => _getInstance();

  static LocalStorage? _instance;

  LocalStorage._internal();

  static LocalStorage _getInstance() {
    if (_instance == null) {
      _instance = new LocalStorage._internal();
    }
    return _instance!;
  }

  late BookShelfProvider bookShelfProvider;

  Future<void> setupLocalStorage() async {
    bookShelfProvider = BookShelfProvider();
    var databasePath = await getDatabasesPath();
    String path = databasePath + "/book.db";
    await bookShelfProvider.open(path);
  }

  Future<BookInfo> insertBookToLocalstorage(BookInfo b) async {
    return await bookShelfProvider.insert(b);
  }

  Future<List<BookCatalogue>> insertBookCatalogueToLocalStorage(
      BookInfo b, List<BookCatalogue> bcl) async {
    for (BookCatalogue bc in bcl) {
      bc.bookId = b.id;
    }
    return await bookShelfProvider.insertAllCatalogue(bcl);
  }

  Future<void> updateBookInfoinLocalStorage(BookInfo b) async {
    await bookShelfProvider.updateBook(b);
  }

  Future<void> updateBookCatalogueInLocaStorage(BookCatalogue bc) async {
    await bookShelfProvider.updateCatalogue(bc);
  }

  Future<void> deleteBookFromLocalStorage(BookInfo b) async {
    await bookShelfProvider.delete(b.id!);
  }

  Future<BookInfo?> getBookFromLocalStorage(int id) async {
    return await bookShelfProvider.getBookInfo(id);
  }

  Future<List<BookInfo>?> getAllBooksFromLocalStorage() async {
    return await bookShelfProvider.getAllBooks();
  }

  Future<List<BookCatalogue>> getAllCatalogueFromLocalStorage(int bid) async {
    return await bookShelfProvider.getCatalogueList(bid);
  }
}
