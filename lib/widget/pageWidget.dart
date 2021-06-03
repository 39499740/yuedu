import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuedu/model/bookDetailModel.dart';
import 'package:yuedu/utils/tools.dart';

import '../textfile.dart';

class PageWidget extends StatefulWidget {
  PageWidget({Key? key}) : super(key: key);

  @override
  _PageWidgetState createState() => _PageWidgetState();
}

class _PageWidgetState extends State<PageWidget> {
  List<String> pageStrList = [];
  bool isFirstOpen = true;

  @override
  void initState() {
    super.initState();
  }
  setup(){
    isFirstOpen = false;

      Timer(Duration(milliseconds: 500), () {
        Provider.of<BookDetailModel>(context, listen: false)
            .setupWH(context.size!.width, context.size!.height);
        Provider.of<BookDetailModel>(context, listen: false).refreshBook();
      });
  }



  @override
  Widget build(BuildContext context) {
    if(isFirstOpen){
      setup();
      print(ScreenTools.getSize(30));
    }
    return Stack(
      children: [
        Container(
          child: Text(
            Provider.of<BookDetailModel>(context, listen: true).showStr,
            style: TextStyle(fontSize: ScreenTools.getSize(50), height: 2),
          ),
        )
      ],
    );
  }
}
