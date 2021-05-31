import 'dart:io';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:yuedu/model/bookModel.dart';
import 'package:yuedu/model/pageModel.dart';
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
    setDesignWHD(375, 812);

    LocalStorage ls = LocalStorage();
    ls.setupShelf();

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
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: ReadPage(),
      ),
    );
  }
}
