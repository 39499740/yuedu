import 'dart:html';

import 'package:extended_sliver/extended_sliver.dart';
import 'package:flutter/material.dart';
import 'package:yuedu/db/bookShelf.dart';
import 'package:yuedu/utils/tools.dart';

class BookDetailPage extends StatefulWidget {
  BookInfo b;

  BookDetailPage({Key? key, required this.b}) : super(key: key);

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: CustomScrollView(slivers: <Widget>[
          ExtendedSliverAppbar(
            title: Text(
              "${widget.b.title}",
              style: TextStyle(fontSize: ScreenTools.getSize(50)),
            ),
            leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.white,
            ),
            background:  DefaultTextStyle(
              style: TextStyle(color: Colors.white),
              child: Stack(
                children: [

                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
