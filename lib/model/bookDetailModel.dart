import 'package:battery/battery.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:yuedu/db/bookShelf.dart';
import 'package:yuedu/pages/bookdetail/book_detail_page.dart';
import 'package:yuedu/utils/Paging_tools.dart';
import 'package:yuedu/utils/book_reptile.dart';
import 'package:yuedu/utils/tools.dart';

class BookDetailModel with ChangeNotifier {
  late BookInfo _openBookInfo = BookInfo();

  BookInfo get openBookInfo => _openBookInfo;
  int _batteryLevel = 0;

  int get batteryLevel => _batteryLevel;

  List<BookCatalogue> _openBookCatalogue = [];

  List<BookCatalogue> get openBookCatalogue => _openBookCatalogue;

  int? _nowCatalogueIndex;

  int? get nowCatalogueIndex => _nowCatalogueIndex;
  int? _totalPage;

  int? get totalPage => _totalPage;
  int _nowPage = 0;

  int get nowPage => _nowPage;

  String _showStr = "正在加载数据……";

  String get showStr => _showStr;

  double _textAreaWidth = 0;
  double _textAreaHeight = 0;

  double get textAreaWidth => _textAreaWidth;

  double get textAreaHeight => _textAreaHeight;

  List<String> _nowStrList = [];

  List<String> get nowStrList => _nowStrList;

  Future<void> pageTurning(bool pageDown) async {
    _batteryLevel = await Battery().batteryLevel;
    if (pageDown) {
      if (_nowPage == totalPage) {
        if (_nowCatalogueIndex == _openBookCatalogue.length - 1) {
          BotToast.showText(text: "最后一页了");
        } else {
          _nowCatalogueIndex = _nowCatalogueIndex! + 1;
          if (_openBookCatalogue[_nowCatalogueIndex!].content == "") {
            _openBookCatalogue[_nowCatalogueIndex!].content =
                await BookReptile.getBookContentWithCatalouge(
                    _openBookCatalogue[_nowCatalogueIndex!]);
          }
          _nowStrList = PagingTool.pagingContent(
              _openBookCatalogue[_nowCatalogueIndex!].content,
              ScreenTools.getSize(50),
              _textAreaWidth,
              _textAreaHeight);
          _totalPage = _nowStrList.length;
          _nowPage = 1;
        }
      } else {
        _nowPage++;
      }
    } else {
      if (_nowPage == 1) {
        if (_nowCatalogueIndex == 0) {
          BotToast.showText(text: "已经是第一页了");
        } else {
          _nowCatalogueIndex = _nowCatalogueIndex! - 1;
          if (_openBookCatalogue[_nowCatalogueIndex!].content == "") {
            _openBookCatalogue[_nowCatalogueIndex!].content =
                await BookReptile.getBookContentWithCatalouge(
                    _openBookCatalogue[_nowCatalogueIndex!]);
          }
          _nowStrList = PagingTool.pagingContent(
              _openBookCatalogue[_nowCatalogueIndex!].content,
              ScreenTools.getSize(30),
              _textAreaWidth,
              _textAreaHeight);
          _totalPage = _nowStrList.length;
          _nowPage = totalPage!;
        }
      } else {
        _nowPage--;
      }
      _showStr = _nowStrList[_nowPage - 1];
      notifyListeners();
    }
  }

  void readViewDispose() {
    _showStr = "正在加载数据……";
    _textAreaHeight = 0;
    _textAreaWidth = 0;
    _totalPage = null;
    _nowPage = 0;
    _nowStrList = [];
  }

  void setupWH(double width, height) {
    _textAreaWidth = width;
    _textAreaHeight = height;
    print(_textAreaWidth.toString() + "----" + _textAreaHeight.toString());
  }

  Future<void> refreshBook() async {
    if (_openBookInfo.bookmarkCatalogureId != null) {
      for (int i = 0; i < _openBookCatalogue.length; i++) {
        if (_openBookCatalogue[i].id == _openBookInfo.bookmarkCatalogureId) {
          _nowCatalogueIndex = i;
          break;
        }
      }
    }
    if (_nowCatalogueIndex == null) {
      _nowCatalogueIndex = 0;
    }
    if (_openBookCatalogue[_nowCatalogueIndex!].content == "") {
      _openBookCatalogue[_nowCatalogueIndex!].content =
          await BookReptile.getBookContentWithCatalouge(
              _openBookCatalogue[_nowCatalogueIndex!]);
    }
    _nowStrList = PagingTool.pagingContent(
        _openBookCatalogue[_nowCatalogueIndex!].content,
        ScreenTools.getSize(50),
        _textAreaWidth,
        _textAreaHeight);
    _totalPage = _nowStrList.length;
    if (_openBookInfo.bookmarkWordCount != null) {
      int tempCount = 0;
      for (int i = 0; i < _nowStrList.length; i++) {
        tempCount += _nowStrList[i].length;
        if (_openBookInfo.bookmarkWordCount! < tempCount) {
          _nowPage = i + 1;
        }
      }
    } else {
      _nowPage = 1;
    }
    _showStr = _nowStrList[_nowPage - 1];

    notifyListeners();
  }

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
