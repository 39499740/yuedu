import 'dart:io';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:yuedu/model/bookModel.dart';
import 'package:yuedu/model/pageModel.dart';
import 'package:yuedu/pages/bookshelf/book_shelf_page.dart';
import 'package:yuedu/pages/tab/tab_page.dart';
import 'package:yuedu/read_page.dart';
import 'package:yuedu/utils/global_data.dart';
import 'package:yuedu/utils/local_storage.dart';
import 'package:yuedu/utils/tools.dart';

Future<void> main() async {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    setDesignWHD(1125, 2436);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            return PageModel();
          },
        ),
        ChangeNotifierProvider(create: (context) {
          return BookModel();
        })
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(

          primarySwatch: Colors.blue,
        ),
        home: TabPage(),
      ),
    );
  }



}
