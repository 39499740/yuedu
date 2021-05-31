
import 'package:flutter/material.dart';

class PageModel with ChangeNotifier{
  double _pageWidth = 0;
  double _pageHeight = 0;
  double get pageWidth => _pageWidth;
  double get pageHeight => _pageHeight;
  int _totalPage = 0;
  int _nowPage = 0;
  int get totalPage => _totalPage;
  int get nowPage => _nowPage;

  String _capterTitle = "";
  String get capterTitle => _capterTitle;

  void setupChapterData(int total,String title){
    _totalPage = total;
    _nowPage = 1;
    _capterTitle = title;
    notifyListeners();
  }

  void updateNowPageNum(int pageNum){
    _nowPage = pageNum;
    notifyListeners();

  }

  void setTextAreaWH(double width, height) {
    _pageWidth = width;
    _pageHeight = height;
    notifyListeners();
  }



}