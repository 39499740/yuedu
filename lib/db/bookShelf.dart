import 'package:html/dom.dart';
import 'package:sqflite/sqflite.dart';

final String columnImgUrl = "imageUrl";
final String columnTitle = "title";
final String columnLink = "link";
final String columnCat = "cat";
final String columnAuthor = "author";
final String columnUpdateTime = "updateTime";
final String columnDetail = "detail";
final String columnLastUpdate = "lastUpdate";
final String columnId = "_id";
final String columnCTitle = "cTitle";
final String columnCId = "cId";
final String columnWordCount = "wordCount";
final String columnLastOpen = "lastopen";

final String tableBookShelf = "bookshelf";

final String columnBookId = "bookid";
final String columnContent = "content";
final String tableBookCatalogue = "bookcatalogue";

class BookShelfProvider {
  late Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableBookShelf ( 
  $columnId integer primary key autoincrement, 
  $columnTitle text not null,
    $columnLink text not null,
  $columnCat text not null,
  $columnAuthor text not null,
  $columnUpdateTime text not null,
  $columnDetail text not null,
  $columnLastUpdate text not null,
  $columnImgUrl text not null,
  $columnCTitle text,
  $columnCId int,
  $columnWordCount int,
  $columnLastOpen int 
  )
  ''');
      await db.execute('''
  create table $tableBookCatalogue (
    $columnId integer primary key autoincrement, 
    $columnTitle text not null,
    $columnLink text not null,
    $columnContent text,
    $columnBookId int not null
    )
    ''');
    });
  }

  Future<BookInfo> insert(BookInfo info) async {
    info.lastOpen = DateTime.now().millisecondsSinceEpoch;
    info.id = await db.insert(tableBookShelf, info.toMap());
    return info;
  }

  Future<BookInfo?> getBookInfo(int id) async {
    List<Map> maps = await db.query(tableBookShelf,
        columns: [
          columnId,
          columnImgUrl,
          columnTitle,
          columnLink,
          columnCat,
          columnAuthor,
          columnUpdateTime,
          columnDetail,
          columnLastUpdate,
          columnCTitle,
          columnCId,
          columnWordCount,
          columnLastOpen,
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return BookInfo.fromMap(maps.first);
    }
    return null;
  }

  Future<List<BookCatalogue>> getCatalogueList(int bid) async {
    List<Map> maps = await db.query(tableBookCatalogue,
        columns: [
          columnId,
          columnTitle,
          columnLink,
          columnBookId,
          columnContent
        ],
        where: '$columnBookId = ?',
        whereArgs: [bid]);
    List<BookCatalogue> bcList = [];
    if (maps.length > 0) {
      for (Map m in maps) {
        bcList.add(BookCatalogue.fromMap(m));
      }
    }
    return bcList;
  }

  Future<List<BookInfo>> getAllBooks() async {
    List<Map> maps = await db.query(
      tableBookShelf,
      columns: [
        columnId,
        columnImgUrl,
        columnTitle,
        columnLink,
        columnCat,
        columnAuthor,
        columnUpdateTime,
        columnDetail,
        columnLastUpdate,
        columnCTitle,
        columnCId,
        columnWordCount,
        columnLastOpen,
      ],
      orderBy: '$columnLastOpen DESC',
    );
    List<BookInfo> bookList = [];
    for (Map m in maps) {
      bookList.add(BookInfo.fromMap(m));
    }
    return bookList;
  }

  Future<void> delete(int id) async {
    await db.delete(tableBookShelf, where: '$columnId = ?', whereArgs: [id]);
    await db.delete(tableBookCatalogue,
        where: '$columnBookId = ?', whereArgs: [id]);
  }

  Future<int> updateBook(BookInfo info) async {
    info.lastOpen = DateTime.now().millisecondsSinceEpoch;
    return await db.update(tableBookShelf, info.toMap(),
        where: '$columnId = ?', whereArgs: [info.id]);
  }
  Future<int> updateCatalogue(BookCatalogue bc) async {
    return await db.update(tableBookCatalogue, bc.toMap(),
        where: '$columnId = ?', whereArgs: [bc.id]);
  }

  Future<List<BookCatalogue>> insertAllCatalogue(
      List<BookCatalogue> bcl) async {
    var batch = db.batch();

    bcl.forEach((bc) {
      batch.insert(tableBookCatalogue, bc.toMap());
    });
    batch.commit();
    List<Map> maps = await db.query(tableBookCatalogue,
        columns: [
          columnId,
          columnTitle,
          columnLink,
          columnBookId,
          columnContent
        ],
        where: '$columnBookId = ?',
        whereArgs: [bcl[0].bookId]);
    List<BookCatalogue> bcList = [];
    if (maps.length > 0) {
      for (Map m in maps) {
        bcList.add(BookCatalogue.fromMap(m));
      }
    }
    return bcList;
  }

  Future<List<BookCatalogue>> getUnDownloadCatalogues(BookInfo info) async{
    List<Map> maps = await db.query(
      tableBookCatalogue,
      columns: [
        columnId,
        columnTitle,
        columnLink,
        columnContent,
        columnBookId
      ],
      where:'$columnContent = ? and $columnBookId = ?',
      whereArgs: ["",info.id]
    );
    List<BookCatalogue> bcl = [];
    for (Map m in maps) {
      bcl.add(BookCatalogue.fromMap(m));
    }
    return bcl;
  }

  Future close() async => db.close();
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
  int? lastOpen;
  String? bookmarkCatalogureTitle;
  int? bookmarkCatalogureId;
  int? bookmarkWordCount;
  int? id;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnImgUrl: imgUrl,
      columnTitle: title,
      columnLink: link,
      columnCat: cat,
      columnAuthor: author,
      columnUpdateTime: updateTime,
      columnDetail: detail,
      columnLastUpdate: lastUpdate,
      columnCTitle: bookmarkCatalogureTitle,
      columnCId: bookmarkCatalogureId,
      columnWordCount: bookmarkWordCount,
      columnLastOpen: lastOpen
    };

    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  BookInfo();

  BookInfo.fromMap(Map map) {
    id = map[columnId];
    title = map[columnTitle];
    imgUrl = map[columnImgUrl];
    link = map[columnLink];
    cat = map[columnCat];
    author = map[columnAuthor];
    updateTime = map[columnUpdateTime];
    detail = map[columnDetail];
    lastUpdate = map[columnLastUpdate];
    bookmarkCatalogureTitle = map[columnCTitle];
    bookmarkCatalogureId = map[columnCId];
    bookmarkWordCount = map[columnWordCount];
    lastOpen = map[columnLastOpen];
  }

  BookInfo fromElement(Element element) {
    BookInfo b = BookInfo();
    b.imgUrl = element
        .querySelector(".bookimg")!
        .querySelector("img")!
        .attributes['src']
        .toString();
    b.title = element.querySelector(".bookname")!.text;
    b.link = "https://www.biquge7.com" +
        element
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
    return b;
  }
}

class BookCatalogue {
  late String title;
  late String link;
  int? bookId;
  late String content;
  int? id;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: title,
      columnLink: link,
      columnBookId: bookId,
      columnContent: content
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  BookCatalogue();

  BookCatalogue.fromMap(Map map) {
    title = map[columnTitle];
    link = map[columnLink];
    bookId = map[columnBookId];
    content = map[columnContent];
    id = map[columnId];
  }

  BookCatalogue fromElement(Element element, int? bookId) {
    BookCatalogue bc = BookCatalogue();
    bc.title = element.querySelector("a")!.text;
    bc.link = "https://www.biquge7.com" +
        element.querySelector("a")!.attributes['href'].toString();
    bc.content = "";
    if (bookId != null) {
      bc.bookId = bookId;
    }
    return bc;
  }

}
