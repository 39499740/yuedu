import 'package:battery/battery.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:yuedu/db/bookShelf.dart';
import 'package:yuedu/utils/Paging_tools.dart';
import 'package:yuedu/utils/book_cache.dart';
import 'package:yuedu/utils/book_reptile.dart';
import 'package:yuedu/utils/local_storage.dart';
import 'package:yuedu/utils/tools.dart';

class BookDetailModel with ChangeNotifier {
  late BookInfo _openBookInfo = BookInfo();

  BookCache cache = BookCache();

  BookInfo get openBookInfo => _openBookInfo;

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

  int _batteryLevel = 1;

  int get batteryLevel => _batteryLevel;

  String _dateTimeShow = "";

  String get dateTimeShow => _dateTimeShow;

  double _catalogureSliderValue = 1;

  double get catalogureSliderValue => _catalogureSliderValue;

  Set _cacheSet = {};

  bool _enableCache = false;

  bool get enableCache => _enableCache;
  bool _caching = false;

  bool get caching => _caching;

//向本地添加新的章节
  Future<void> addCatalogureToLocalStorage() async {
    LocalStorage ls = LocalStorage();
    _openBookCatalogue = await ls.insertBookCatalogueToLocalStorage(
        _openBookInfo, _openBookCatalogue);
    notifyListeners();
  }

//更新时间和电池电量
  Future<void> updateTotalData() async {
    _batteryLevel = await Battery().batteryLevel;
    _dateTimeShow = DateUtil.formatDate(DateTime.now(), format: "HH:mm");
    notifyListeners();
  }

//跳转到某个章节
  Future<void> jumpToCatalogue(int index) async {
    _nowCatalogueIndex = index - 1;
    if (_openBookInfo.id != null) {
      _openBookInfo.bookmarkCatalogureId =
          _openBookCatalogue[_nowCatalogueIndex!].id!;
      _openBookInfo.bookmarkCatalogureTitle =
          _openBookCatalogue[_nowCatalogueIndex!].title;
      _openBookInfo.bookmarkWordCount = 1;
    }
    _nowPage = 1;
    await refreshBook();
  }

//更新进度条
  void updateSliderValue(double v) {
    _catalogureSliderValue = v;
    notifyListeners();
  }

//翻页
  Future<void> pageTurning(bool pageDown) async {
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
            if (_openBookInfo.id != null) {
              saveContentToLocalStorage(
                  _openBookCatalogue[_nowCatalogueIndex!]);
            }
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
            if (_openBookInfo.id != null) {
              saveContentToLocalStorage(
                  _openBookCatalogue[_nowCatalogueIndex!]);
            }
          }
          _nowStrList = PagingTool.pagingContent(
              _openBookCatalogue[_nowCatalogueIndex!].content,
              ScreenTools.getSize(50),
              _textAreaWidth,
              _textAreaHeight);
          _totalPage = _nowStrList.length;
          _nowPage = totalPage!;
        }
      } else {
        _nowPage--;
      }
    }
    _showStr = _nowStrList[_nowPage - 1];
    _catalogureSliderValue = _nowCatalogueIndex! + 1;
    cacheContent();
    if (_openBookInfo.id != null) {
      refreshCacheIcon();
      _openBookInfo.bookmarkCatalogureId =
          _openBookCatalogue[_nowCatalogueIndex!].id!;
      _openBookInfo.bookmarkCatalogureTitle =
          _openBookCatalogue[_nowCatalogueIndex!].title;
      int tempWordCount = 1;
      for (int i = 0; i < _nowStrList.length; i++) {
        if (i < _nowPage - 1) {
          tempWordCount += _nowStrList[i].length;
        } else {
          break;
        }
      }
      _openBookInfo.bookmarkWordCount = tempWordCount;
    }

    notifyListeners();
  }

  //缓存章节前后10章
  void cacheContent() {
    for (int i = _nowCatalogueIndex! - 10; i < _nowCatalogueIndex! + 10; i++) {
      if (i > 0 && i < _openBookCatalogue.length) {
        getContent(i);
      }
    }
  }

//缓存章节
  Future<void> getContent(int index) async {
    BookCatalogue bc = _openBookCatalogue[index];

    if (bc.content == "") {
      bc = await cache.getContent(bc);
      if (bc.content != "") {
        _openBookCatalogue[index] = bc;
        if (_openBookInfo.id != null) {
          saveContentToLocalStorage(bc);
          refreshCacheIcon();
        }
      }
    }
  }

//更新缓存按钮图标
  void refreshCacheIcon() {
    bool cacheIcon = false;
    if (_caching) {
      _enableCache = false;
    } else {
      for (BookCatalogue bc in _openBookCatalogue) {
        if (bc.content == "") {
          cacheIcon = true;
          break;
        }
      }
      _enableCache = cacheIcon;
    }

    notifyListeners();
  }

//退出阅读清理变量
  void readViewDispose() {
    _showStr = "正在加载数据……";
    _nowCatalogueIndex = null;
    _textAreaHeight = 0;
    _textAreaWidth = 0;
    _totalPage = null;
    _nowPage = 0;
    _nowStrList = [];
    _catalogureSliderValue = 1;
  }

//初始化长宽
  void setupWH(double width, height) {
    _textAreaWidth = width;
    _textAreaHeight = height;
  }

//刷新书
  Future<void> refreshBook() async {
    if (_nowCatalogueIndex == null) {
      if (_openBookInfo.bookmarkCatalogureId != null) {
        for (int i = 0; i < _openBookCatalogue.length; i++) {
          if (_openBookCatalogue[i].id == _openBookInfo.bookmarkCatalogureId) {
            _nowCatalogueIndex = i;
            break;
          }
        }
      } else {
        _nowCatalogueIndex = 0;
      }
    }
    if (_openBookCatalogue[_nowCatalogueIndex!].content == "") {
      BotToast.showLoading();
      _openBookCatalogue[_nowCatalogueIndex!].content =
          await BookReptile.getBookContentWithCatalouge(
              _openBookCatalogue[_nowCatalogueIndex!]);
      BotToast.closeAllLoading();

      if (_openBookInfo.id != null) {
        saveContentToLocalStorage(_openBookCatalogue[_nowCatalogueIndex!]);
      }
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

        if (_openBookInfo.bookmarkWordCount! <= tempCount) {
          _nowPage = i + 1;
          break;
        }
      }
    } else {
      _nowPage = 1;
    }
    _showStr = _nowStrList[_nowPage - 1];
    _catalogureSliderValue = _nowCatalogueIndex! + 1;
    cacheContent();
    if (_openBookInfo.id != null) {
      refreshCacheIcon();
      _openBookInfo.bookmarkCatalogureId =
          _openBookCatalogue[_nowCatalogueIndex!].id!;
      _openBookInfo.bookmarkCatalogureTitle =
          _openBookCatalogue[_nowCatalogueIndex!].title;
      int tempWordCount = 1;
      for (int i = 0; i < _nowStrList.length; i++) {
        if (i < _nowPage - 1) {
          tempWordCount += _nowStrList[i].length;
        } else {
          break;
        }
      }
      _openBookInfo.bookmarkWordCount = tempWordCount;
    }
    notifyListeners();
  }

//打开书
  Future<void> openBook(BookInfo b) async {
    readViewDispose();
    _openBookInfo = b;
    if (b.id != null) {
      LocalStorage ls = LocalStorage();
      _openBookCatalogue = await ls.getAllCatalogueFromLocalStorage(b.id!);
    }
    notifyListeners();
  }

//清除打开书
  void cleanOpenData() {
    readViewDispose();
    _openBookCatalogue = [];
    _openBookInfo = BookInfo();
  }

//初始化章节列表
  void setupCatalogue(List<BookCatalogue> bc) {
    _openBookCatalogue = bc;
    notifyListeners();
  }

//更新内容
  void updateContent(int index, String content) {
    _openBookCatalogue[index].content = content;
    notifyListeners();
  }

//存入章节内容到本地
  Future<void> saveContentToLocalStorage(BookCatalogue bc) async {
    LocalStorage ls = LocalStorage();
    await ls.updateBookCatalogueInLocaStorage(bc);
  }

//缓存全本
  void cacheFullBook() async {
    _caching = true;

    for (int i = 0; i < openBookCatalogue.length; i++) {
      if (openBookCatalogue[i].content == "") {
        await getContent(i);
      }
    }
    _caching = false;
    notifyListeners();
  }
}
