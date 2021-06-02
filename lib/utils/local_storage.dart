import 'package:sqflite/sqflite.dart';
import 'package:yuedu/db/bookShelf.dart';
import 'package:yuedu/utils/book_reptile.dart';

class LocalStorage {
  factory LocalStorage() => _getInstance();

  static LocalStorage get instance => _getInstance();

  static LocalStorage? _instance;

  LocalStorage._internal() {}

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

  Future<void> deleteBookFromLocalStorage(BookInfo b) async {
    await bookShelfProvider.delete(b.id!);
  }

  Future<BookInfo?> getBookFromLocalStorage(int id) async {
    return await bookShelfProvider.getBookInfo(id);
  }

  Future<List<BookInfo>?>getAllBooksFromLocalStorage() async {
    return await bookShelfProvider.getAllBooks();
  }



}


