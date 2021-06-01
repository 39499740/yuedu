import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yuedu/db/bookShelf.dart';
import 'package:yuedu/pages/search/widget/book_item.dart';
import 'package:yuedu/utils/book_reptile.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<BookInfo> resultBookList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xffffffff),
        elevation: 0,
        title: CupertinoTextField(
          placeholder: "请输入书名/作者名",
          controller: _searchController,
          textInputAction: TextInputAction.search,
          onEditingComplete: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            if (_searchController.text.replaceAll(" ", "") != "") {
              resultBookList = await BookReptile.getBookListWithKeyWord(
                  _searchController.text);
              setState(() {
              });
            }
          },
        ),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return BookItemCell(b: resultBookList[index]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
          itemCount: resultBookList.length),
    );
  }
}
