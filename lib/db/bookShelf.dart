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
  $columnImgUrl text not null
  )
''');
    });
  }

  Future<BookInfo> insert(BookInfo info) async {
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
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return BookInfo.fromMap(maps.first);
    }
    return null;
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
      ],
    );
    List<BookInfo> bookList = [];
    for (Map m in maps) {
      bookList.add(BookInfo.fromMap(m));
    }
    return bookList;
  }

  Future<int> delete(int id) async {
    return await db
        .delete(tableBookShelf, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(BookInfo info) async {
    return await db.update(tableBookShelf, info.toMap(),
        where: '$columnId = ?', whereArgs: [info.id]);
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
    };
    print(id);
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
