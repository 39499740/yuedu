
import 'package:bot_toast/bot_toast.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuedu/model/bookDetailModel.dart';
import 'package:yuedu/model/bookShelfModel.dart';
import 'package:yuedu/pages/bookdetail/book_detail_catalogue_page.dart';
import 'package:yuedu/pages/bookdetail/book_detail_page.dart';
import 'package:yuedu/pages/read/read_page.dart';
import 'package:yuedu/pages/tab/tab_page.dart';


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
        ChangeNotifierProvider(create: (context) {
          return BookShelfModel();
        }),
        ChangeNotifierProvider(create: (context) {
          return BookDetailModel();
        })
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          builder: BotToastInit(),
          navigatorObservers: [BotToastNavigatorObserver()],
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          onGenerateRoute: (settings) {
            if (settings.name == '/') {
              return MaterialPageRoute(
                  builder: (context) => TabPage(),
                  settings: RouteSettings(name: settings.name));
            }
            var uri = Uri.parse(settings.name!);
            switch (uri.pathSegments.first) {
              // case "login":
              //   return MaterialPageRoute(
              //       builder: (context) => LoginPage(),
              //       settings: RouteSettings(name: settings.name));
              case "main":
                return MaterialPageRoute(
                    builder: (context) => TabPage(),
                    settings: RouteSettings(name: settings.name));
              case "bookDetail":
                return MaterialPageRoute(
                    builder: (context) => BookDetailPage(),
                    settings: RouteSettings(name: settings.name));
              case "bookDetailCatalogue":
                return MaterialPageRoute(
                    builder: (context) => BookDetailCataloguePage(),
                    settings: RouteSettings(name: settings.name));
              case "read":
                return MaterialPageRoute(
                    builder: (context) => ReadPage(),
                    settings: RouteSettings(name: settings.name));
            }
            return MaterialPageRoute(
                builder: (context) => TabPage(),
                settings: RouteSettings(name: settings.name));
          }),
    );
  }
}
